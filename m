Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048986;
	b=03TNM7k7WmVuHZNONdrTxgsR77fTbuJUvKDN9+n4lelrBLYxJpIlovHyQOt2id+sJB9+
	 2d0tKdNmoEG5BE3A5wsU9uFl+8aK+QM6ifNdr7JcNa7D2jbmxc1vYa5g9+HR0utJQ9hRf
	 lAgHw7jLp5+USz8CIr1cYC+P2W1hgSimY+iqRH/tDw+T1BlrfEvzmjXbhWZ8GqWnicYlA
	 0UdSABPsVzjhle6HE66JPcd7qfepNo7ahq1Nr1GgXA8XRMpxpIKktU03fUWCAx2RFXrLR
	 LjvHYttvfs5Off6hy2R3jXIKb2C5kJq/N6ofVY5vMJMIqPY68JrHJnORQiRbjhZGr5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tMd5srqVjLlkVO/Ak4JfISiu2gzNLGP9yFiaDe2gaTk=;
	b=pV+6FjhvKcOCM7104zjk+x3Xkrwjfy8Mp2k2y5Q8lKqNJK2cy4khiHGF3UCjqIReR4yu
	 rHCbBKP20RhJivKLV5NGZQEtiAENSJaWTcuC08qOpGRA1qm41LyJVBYN/vHhSBvjPZZlZ
	 sWBl2thiSXsRlhvtTeXlftwcH7bpOScnK71+bM7P/B5fbXrfqYaTHFk39GKLdTjc7EdSY
	 sKtMyyO5+22wB1n++Nq85yczIopaFcyfUcvFzpklA+7Xe5CHcEcqvZcDzdCkVp0jmlCkE
	 3glA2MBhRWkFd/fByRBuj43dMgWnSkOD3gRGdeTTTOpWnoBXBnT+q77i7gNQSY3Kkkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YDATeZ+d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F09606A325;
	Thu, 19 Nov 2026 00:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YDATeZ+d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22321F000C4;
	Thu, 19 Nov 2026 00:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048986;
	bh=tMd5srqVjLlkVO/Ak4JfISiu2gzNLGP9yFiaDe2gaTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YDATeZ+dmlY86aPatbQCBFp+yUTSICFoYmUmW0RWPCJy0BYdlbZGHp6uPwusrgG33
	 hpUweWrGvkw0piJXC2XAqDGR6v6wS+JWQM5E8gkyBC79V6cREsuMQZmj8qSz1vJwcD
	 NC/66obRiMgO/7RkeoAtYmElsjRZFP7nr8qFSM84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Omar Ramadan <omar@blockcast.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2163/2857] amt: pull the AMT header behind the transport header in amt_parse_type()
Date: Wed, 18 Nov 2026 15:53:17 +0100
Message-ID: <20261118150319.282013738@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



