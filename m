Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051943;
	b=oGgQsViCuKgM4Fmeri0h/AfmwPCtnvXYFBsXB/+wPZtAWoT+Y97dN/UH+3n+1q3RN3hF
	 7lodVXfISZ42O3tiS4NkveuL7BnqVrqVhHwU2/veIkE9Kc7tFbbzThoc1xZigEypH1gkh
	 sxHiMzBv3m/VGsGL9sFz2dd22RLZYfN7qBGhNnQee9YxoZH3x25aztV8qP8SaujPIGu07
	 O4GUuU14GO11hxjrfu6zj4P5mJacyUjhSRklOXCpEjw6LXY6sbCZL+D3/IqE3r6uV7zpp
	 A1ecBSExFIarGV8oXBPKhu2/PA7g/hGG32WFMtPvqlCs78jVfJihoda9IvpiG8i2TJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XVrgpsgOo0vHtMR8UFPOQMzVfUSz9UhGhtgBEGJHX9c=;
	b=rBYIEX2uKLanU0Ap3bfBpUF+q6DsHwcKpGi8hvtkM1OetKsH6Aaoy5oVAg2mWJrxIIia
	 DD90sFZFZ04pc3+qmu11nV7GgyrRQiFpW0bGi29QcCyi4ZLOFMVoNhLgV5u0iXRr86KiY
	 39Oqiv0rV1EKuoHZqaWZUjFCH+XnhzXIWPdtEwEQQ8yzTPeN345YVk0yrJShIvVED6hNy
	 sFHB6Gc5oW8H+o5UPUP5W1R9MY2A0+iYxoN5LR51Xf7PEaSpyyq4Ruzf6r4PYu22VcFTZ
	 teFF2FVUpjNVncdPmbMWTveB2/mczNYmykU1J9qNA58k6Darqu/b69m1IEYx8A9Eetw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1qiv1fqE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2FA606A332;
	Thu, 19 Nov 2026 01:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1qiv1fqE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D291F000C4;
	Thu, 19 Nov 2026 01:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051943;
	bh=XVrgpsgOo0vHtMR8UFPOQMzVfUSz9UhGhtgBEGJHX9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1qiv1fqEVqKO61G1ZE34Y/+oHzkhhGq6IfQNaUeQeJdBSK6FnoLNqEmhFbOeJTDBG
	 O8zULUx5O8/b6g5UE+oK8HCngzONa2EdFG8s/3togyt+ippsKNtzjM3VrvUEEafZHW
	 uMV0vSaO1Z/74d8K2MNcZyZXBEc3Fj4T2rMF6OiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 0388/2214] netfilter: conntrack: always lower timeout for non-closing RST packets
Date: Wed, 18 Nov 2026 15:34:24 +0100
Message-ID: <20261118150026.196885537@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
@@ -1222,7 +1222,8 @@ int nf_conntrack_tcp_packet(struct nf_co
 	    timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
 		timeout = timeouts[TCP_CONNTRACK_RETRANS];
 	else if (unlikely(index == TCP_RST_SET &&
-			  new_state == TCP_CONNTRACK_ESTABLISHED))
+			  new_state == TCP_CONNTRACK_ESTABLISHED) &&
+		 timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
 		timeout = timeouts[TCP_CONNTRACK_UNACK];
 	else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
 		 IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&


