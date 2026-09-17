Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06AD4E4C4F;
	Thu, 17 Sep 2026 15:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659609; cv=none; b=TSxS0VcMyNwjRnK+h2uRf8nNPXF5nvvygvwuw8+4gsZXGa/3AXWL6PJdQdTkQulutOITW514ozMGpPrKssYkDQk/8JgmmniAc9jwqT8sHH5cXq1QV1gfkidtm5RNiQfKPuE7IjBuFgkxWJMpXlgVCI6QAl9gXHRoiQUFPPJeDV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659609; c=relaxed/simple;
	bh=jhBaA4kpvoCtCaBC0sBu1Z0tSkfgVE7UHsEn9Z67zgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NEyOibS+1CviM2kXKIUnbLcjSIi38POOnF14obEg5mFcXGhMp2GOdFa/yJpws4fV5t28DOroo82JZ1mJnGX5I1lD9gD8t4QGGQ0DybfC7ri0NBjtna/StFumINjN/Ka75CsH11/j+MEC+mbloAFfjdjOdXdBvgvNlD+SljOpFCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0l7eYnr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0l7eYnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B9D1F00899;
	Thu, 17 Sep 2026 15:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659598;
	bh=NIkr23GV2h5IDd2LIY2u1SeivbLPHLyXYZIU6jQWcTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m0l7eYnrGYTNl5Q3wRLE+2wEHzRxnptjqrTpz3DVuZMyULswnoAtL5HCwY/KShb5s
	 +asynLEkNMdC/JaiMeyCqN3eOm9+bC6ViPMHlp9Ox0N2Ddq9DtHRiu0ajeaL21HsMi
	 sMBFFqWFI6Dh1NnY3lADqoXteL03NAGTW7gdsTZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 310/733] net/sched: drr: clamp quantum in change class
Date: Thu, 17 Sep 2026 16:10:18 +0100
Message-ID: <20260917151359.190576113@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 8382abec0f1568d0a5590d75a3df92f23fcf5196 ]

drr_change_class() rejects explicit quantum==0 but falls back to
psched_mtu() with no floor. With a crafted size table qdisc_pkt_len
reaches ~2 GiB, so quantum=1 (or a zero psched_mtu on a headerless
device) makes the deficit-refill loop spin under the qdisc lock.

Add clamp_t(u32, quantum, 256, 1<<20) after the zero reject and on the
fallback path. The explicit-zero reject is preserved.

Conditions to recreate the bug:
  CONFIG_NET_SCH_DRR=y. Requires CAP_NET_ADMIN (namespace-local via
  unshare -Urn suffices).

  tc qdisc add dev dummy0 root drr
  tc class add dev dummy0 parent 1: classid 1:1 drr quantum 1

Fixes: 13d2a1d2b032 ("pkt_sched: add DRR scheduler")
Reported-by: Vega <vega@nebusec.ai>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-0CFC.v3.20260901204856@mojatatu.com.8
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_drr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index 91b1ef824afaf..8621d057edd9f 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -82,8 +82,9 @@ static int drr_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 			NL_SET_ERR_MSG(extack, "Specified DRR quantum cannot be zero");
 			return -EINVAL;
 		}
+		quantum = clamp_t(u32, quantum, 256, 1 << 20);
 	} else
-		quantum = psched_mtu(qdisc_dev(sch));
+		quantum = clamp_t(u32, (u32)psched_mtu(qdisc_dev(sch)), 256, 1 << 20);
 
 	if (cl != NULL) {
 		if (tca[TCA_RATE]) {
-- 
2.53.0



