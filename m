Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057972;
	b=TvVcc3R/ovHH06r8b8pBHJyTHaoOEqcFZ7g+FJtXSqKnkT3QY6ilfEz2kesaCAAo1oTc
	 2/mUTcQied1hWO7RCwDm2d7c9XzduftXiI2+XRz8QanwUakbXeoTF984rSyo2+xp/+Meu
	 VR7zWZnN+uBRJzbZBH12koV3hbPbjiulu0W8B2gyoII3MnbHY7H0cLF6WNTW07q/kZktz
	 rNO5SGWKAlVkRmM5SpnNq9g9qMvhxYGoIMvZIrgKCKbytBkjqqWUsU8taqmDj38qxnmq+
	 sRDxIIEClBI1Mi285nMAaw/D3dTZuyAUM+q1tVwhrCVSPoCGx7Qs+NM92UFOmncSFHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+5jP4w1gv0DKknUKPbrXFCDzYq7eGQTf1E1Klwr3cds=;
	b=iRlchnZwuzHhmbaHmklUkav4jYZ9RYwq4nBdqZduCQLUyqATGKNj67A/HYQypGixxUbt
	 7TQW82IH2EgM8OLC7a33907opXVA3P+xVhJYKqA80LZ3rPhRPgZZZJerNWv5n7VbECJI/
	 4jTs4dKBXPoVMCl2Wz1Gcux26gW5PCuooJeMvePA8joFP2I1UO/21VvdixvWPpHrWvqtb
	 dni4/Gh1ayYsLOHiVYT4Gr3QXQoYA38UBNtHuzBcipYjGYcpifWZ8ObTvP9/2HNda3aOM
	 8EZmQzUBJNEYRwpbAyv4Bl6ICNXW9sop4hb5GMeXcKmZ4BqZ0O99+sRYffUJcBw43gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1wFLQgW4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE533606A325;
	Thu, 19 Nov 2026 03:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1wFLQgW4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA831F000C4;
	Thu, 19 Nov 2026 03:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057972;
	bh=+5jP4w1gv0DKknUKPbrXFCDzYq7eGQTf1E1Klwr3cds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1wFLQgW4Eag9XkNJk5V/zfcGzXAm/dtmS1+oPcP3xyOSSLEYwizXEnNC/gO0mtbpr
	 COHGtrxB1OZgpOA+28qSRSe8iUGqbJCFxj1TyZfS2x4McX1BSegW0HPtb5vKhU8kCv
	 uj4IScWt/n721hyMgqHKPREfJwyjyMe0ZXmE95Gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 0321/1848] netfilter: conntrack: always lower timeout for non-closing RST packets
Date: Wed, 18 Nov 2026 15:39:19 +0100
Message-ID: <20261118145925.609668862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 73df81b38cb7f70a347a97370386378a86e53019 upstream.

The existing check might extend the timeout if the ESTABLISHED timeout
has been tuned to be lower than UNACK via sysctl. Reported by sashiko.

Fixes: bf80e6802273 ("netfilter: conntrack: tcp: use UNACK timeout for non-closing RST packets")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1135,7 +1135,8 @@ int nf_conntrack_tcp_packet(struct nf_co
 	    timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
 		timeout = timeouts[TCP_CONNTRACK_RETRANS];
 	else if (unlikely(index == TCP_RST_SET &&
-			  new_state == TCP_CONNTRACK_ESTABLISHED))
+			  new_state == TCP_CONNTRACK_ESTABLISHED) &&
+		 timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
 		timeout = timeouts[TCP_CONNTRACK_UNACK];
 	else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
 		 IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&


