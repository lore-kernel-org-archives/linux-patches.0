Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADF313665B;
	Mon,  6 Jan 2025 15:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176814; cv=none; b=WV9EjogPz+cBCB08FomY8d99C0FYq6YXrS3an5GWGKoNA0zasDjHmYs3zfIKrZYBY7Qa7YsxuVLRXlAx5roVJloMDrFFKjKasdD9KbmjxCRXPPqeWlmtA89O9TsFihfUjoudkFmNvLlS7CdV92wLIL7EPntGeMOV0ejByv6e6l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176814; c=relaxed/simple;
	bh=45n0RTQqMoOTNiLf6vRs2/NPhqXbejslDla70ueIEkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDOte68CI2Nsj4d5nByFASk2vvDTvFzvgkL0sfNqqpYHlr6rXQxmEE/8H57FLAVLyfCzbps4ktOFrHTD3gIpmVCegyuBWlcH3WSrcPcq0TjfN6qTmsz87qLHgyv4gnQcxY5YrHe5tDpaDB2LO1GSuunLsJxdSotH+YkOcynQOqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YC9CWQgN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YC9CWQgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0D5C4CED2;
	Mon,  6 Jan 2025 15:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176814;
	bh=45n0RTQqMoOTNiLf6vRs2/NPhqXbejslDla70ueIEkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YC9CWQgNCBD6e5WUl6f2TEONN032r+fK1vIaTGknYBUmdIVmM7PvUviE2hnmd/YUN
	 rDC7QwQSzgHtDGa3ewZy/bLjhMoq4rHhWitgBgXgKM/Bni89iHl52Y41dAkH6LbC1w
	 4V2pKS6ROL50z4yBKA0jtXUzkCtjVBitfBeT70lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Pastor <antonio.pastor@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 39/81] net: llc: reset skb->transport_header
Date: Mon,  6 Jan 2025 16:16:11 +0100
Message-ID: <20250106151130.914309529@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Pastor <antonio.pastor@gmail.com>

[ Upstream commit a024e377efed31ecfb39210bed562932321345b3 ]

802.2+LLC+SNAP frames received by napi_complete_done with GRO and DSA
have skb->transport_header set two bytes short, or pointing 2 bytes
before network_header & skb->data. As snap_rcv expects transport_header
to point to SNAP header (OID:PID) after LLC processing advances offset
over LLC header (llc_rcv & llc_fixup_skb), code doesn't find a match
and packet is dropped.

Between napi_complete_done and snap_rcv, transport_header is not used
until __netif_receive_skb_core, where originally it was being reset.
Commit fda55eca5a33 ("net: introduce skb_transport_header_was_set()")
only does so if not set, on the assumption the value was set correctly
by GRO (and also on assumption that "network stacks usually reset the
transport header anyway"). Afterwards it is moved forward by
llc_fixup_skb.

Locally generated traffic shows up at __netif_receive_skb_core with no
transport_header set and is processed without issue. On a setup with
GRO but no DSA, transport_header and network_header are both set to
point to skb->data which is also correct.

As issue is LLC specific, to avoid impacting non-LLC traffic, and to
follow up on original assumption made on previous code change,
llc_fixup_skb to reset the offset after skb pull. llc_fixup_skb
assumes the LLC header is at skb->data, and by definition SNAP header
immediately follows.

Fixes: fda55eca5a33 ("net: introduce skb_transport_header_was_set()")
Signed-off-by: Antonio Pastor <antonio.pastor@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241225010723.2830290-1-antonio.pastor@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/llc/llc_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/llc/llc_input.c b/net/llc/llc_input.c
index 51bccfb00a9c..61b0159b2fbe 100644
--- a/net/llc/llc_input.c
+++ b/net/llc/llc_input.c
@@ -124,8 +124,8 @@ static inline int llc_fixup_skb(struct sk_buff *skb)
 	if (unlikely(!pskb_may_pull(skb, llc_len)))
 		return 0;
 
-	skb->transport_header += llc_len;
 	skb_pull(skb, llc_len);
+	skb_reset_transport_header(skb);
 	if (skb->protocol == htons(ETH_P_802_2)) {
 		__be16 pdulen;
 		s32 data_size;
-- 
2.39.5



