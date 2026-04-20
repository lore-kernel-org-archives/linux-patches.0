Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B740D3396EE;
	Mon, 20 Apr 2026 15:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699834; cv=none; b=Nw5YfwmBOJFMEAckp2mQJ0zjzf/8P5fUfnkopPrKkWkEdnn7k1+OMSFacigFdJ+NLBg4HYPemeinF2y+3LQdOzpXH/PJRPanFTZJ1qC9j5dkx14ZnG4mWT4BPUxHcK1wZrsWo/BDNM96C4M86h4R28dZZKyLWUhHQFejNPR77+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699834; c=relaxed/simple;
	bh=sLx/GLPh7es2/ZUFf15x+fa7FjMSM1g5e6jTUVOsYPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQlNvoknDM4YJGHRxCmxGjODE9YsScyRRHFG4eg+oJgVBq6XWqKPyfkDkeycM06oepwZyFkpoVS8yKOkn6TmEFhpIYZRgjs3ks/P55sYvSmtoMXqm/tDAIN7Y8HgDuHCLqDYm7jD5WHPo+iU3tXxyZ96BQiZH2KY2U9D1lcY3Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tlKR1yEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tlKR1yEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083BAC2BCB8;
	Mon, 20 Apr 2026 15:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699834;
	bh=sLx/GLPh7es2/ZUFf15x+fa7FjMSM1g5e6jTUVOsYPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tlKR1yEzQIMe54c6jjVv4j6aj01QhQ20WPgUjT/ftFcNYijY8/EiNpKIc6Qf9KQ8b
	 Lvz5Vm7J8spvuc+S9Z1GWFUX8NzJEEJDK38T6RJzw+82teo0r7bLu9WebtMi5qVLMB
	 IxoBF8hUpU7fq+UOvkG/aU8KPQHLa6ZYeeEWtKp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>
Subject: [PATCH 7.0 16/76] usb: gadget: f_phonet: fix skb frags[] overflow in pn_rx_complete()
Date: Mon, 20 Apr 2026 17:41:27 +0200
Message-ID: <20260420153911.413335698@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit c088d5dd2fffb4de1fb8e7f57751c8b82942180a upstream.

A broken/bored/mean USB host can overflow the skb_shared_info->frags[]
array on a Linux gadget exposing a Phonet function by sending an
unbounded sequence of full-page OUT transfers.

pn_rx_complete() finalizes the skb only when req->actual < req->length,
where req->length is set to PAGE_SIZE by the gadget.  If the host always
sends exactly PAGE_SIZE bytes per transfer, fp->rx.skb will never be
reset and each completion will add another fragment via
skb_add_rx_frag().  Once nr_frags exceeds MAX_SKB_FRAGS (default 17),
subsequent frag stores overwrite memory adjacent to the shinfo on the
heap.

Drop the skb and account a length error when the frag limit is reached,
matching the fix applied in t7xx by commit f0813bcd2d9d ("net: wwan:
t7xx: fix potential skb->frags overflow in RX path").

Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Link: https://patch.msgid.link/2026040705-fruit-unloved-0701@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_phonet.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/gadget/function/f_phonet.c
+++ b/drivers/usb/gadget/function/f_phonet.c
@@ -333,6 +333,15 @@ static void pn_rx_complete(struct usb_ep
 		if (unlikely(!skb))
 			break;
 
+		if (unlikely(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS)) {
+			/* Frame count from host exceeds frags[] capacity */
+			dev_kfree_skb_any(skb);
+			if (fp->rx.skb == skb)
+				fp->rx.skb = NULL;
+			dev->stats.rx_length_errors++;
+			break;
+		}
+
 		if (skb->len == 0) { /* First fragment */
 			skb->protocol = htons(ETH_P_PHONET);
 			skb_reset_mac_header(skb);


