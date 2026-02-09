Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E031037E300;
	Mon,  9 Feb 2026 14:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647958; cv=none; b=JPPNebWGCV4z3Ce6yPe5uCtN5NF21wzs9QowsrWng7rl0nZUcDxLD96jUkLpqeUFxsENzyvFHZ4T7I9qUyatBAHPY3nRbQq2yc5sZtUflEulk7AZdd8QPRAUT5/oz7f51nuAkN3NuS1ToC6BJtgVcPojlMkFuZPrGDg0Za+0r10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647958; c=relaxed/simple;
	bh=uUt+KcK6xbdxLv2lZCFsxTz6SxgFUKYAqfVInUAO2J0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1t3NvSVcFryA+2BigNN7ODhWVhkxvBtmz5afD24eBOCRyOtkqxrVSbHITrH1tc+XVuaDOF+mZBApL0d+8czT9NswzUvoQvMfGSErk8oTbGWGsGkVKrZeOuCRYJdqF0eDq60Hfxwibqrm9kIDMD1ApRlapdNhRkEOBBVaEsrLok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDB9jsp9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDB9jsp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458BEC19423;
	Mon,  9 Feb 2026 14:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647957;
	bh=uUt+KcK6xbdxLv2lZCFsxTz6SxgFUKYAqfVInUAO2J0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDB9jsp9igHb1QShjrjVUfUweljL+sPtOBevLcKG1bMi4vd0aAnx6eIllRbbv9QzV
	 yOlPpDbt3rjVhpgDXI6qBpshTUc8LEk6CTgljir5mqM47Dgo8olSBHiRMfGMan4CqE
	 CDT+sUzoxSPnhUsKvUzBSRnZqxlSSBg3aW4X4hP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GangMin Kim <km.kim1503@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/113] net/sched: cls_u32: use skb_header_pointer_careful()
Date: Mon,  9 Feb 2026 15:23:48 +0100
Message-ID: <20260209142313.023557748@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_u32.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 2a1c00048fd6f..58e849c0acf41 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -161,10 +161,8 @@ TC_INDIRECT_SCOPE int u32_classify(struct sk_buff *skb,
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
@@ -214,8 +212,9 @@ TC_INDIRECT_SCOPE int u32_classify(struct sk_buff *skb,
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
@@ -229,7 +228,7 @@ TC_INDIRECT_SCOPE int u32_classify(struct sk_buff *skb,
 			if (n->sel.flags & TC_U32_VAROFFSET) {
 				__be16 *data, hdata;
 
-				data = skb_header_pointer(skb,
+				data = skb_header_pointer_careful(skb,
 							  off + n->sel.offoff,
 							  2, &hdata);
 				if (!data)
-- 
2.51.0



