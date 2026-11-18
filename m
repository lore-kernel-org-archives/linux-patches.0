Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035578;
	b=pAJsaD5edY/KbYUhxgNnsLKiLgmTI3RjvmQmx7n5+1Epdu7vVp3mHgirKzVE6ZJF97k1
	 5z8KOPy3h8SELfR1gCpgYVGgJl/+7amNoI/USfIRGcHY+3mlfzqBl1uOaP6CEGvqvmakY
	 VLUYOb5Wvcjk3KkRPINijPrqc0mUaq92X5JyKny1sBYZXnQC1sbL0OgI68gFS8ifaLe7u
	 Pz4D2M9nyesbwgaBxfMp/XgesFvvxZ6a6gK5WB+EYL+3+0oviYKGOwdxMB2NxMcRAyF3X
	 cQYWlC5v6WdKiF7SDanxzrLPAUOsj5VA2rLwooPfDz2aPdAFmUzt/a9TjoSBZsxnpLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Bfpf2cwkPPACN4SVXgn7E3BSDtwMt9tbCty55Q76T8=;
	b=eMnwDz6xY3caE7o2/somsZyrKVwjskxV1m3DO0eRjmCjWNKSBMlfiMXv9/4bmiChIh9D
	 +OYTIN3WBWgA1s6L5akFdZL4igiZQ1NFtG3OCNnTGIkP1fxIx14y4BenpHZZY9nGlbnGw
	 D/oRLCi6aUWAli3Mdn9XJUBqAiXBSYILfqCIWqphxXAub+TEkCoe5soVP0VxTFZoIUpCl
	 BB5L+bxOPISSOaKyKpXEw85kLrRel6NFm5OmyU7uWoVmOVLQMfgZHvBFH5f4oW31DRj03
	 GGmrq0uYHnzenMD0fSJvRPjuQv2GnXZxCOTboKHSd8E1mranUeC7G4fUs8/IvUsHHgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tohcuPsg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B79606A31C;
	Wed, 18 Nov 2026 20:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tohcuPsg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB81F1F000C4;
	Wed, 18 Nov 2026 20:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035578;
	bh=8Bfpf2cwkPPACN4SVXgn7E3BSDtwMt9tbCty55Q76T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tohcuPsgWYPfC0QX+WFiGznfuTI+w5C6S4nQpeyAccxCBJtprC/EbnhClam0yvn5v
	 snOiH633RXqqQKhHeyES9cY04aYQrHf8iG6JQixAQioWWB5AAOuJ66EdYNl0IngBc3
	 4V1l4xXBmSwcb70z83q3StBZKxjX5ZyW5lXRI4P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 0755/3318] netfilter: conntrack: always lower timeout for non-closing RST packets
Date: Wed, 18 Nov 2026 15:22:57 +0100
Message-ID: <20261118150341.320008954@linuxfoundation.org>
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
@@ -1325,7 +1325,8 @@ int nf_conntrack_tcp_packet(struct nf_co
 	    timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
 		timeout = timeouts[TCP_CONNTRACK_RETRANS];
 	else if (unlikely(index == TCP_RST_SET &&
-			  new_state == TCP_CONNTRACK_ESTABLISHED))
+			  new_state == TCP_CONNTRACK_ESTABLISHED) &&
+		 timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
 		timeout = timeouts[TCP_CONNTRACK_UNACK];
 	else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
 		 IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&


