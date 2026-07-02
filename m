Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33DF33BBAD;
	Thu,  2 Jul 2026 16:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009341; cv=none; b=dXFE3FTYAfBF+P7HK706zOPpxJEN/jmrhK8dma220AW4wadDQdPUCIMl1iNQX83W4BRJfydAkvOqIRFmOH/R0H8ImRgxauM4Cb4k1E6TBlmilvfM26NhLT5N/z9urrP2dkWwcCA//DwcXG1GN5sq4Muq2YGfJV7By5YGFCGUNr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009341; c=relaxed/simple;
	bh=94REJ3BtEUPiLOyw9Akr9VdrzcTRSlyxVlS/JH1QjVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvrfLjjMBo1SuEb/Bp8NPX5DUxZRvRsEbjG5Lz/kMjMq8AsT58BWzhd0mpzCva6GbxeuNS13bFltmz1AZYBNUKZ338LfOPQ6ljzItl2SZfpI6wADPSxz2i2e6Ry8DN1r8a5UePGNSjSmcRbhaTytERHuD0MvwZJAyad1w+B79YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=caoR9WrC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="caoR9WrC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC6E1F000E9;
	Thu,  2 Jul 2026 16:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009339;
	bh=YdPK4vAYH21LG/HiQaluBf+BwdqnCgbaNt7+MfmZYsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=caoR9WrCiaDLcapxqpCJU9gVDocPZJSVirh895KtK3T/PW/y9zGPI9VeBG1W/8t49
	 RHFdZOlQHtqtARxProKzGrL59ThKSEvJZEiDnCV1iV+o+HgvG+W++phokc/DdkWy6s
	 Nzmh3RAxN7ByH0s4NyPwwrIt1JvdogT8ND6M1qvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GangMin Kim <km.kim1503@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Bin Lan <lanbincn@139.com>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 15/96] net/sched: cls_u32: use skb_header_pointer_careful()
Date: Thu,  2 Jul 2026 18:19:07 +0200
Message-ID: <20260702155109.307114108@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cabd1a976375780dabab888784e356f574bbaed8 ]

skb_header_pointer() does not fully validate negative @offset values.

Use skb_header_pointer_careful() instead.

GangMin Kim provided a report and a repro fooling u32_classify():

BUG: KASAN: slab-out-of-bounds in u32_classify+0x1180/0x11b0
net/sched/cls_u32.c:221

Fixes: fbc2e7d9cf49 ("cls_u32: use skb_header_pointer() to dereference data safely")
Reported-by: GangMin Kim <km.kim1503@gmail.com>
Closes: https://lore.kernel.org/netdev/CANn89iJkyUZ=mAzLzC4GdcAgLuPnUoivdLaOs6B9rq5_erj76w@mail.gmail.com/T/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260128141539.3404400-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Bin Lan <lanbincn@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Shivani: Modified to apply on 5.10.y ]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_u32.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index f2a0c10682fc81..e501390ccd7585 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -149,10 +149,8 @@ static int u32_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 			int toff = off + key->off + (off2 & key->offmask);
 			__be32 *data, hdata;
 
-			if (skb_headroom(skb) + toff > INT_MAX)
-				goto out;
-
-			data = skb_header_pointer(skb, toff, 4, &hdata);
+			data = skb_header_pointer_careful(skb, toff, 4,
+							  &hdata);
 			if (!data)
 				goto out;
 			if ((*data ^ key->val) & key->mask) {
@@ -202,8 +200,9 @@ static int u32_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 		if (ht->divisor) {
 			__be32 *data, hdata;
 
-			data = skb_header_pointer(skb, off + n->sel.hoff, 4,
-						  &hdata);
+			data = skb_header_pointer_careful(skb,
+							  off + n->sel.hoff,
+							  4, &hdata);
 			if (!data)
 				goto out;
 			sel = ht->divisor & u32_hash_fold(*data, &n->sel,
@@ -217,7 +216,7 @@ static int u32_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 			if (n->sel.flags & TC_U32_VAROFFSET) {
 				__be16 *data, hdata;
 
-				data = skb_header_pointer(skb,
+				data = skb_header_pointer_careful(skb,
 							  off + n->sel.offoff,
 							  2, &hdata);
 				if (!data)
-- 
2.53.0



