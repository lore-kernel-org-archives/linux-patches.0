Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831942;
	b=xV5uJQWf2U4uSI57Ze/4ZW9xic5P/CN7Hf+kGtwzkY/fShaoDL6lPxUtsLpeyvHngYMO
	 1h79Up3RBzzhe6srd/aGLGLv5KlFKQh9FdSnzNmiVzSZAbaJAU7/QQZJob5GtFZ0O6tKL
	 kZxjinkpxrB/iDxx0nb15ZMPIW9GHIbrDxmqfDToSja6pQ5WGdHESxFyj6qHmnOpsHXoe
	 rB5Q0HRxuFh+9O/GM62yJS2QqiTF5W5KPs0HKq9WqZFcf3Pejn1L10KiJoMNM9M5lZbPI
	 hk3JgypyYB9AqA2S8bhvRQ3VfrF7m1xHNl9olGw7O9664nEB7Aoz1bQulM5XDYk+2pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831942;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yWLxBFjC28Iz3ik3JuOabhwjR6+YCFiD3Jj5Mw6lS78=;
	b=jKqFlXRfJH2LhunqTIb8T/CG5wzPkoQgiqJJ+ygp7+7kiqi4D2H+YY3l5MIJkwpcagqO
	 SLvg+YL11xyAV8KupTcFBNIJPo6aVhX21yU61CYdnO+ytZhqrYHRMdCQssr7WmXMD+n75
	 ovh0NLNDqrBYhJooSpiQ5AJdomXlrhI0/VZtbnq/Uu88Vhme/7BXrgbiKMww/7MrjvyrN
	 sg8vwywmLUdzH2+NWah16uo3dpHr7W5VlsvzPxrTXS0VI+spWcvdb20NZNiZ0mlMepoRT
	 dpzW/25H0LD10KHux8L1rRnnxhlE/J/576NnvQx7tkmqxfSPZ14tWJMkrWbEcQyGkUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wzbeSF13;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8E0606A328;
	Wed,  4 Nov 2026 22:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wzbeSF13
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDAC1F000C1;
	Wed,  4 Nov 2026 22:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831942;
	bh=yWLxBFjC28Iz3ik3JuOabhwjR6+YCFiD3Jj5Mw6lS78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wzbeSF13UW0HA+jSHb8gB4KtkYazVWRGCVFW6o8lBStrR7g8cVdnWwj3qEeb5Ubw6
	 8WvpzxhDwif8VgxJcMglWNTEYixiz/H2r8v0eDlu/GjQ+sbA9cAbgeV1hmse3Nlk18
	 LBg4JafWmkcFOLUBGB/0aLR+hkPiRHwZMmRt3+YY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.18 1003/1005] netfilter: conntrack: always lower timeout for non-closing RST packets
Date: Wed,  4 Nov 2026 16:12:16 -0500
Message-ID: <20261104211111.115910406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1326,7 +1326,8 @@ int nf_conntrack_tcp_packet(struct nf_co
 	    timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
 		timeout = timeouts[TCP_CONNTRACK_RETRANS];
 	else if (unlikely(index == TCP_RST_SET &&
-			  new_state == TCP_CONNTRACK_ESTABLISHED))
+			  new_state == TCP_CONNTRACK_ESTABLISHED) &&
+		 timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
 		timeout = timeouts[TCP_CONNTRACK_UNACK];
 	else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
 		 IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&


