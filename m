Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705422;
	b=Q9s65nciYHf47awXkeA0bBe0Q47afBiSDZxmzego7YJgvuw/yilPu56TTQk0CGX6BHFJ
	 P8MVmmtTgELyR1AmZ9bzS36M0YEgxMfZbfCOQL9AIepL0WEVAYQQDiKPl1IQfZMiIRO9K
	 Xwz4ox4OHq14Mnrs1MacOAPwysjAcVJiOr6Q50F5uTF5cUyGy/7whhV0WfmfwUdvFLrxo
	 CWMxgoqJuiTQuusP3zb1rBo9h6R9V50F54QJDyKCsEsmC/ThhV2aXDQpwPlhUgFCM25/a
	 k4Bd/WRa5TyJrUA/rQepcDVDds0C8Bvrrtv3wufho8vRLB7m3k6bPkjTn1vUh/yQgJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZHgCIowwFfj+/2dzLJDNgY/hfmPn+LCfQ/iyvssK/r4=;
	b=DZMtnUZxba/+Iw8rwRb+BuSxTV5hNEtQDE2tfp8bvCpS/Erc7c57kJrfMP8f4M3d1wwN
	 1ZiQJZ6BW8NG42y/X+qYbj/v8SQkNGi9EpnSTY+en71R79thmNdmAV+C/TOXlBFYgy5ak
	 onYFCSOB7pC2OxYi4u9gHiH9Xr36GhsC9DiWVq5mcUXsYKKArmE6Pdic/w0qQ0libdtTP
	 b5Z0MH+uA1lJjap7hVJf17fSgevG9pedg/OEre6dOhEFflqIwYMT7EmE4ZTdYTpwJfTce
	 InCpq+Bt++hTpiS9DnWfN/fmlzTa69GTxWX06Ww2x842HUiF0qJ/8DWOeNO7O444y0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QaHg2uKt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B74606A31C;
	Thu, 26 Nov 2026 15:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QaHg2uKt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51941F000CA;
	Thu, 26 Nov 2026 15:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705421;
	bh=ZHgCIowwFfj+/2dzLJDNgY/hfmPn+LCfQ/iyvssK/r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QaHg2uKt2I5qoPaDNtKlsg4q82QGvymCYbBW7EoDDufRvD0YGaYiHuBvW8QV85j4F
	 gkU4dCLGoAMLeCofwVpeSVh/sDhJ4LZVfmBjBG6cbnkmwWQsIBTYAGRzeRkxq+uPB0
	 jo21NWV5Xk16+fP94p14hQ7V70ucp6mqkVGCvo/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 193/319] ipv4: keep XFRM headers out of corked skb lengths
Date: Thu, 26 Nov 2026 15:39:21 +0100
Message-ID: <20261126144011.101831193@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

commit 0f47fce51a98d3d9f439c16861d519a7b833a176 upstream.

__ip_append_data() allocates space for dst.header_len in the first skb,
but includes that space in skb->len until __ip_make_skb() pulls it.
Fragment accounting uses an MTU that already excludes the XFRM headers.
As a result, the next skb can have a fraggap larger than its capped
datalen, and skb_copy_and_csum_bits() can overwrite its shared info.

For example, five AH tunnel states can reserve 500 bytes while leaving
an effective MTU of 348. With 40 bytes of IPv4 options, the second skb
has room for 288 bytes of fragment data but receives a 500-byte gap
copy. The overwritten shared info is subsequently consumed by the skb
release paths.

Reserve the XFRM headers together with the link-layer headroom instead.
This keeps skb->len, the gap-copy offsets and the trim lengths relative
to the IPv4 packet throughout corking. The network and transport header
addresses and the headroom available to XFRM at output are unchanged.
Both paged and linear allocations, including subsequent corked appends,
use the corrected accounting.

Fixes: 353e5c9abd90 ("ipv4: Fix IPsec slowpath fragmentation problem")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Link: https://patch.msgid.link/20261030042229.74068-1-kylebot@openai.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_output.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1132,16 +1132,16 @@ alloc_new_skb:
 			 */
 			skb->ip_summed = csummode;
 			skb->csum = 0;
-			skb_reserve(skb, hh_len);
+			skb_reserve(skb, hh_len + exthdrlen);
 
 			/*
 			 *	Find where to start putting bytes.
 			 */
-			data = skb_put(skb, fraglen + exthdrlen - pagedlen);
-			skb_set_network_header(skb, exthdrlen);
+			data = skb_put(skb, fraglen - pagedlen);
+			skb_reset_network_header(skb);
 			skb->transport_header = (skb->network_header +
 						 fragheaderlen);
-			data += fragheaderlen + exthdrlen;
+			data += fragheaderlen;
 
 			if (fraggap) {
 				skb->csum = skb_copy_and_csum_bits(


