Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65D821B191;
	Sat, 30 May 2026 17:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163003; cv=none; b=Ijv+vkgcWacYR1GFcWq+SkOeneB3KLtI1OjTPRdtaF+cgDS8OmmBn0q/RXk5FL0iqc9kvH2J4+Ms/N7Y7GqZ9yJgzcL/xANCzkAgcLLwR8Dsfa0BhMTONwDs7bI6uTX5A7WUTjfAKr+yek/yVKETAwiVwm3MSRwbxyj9c/e7KcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163003; c=relaxed/simple;
	bh=VsHf6A9E1wgAM5ZeBOxpB3AVSNwNtJTJTzDOTuKD1hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZuTOKS4Mfu1rJZsOeBvSxgJ1YSTPKZza3qAt1Paf3ltLOY+vsRSWAE+Q7QCNdKy5cXXH3VgJ1kFrUeSt0Et91dV8E1p9CUSl8nyP4btSSnAR+brQJYUWau5cqKCTrNkSnrWebd3Ygoiwlo3QW7udUd7WMnYMjknkQjlrvRKtaDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6B3Je+q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6B3Je+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266B61F00893;
	Sat, 30 May 2026 17:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163002;
	bh=7YicRz8aeBIAoguIUNLGSycnSbmlp/jYZgmGvTYy4/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6B3Je+qf3OvWzPBGSQu4wK17Le93kn9Ps7CC/msKnmWj+7+NMoiOI2C+7fWm+H9L
	 /yk8zHvuSEgMCowamN3fMWraJvJTN5b6biwwmNcIOJS6ewBwa3G9abUPlCy33gxISA
	 Hihx+Chw6QO4RaUL3HNKLx8HNfl0Djav1eUyTsVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GangMin Kim <km.kim1503@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Bin Lan <lanbincn@139.com>
Subject: [PATCH 5.15 127/776] net/sched: cls_u32: use skb_header_pointer_careful()
Date: Sat, 30 May 2026 17:57:21 +0200
Message-ID: <20260530160243.663889860@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
---
 net/sched/cls_u32.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -149,10 +149,8 @@ next_knode:
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
@@ -202,8 +200,9 @@ check_terminal:
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
@@ -217,7 +216,7 @@ check_terminal:
 			if (n->sel.flags & TC_U32_VAROFFSET) {
 				__be16 *data, hdata;
 
-				data = skb_header_pointer(skb,
+				data = skb_header_pointer_careful(skb,
 							  off + n->sel.offoff,
 							  2, &hdata);
 				if (!data)


