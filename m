Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211175;
	b=wMLFxDnfNzZ+JGa2dktCdx0EhaZbzVDyzMbl91xpYw3Dd9KTfdBffYdC31ilVa836aHF
	 WyDtItVnGF9cK0LmUbw+ZvAEfxZvR3DRUaLfbJpzl8KnIiP5j18R5W7z+wvGca2ZtMzqQ
	 jgfGanlkL8ZzJ4/XS2Fv0CIMQ4NG0DKmU9n4BpMX02xjPdSGX3moToVXT5irCrgUeGMUX
	 s0iT9aA3XSB0+VY9fnDmebVLY3k63+sC1q/0GWiTRlfYhuY2GbR6Ifhg66dAt2/v9LTBE
	 3jjYmImCYl3+g6volOBVDo87k/jTYoghlGiphq/nmJ4QpUygG8xI0GOVwG6hb+OMWRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=axCzMV41o3lFzAKIVHUEvool/5otWvsWOdXzL4+cvko=;
	b=oDI2tEL5LGpIuCrjkXfIADwmPCa08qcnB6efF2L2zrghNmqb6JrqH1u5SQFJRRylAyib
	 KXikmedfFXj0H0qhjP/YHCUEpiSRjoehb8lYmY2VrldW7C4bH6kQJ7XwIiEa420Oi8up4
	 ebZ17XgwxYlkZby+4XeI5nM6f31RPY9ycePD+n/dwNtWXPkm+xhlRmM0D9z0bd36GrT/7
	 3RpsS58Bbn28fdVaFdu/vPp5QN+aNZYVoumo6vsNiMBardId9mtwkvqMPZCCaM+JNMT5t
	 A8DcNWikD0GLhiLTOY4oE+hiNDScDRtviG4zKHaYTD3wk7dqi9UsLiGEtr5kNcLd4UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0i6oI2F8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E22606BF71;
	Wed, 28 Oct 2026 18:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0i6oI2F8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EBE1F031E3;
	Wed, 28 Oct 2026 18:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211174;
	bh=axCzMV41o3lFzAKIVHUEvool/5otWvsWOdXzL4+cvko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0i6oI2F8L1kDNV9y8hfvIqBJpIEg+TEcs4PAQo/LIT2E8rebPmm9bRfvz5WjKLs5x
	 wdLJfu2JRe1+owRM1iFN7+6F8XJDjjIsGbJ5sRwPOFjHR5V6HCufCYQLmYqtaGi3s5
	 Eu/K1zVLfls2lpxy/iCt+c/17giqUoPoihk1qa8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 286/571] xen/netfront: drop RX packets with a short Ethernet header
Date: Wed, 28 Oct 2026 17:57:13 +0100
Message-ID: <20261028170014.788512053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 089e58805c452e52179482b1025a8e309a57f801 upstream.

handle_incoming_queue() pulls pull_to bytes into the head before
calling eth_type_trans().  pull_to is the length of the first RX slot,
capped at RX_COPY_THRESHOLD, and that length comes from the backend.
Nothing checks it against ETH_HLEN.

If the first slot is shorter than ETH_HLEN and more slots follow, the
head ends up shorter than an Ethernet header while skb->len is longer,
and eth_type_trans() BUG()s in __skb_pull().  If the whole packet is
shorter than ETH_HLEN, eth_type_trans() reads the header past the end
of the data instead.

Pull at least ETH_HLEN, and drop the packet if that fails, which also
drops packets too short to hold an Ethernet header.  This also checks
the return value of the pull, which was ignored.

Fixes: 0d160211965b ("xen: add virtual network device driver")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261007-b4-xen-netfront-short-head-v1-1-12d7113a7e4e@toxicpanda.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netfront.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1228,8 +1228,16 @@ static int handle_incoming_queue(struct
 	while ((skb = __skb_dequeue(rxq)) != NULL) {
 		int pull_to = NETFRONT_SKB_CB(skb)->pull_to;
 
-		if (pull_to > skb_headlen(skb))
-			__pskb_pull_tail(skb, pull_to - skb_headlen(skb));
+		/* pull_to comes from the first slot's length, which the
+		 * backend controls.  Make sure the head holds at least an
+		 * Ethernet header for eth_type_trans().
+		 */
+		if (!pskb_may_pull(skb, max(pull_to, ETH_HLEN))) {
+			kfree_skb(skb);
+			packets_dropped++;
+			queue->info->netdev->stats.rx_errors++;
+			continue;
+		}
 
 		/* Ethernet work: Delayed to here as it peeks the header. */
 		skb->protocol = eth_type_trans(skb, queue->info->netdev);


