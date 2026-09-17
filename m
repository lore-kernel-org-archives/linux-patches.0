Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B82A4B7A38;
	Thu, 17 Sep 2026 18:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670547; cv=none; b=H7Quwi0HKN+xXkbLVK3ahPJK5+bq7SMxhelA9j9WK0Zf8kziNI5YdTWKGcJLnApTwc7MUQ6YzTetsTKaTR4SjvDnI6r8Y07tm5L0JdfjZo813qUdXnjXR13xCXovrgPu8s9DqxYpsoxJFJzbpvVXB2KDmoxVwjtn7nmp00Ru9pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670547; c=relaxed/simple;
	bh=oTgWDVzm+XAEqSpVDfM5CWIAy560QOz0QDnq2x1RjM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XRsUNIyrlHmACDt0Vt8uN1qf+kGDdhgpXJGGeASP8ltey4oSMMsrJZ9YIncxpn2MPneYhBgFpgNf7rhYKMfx8xs07C30aifJ02XpW1mWgU8DdRbYx5VLUuHho2PD51FNbXu2ET8ivTy632/cNiw4T+Nn6KsAtrQPelFTW8lX/gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=isE5F+JO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="isE5F+JO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846A11F000FF;
	Thu, 17 Sep 2026 18:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670546;
	bh=VMu8b9mDSc/ChNQ2U61z8UCDV+7/2+0of6CapaLg5uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=isE5F+JOTp7w/Qp5Krqk328ib1wiL1181J87qmbh7rCwg4sT2gPVPsnsO83lZ39m2
	 6fGbvXqJBQjYRhDYFxxZIavg4oYBHL0z1mselD3uq+01Bd5RrWyO20wk9SeeUKAmJw
	 AaC/dtRhU8QZ3Y/HhGAS/MmGBaKDW1xH2EV1PMd4=
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
Subject: [PATCH 6.12 0696/1102] net/sched: drr: clamp quantum in change class
Date: Thu, 17 Sep 2026 16:10:39 +0100
Message-ID: <20260917151557.764666017@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index faafb29056259..ba802db279932 100644
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



