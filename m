Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AF4443AAD;
	Tue, 21 Jul 2026 22:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673112; cv=none; b=D/BMIF1YyLp5H4txkk7MbOxEJAZdX4cc4u1gfYlqx9JhpTNT7QtqjAOT2uG/HUIbJsEfxdCS9P3jApt9vZghEnmMXLPRaIfzp0uXjU9cs2RViUuHZ4awVhuYMALcNH1f4YTtbihpJ1Qifw+t5b8N6LddI3+qtQNKAPfTNBHXqV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673112; c=relaxed/simple;
	bh=Ifp9VtVNSxcYOksMYq2TjTUFPYuWL5PAHoIwfqCagkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTrUhTb4ONk9g65RmFXHTbw8HmDLuos1wP7UfS/jUHTUzzcj8BYL09bljbZQsQduyjIBoVROuO5FZMmBpFJAch+kz0fdItDdnlclTHMgFuBAG4zWgGHaVD7P4kqB3dwn/L+AbNPNgppeg+AozJuptvFYjFpIWpga0puGJHI4Xqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oAWOWEGw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oAWOWEGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5E41F000E9;
	Tue, 21 Jul 2026 22:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673111;
	bh=/fjysGECZdRkySs0vU60Zo4wl5a8NKKI72cn0dYY3tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oAWOWEGwXvSxe1csw7mUDj5x4HNilS7k0Iu/1FOg301F1hB0BeDqRCEAgqw7ovvR9
	 7ldkoOtOuA1CnrqP/EzbCiy8LRsKrwfmoz5uopjvSxbT6ch+1sW+bLAk/WqyI4sSRh
	 RPVMTrHW5jF9CaBhDZcL7RXD0nsEDwPIgJ0Cgz9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/699] skmsg: convert struct sk_msg_sg::copy to a bitmap
Date: Tue, 21 Jul 2026 17:16:12 +0200
Message-ID: <20260721152355.983308736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

[ Upstream commit 5a8fb33e530512ee67a11b30f3451a4f030f4b01 ]

We have plans for increasing MAX_SKB_FRAGS, but sk_msg_sg::copy
is currently an unsigned long, limiting MAX_SKB_FRAGS to 30 on 32bit arches.

Convert it to a bitmap, as Jakub suggested.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 406e8a651a7b ("net: skmsg: preserve sg.copy across SG transforms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skmsg.h |   11 +++++------
 net/core/filter.c     |    4 ++--
 2 files changed, 7 insertions(+), 8 deletions(-)

--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -29,7 +29,7 @@ struct sk_msg_sg {
 	u32				end;
 	u32				size;
 	u32				copybreak;
-	unsigned long			copy;
+	DECLARE_BITMAP(copy, MAX_MSG_FRAGS + 2);
 	/* The extra two elements:
 	 * 1) used for chaining the front and sections when the list becomes
 	 *    partitioned (e.g. end < start). The crypto APIs require the
@@ -38,7 +38,6 @@ struct sk_msg_sg {
 	 */
 	struct scatterlist		data[MAX_MSG_FRAGS + 2];
 };
-static_assert(BITS_PER_LONG >= NR_MSG_FRAG_IDS);
 
 /* UAPI in filter.c depends on struct sk_msg_sg being first element. */
 struct sk_msg {
@@ -235,7 +234,7 @@ static inline void sk_msg_compute_data_p
 {
 	struct scatterlist *sge = sk_msg_elem(msg, msg->sg.start);
 
-	if (test_bit(msg->sg.start, &msg->sg.copy)) {
+	if (test_bit(msg->sg.start, msg->sg.copy)) {
 		msg->data = NULL;
 		msg->data_end = NULL;
 	} else {
@@ -254,7 +253,7 @@ static inline void sk_msg_page_add(struc
 	sg_set_page(sge, page, len, offset);
 	sg_unmark_end(sge);
 
-	__set_bit(msg->sg.end, &msg->sg.copy);
+	__set_bit(msg->sg.end, msg->sg.copy);
 	msg->sg.size += len;
 	sk_msg_iter_next(msg, end);
 }
@@ -263,9 +262,9 @@ static inline void sk_msg_sg_copy(struct
 {
 	do {
 		if (copy_state)
-			__set_bit(i, &msg->sg.copy);
+			__set_bit(i, msg->sg.copy);
 		else
-			__clear_bit(i, &msg->sg.copy);
+			__clear_bit(i, msg->sg.copy);
 		sk_msg_iter_var_next(i);
 		if (i == msg->sg.end)
 			break;
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2677,7 +2677,7 @@ BPF_CALL_4(bpf_msg_pull_data, struct sk_
 	 * account for the headroom.
 	 */
 	bytes_sg_total = start - offset + bytes;
-	if (!test_bit(i, &msg->sg.copy) && bytes_sg_total <= len)
+	if (!test_bit(i, msg->sg.copy) && bytes_sg_total <= len)
 		goto out;
 
 	/* At this point we need to linearize multiple scatterlist
@@ -2900,7 +2900,7 @@ place_new:
 	/* Place newly allocated data buffer */
 	sk_mem_charge(msg->sk, len);
 	msg->sg.size += len;
-	__clear_bit(new, &msg->sg.copy);
+	__clear_bit(new, msg->sg.copy);
 	sg_set_page(&msg->sg.data[new], page, len + copy, 0);
 	if (rsge.length) {
 		get_page(sg_page(&rsge));


