Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040683;
	b=WbkDXquuCnre5hZoZ6Mlu3x42hRcWRgQL/wvJKzPwcVfMrCl2Ljh0/iC1MtWxhMqU3ew
	 i0LMJyXK2cjGJCcw4Qiz/rkmjUht6l8ac57oUyPBVLzA5RF8OeSDesiBWcJbXc6XzkI9c
	 n+wLNIpFyBXEQUCyb3Bq7qDHWTgI33SXg+F5GLqnSkv5/3nEPwNbMCgh5wuARDvnWycIo
	 BxXxLja5wcLqaqJ/5U9ML8OrhWRGmvqowR8fBrsa1l45K2MF4JKaRw8B3n/637zbvb9Ja
	 EqXFQKW8JnsdCDZ1lMch28KDhFxolvgz987if+C/RLnwF5UwPFgGA02/MpnVI4BJe8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cb0Zci2KJyueMmjgGGRLTz7mMmT4wyrv7zPC6ilNM3U=;
	b=f+lUfD5JyFjRP+zX9YjP8BC0dkZG/XOjnIvezNdjhN2We1umzg97YCTVf/koOXgk+JOq
	 DSBXg48sahWcKfyQmUZoowuhGI66zxZmde2x3WAucncGkdUt4jVuvHkE9jtz3w+N99BFP
	 Liy2ehhzcw3s3jA0JdZ83dxd8KBsnORjxyhqcrWRv7QcGKqQl9urDlyeSY8c3fHvHO9Zm
	 L/W7rJlrF6DPT9hDJuoauxBhGPGmdeKWRXpvlh2LBPhfM1eIKf2vk3TNw8tTbd3UYLNd9
	 JO6miSsfRRwDZdRuwBY7qjn9mZWuz371NoyonHXdufIBAitfhVw41Vgj94TdyaR4/eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uBANMLoK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58477606A32A;
	Wed, 18 Nov 2026 22:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uBANMLoK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AD71F000C4;
	Wed, 18 Nov 2026 22:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040683;
	bh=Cb0Zci2KJyueMmjgGGRLTz7mMmT4wyrv7zPC6ilNM3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uBANMLoK84JuX8NFar04jFgiNGYLaotKJGv6VCdHBwIlbJJmsoBPLZManBnr+QDHX
	 HqfQ74ldJ1JSmqKUFWb1ZG0u/mS1ZXIufhkNuXIb/GA/Bv+MI3yUL9P9OHXvd074Br
	 K7p8GBRUw8CBLwG/eiwOIPDIEyDga5h6FZhgMMlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Omar Ramadan <omar@blockcast.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2495/3318] amt: pull the AMT header behind the transport header in amt_parse_type()
Date: Wed, 18 Nov 2026 15:51:57 +0100
Message-ID: <20261118150436.238895585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Omar Ramadan <omar@blockcast.net>

[ Upstream commit eb0c18404c8943356f4aa164e5db9067b79ea93c ]

A gateway's encap socket passes ICMP errors to amt_err_lookup(), which
calls amt_parse_type() on the quoted datagram to see which AMT message
failed. On that path skb->data points at the quoted IP header and the
transport header at the quoted UDP header, and icmp_socket_deliver()
only guarantees the quoted IP header plus 8 bytes, that is, up to the
end of the UDP header.

amt_parse_type() pulls sizeof(struct udphdr) + sizeof(struct amt_header)
bytes from skb->data, which on this path stays inside the quoted IP
header, and then reads the AMT header behind udp_hdr(skb). An ICMP error
that quotes only the IP and UDP headers of a Request, the minimum RFC 792
asks for, therefore makes it read past the pulled data, and past the end
of the packet when nothing follows.

Pull up to the transport header plus the UDP and AMT headers, as
vxlan_err_lookup() does. amt_rcv() is called with the transport header
at skb->data, so the pull on the receive path does not change.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Omar Ramadan <omar@blockcast.net>
Reviewed-by: Eric Dumazet <edumazet@@google.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20260928181557.85796-1-omar@blockcast.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 9bdc6c0e7bf9c..ad855130b4300 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -1284,8 +1284,12 @@ static int amt_parse_type(struct sk_buff *skb)
 {
 	struct amt_header *amth;
 
-	if (!pskb_may_pull(skb, sizeof(struct udphdr) +
-			   sizeof(struct amt_header)))
+	/* skb->data is the UDP header on receive, but the quoted IP header
+	 * when amt_err_lookup() parses an ICMP error, so pull up to the
+	 * transport header rather than from skb->data.
+	 */
+	if (!pskb_may_pull(skb, skb_transport_offset(skb) +
+			   sizeof(struct udphdr) + sizeof(struct amt_header)))
 		return -1;
 
 	amth = (struct amt_header *)(udp_hdr(skb) + 1);
-- 
2.53.0



