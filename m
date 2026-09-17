Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252B84B44DB;
	Thu, 17 Sep 2026 15:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659595; cv=none; b=Vw7mLvrkR1MrqkfZzlMlUk6aeFs3w671qQrXS1XJiTCVUoCSelVVFF7iVfnBto46auUeTwWpi/D9traGLI8VfhRfyimyGqatbTv0PCDNSpmDvfrF4ODlKJVusDKyOdbKMX54j4XpcGKQ8eSp7LXgwEp+L9rZsX8F1kPQwgwODEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659595; c=relaxed/simple;
	bh=SazD5qGrtxtng3tJn2xo2dunqcyDolKcDuwQ0dmWRvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uON5Zc3ynsGoHQVc1FgK//0K+7AncxJipFOFIhBCOZYYR/iBaLKHNNHDyirrXhc6Ae62prrOXYz5fgUCtGO+YpoZW4Nlm6dj4WOTBtp4nfVz9umK7r2/wCFGdHLh0X/yWjwqUJdZEa4bYLPiCMkuHqFfFGw9h2IZ8pWVYAahVrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqMtQB5S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqMtQB5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABCC1F000FF;
	Thu, 17 Sep 2026 15:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659586;
	bh=v/FI09N9MQ35GBN1O5j5DvW8iVHdpfB7TwCXfd7upAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sqMtQB5Se559E+8Q7fla+Bda7HaKUJiD1zaq2BG8+wq6V9CxRhD0hF/5GmyhYaooi
	 UwEOrvA00r1fdV59tb1zoHBC/dlTCZ290EncqZhVxavmIdlePauruReYv/fhAr+kpU
	 ImvdBwJM+OY53p4tBL3sWpVlG7TofHxTy4Y/Fl7c=
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
Subject: [PATCH 7.2 306/733] net/sched: sfq: clamp quantum in change path
Date: Thu, 17 Sep 2026 16:10:14 +0100
Message-ID: <20260917151359.076869401@linuxfoundation.org>
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

[ Upstream commit fb9f88a33c516ea5c0bcd9a22ca288b246b34567 ]

sfq_change() accepts any non-negative quantum (only rejects
(int)ctl->quantum < 0). With a crafted size table qdisc_pkt_len reaches
~2 GiB, so quantum=1 makes the deficit-refill loop spin ~2^31 times
under the qdisc lock (a soft lockup / denial of service).

Add max(256U, ...) matching fq_codel_change(). Reject quantum > 1<<20
with -EINVAL, matching fq_codel_change() and the init clamp.

Conditions to recreate the bug:
  CONFIG_NET_SCH_SFQ=y. Requires CAP_NET_ADMIN (namespace-local via
  unshare -Urn suffices).

  tc qdisc add dev dummy0 root sfq
  tc qdisc change dev dummy0 root sfq quantum 1 stab data 32768 size_log 15 cell_log 0

Fixes: e4650d7ae425 ("net_sched: sch_sfq: handle bigger packets")
Reported-by: Vega <vega@nebusec.ai>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-0CFC.v3.20260901204856@mojatatu.com.4
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_sfq.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index 187d3ed578f26..8bbcfc9e85d94 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -660,6 +660,11 @@ static int sfq_change(struct Qdisc *sch, struct nlattr *opt,
 		return -EINVAL;
 	}
 
+	if (ctl->quantum > 1 << 20) {
+		NL_SET_ERR_MSG_MOD(extack, "quantum too large");
+		return -EINVAL;
+	}
+
 	if (ctl->perturb_period < 0 ||
 	    ctl->perturb_period > INT_MAX / HZ) {
 		NL_SET_ERR_MSG_MOD(extack, "invalid perturb period");
@@ -688,7 +693,7 @@ static int sfq_change(struct Qdisc *sch, struct nlattr *opt,
 
 	/* update and validate configuration */
 	if (ctl->quantum)
-		quantum = ctl->quantum;
+		quantum = max(256U, ctl->quantum);
 	if (ctl->flows)
 		maxflows = min_t(u32, ctl->flows, SFQ_MAX_FLOWS);
 	if (ctl->divisor) {
-- 
2.53.0



