Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865CC286A4;
	Sun,  7 Jun 2026 10:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829141; cv=none; b=o8O46rIoexEcwbC2KQjV9XypepLMrDv0SzWNXhchvgmV+3vyt1gCjgc+ugqOIO2ALVI3LOhGHznIM/44IMVcuepqVWITiuUYBDs73Qhf3GQ8Dij8/bJWgnnVxptqPhZ6zH/062HMYwpn+Wh4fbNywZtC0SamXqmgcla/lEZJRJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829141; c=relaxed/simple;
	bh=Dajycjm7EfglQ0Z7Eum8UiQOe3+X46+f6VthfGoXOD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifWsv6Co76CI+gJbsU6IdD0RAYevUTuGJ05Jy6zQcKcJAs+mc3Ttz32uSTfUsCUibZE9wRid6yIf8B8mffS3j7aSc8ctuN1fMr1VW/KDcTSz0sGApBtFBFcEvU6aKVoRItwvhBy7f/tPQIh6IWYWQN5UluMPParS1y9IFVWJqQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LbJrSHZA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LbJrSHZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7941F00893;
	Sun,  7 Jun 2026 10:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829140;
	bh=9wSwsMlPaRXKC0AMBZXeLM+qGcX3gLs0g2WP3oGjOXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LbJrSHZAu58jWWDFgxcK6rcKkGCfE0rxO2eiRl9xhQXKvSYmHFOb2QhqpDAUZ2XQD
	 XZkjC6InTmvzVgEFqQDs3pL7LHzDzBtr3S0jVc0IZNO5aSNjHRYrN2nnZaZqm0o3W5
	 y+6ATGOM2KYx+0rYMZtwiqiXRj49HypX1nIe+4/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.12 199/307] xfrm: ah: use skb_to_full_sk in async output callbacks
Date: Sun,  7 Jun 2026 11:59:56 +0200
Message-ID: <20260607095735.036825249@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 79d8be262377f7112cfa3088dfc4142d5a2533f3 upstream.

When AH output is offloaded to an asynchronous crypto provider
(hardware accelerators such as AMD CCP, or a forced-async software
shim used for testing), the digest completion fires
ah_output_done() / ah6_output_done() on a workqueue.  The egress
skb at that point may have been originated by a TCP listener
sending a SYN-ACK, which sets skb->sk to a request_sock via
skb_set_owner_edemux(); it may also have been originated by an
inet_timewait_sock retransmit.  Neither is a full struct sock, and
passing the raw skb->sk to xfrm_output_resume() then forwards a
non-full socket through the rest of the xfrm output chain.

xfrm_output_resume() and its downstream consumers expect a full
sk where they dereference at all.  The natural egress path
through ah_output_done() does not crash today because the
consumers that read past sock_common are either gated by
sk_fullsock() or short-circuit on flags that are clear on a fresh
request_sock; an exhaustive walk of the 50 most plausible
consumers under sch_fq, dev_queue_xmit, netfilter, tc-egress and
cgroup-egress BPF found no current unguarded deref.  The bug is
still a real type confusion that future consumer changes could
turn into a memory-corruption primitive.

This is the same bug class fixed for ESP in commit 1620c88887b1
("xfrm: Fix the usage of skb->sk").  Apply the analogous fix to
AH: convert skb->sk to a full socket pointer (or NULL) via
skb_to_full_sk() before handing it to xfrm_output_resume().

The same async AH callbacks were touched recently for an
independent ESN-related ICV layout bug in commit ec54093e6a8f
("xfrm: ah: account for ESN high bits in async callbacks"); the
sk type-confusion addressed here is orthogonal.  This patch is
part of an ongoing audit of the AH callback paths; an ah_output
ihl-validation hardening series is also currently under review on
netdev.

Reproduced under UML + KASAN + lockdep with a forced-async
hmac(sha1) shim that registers at priority 9999 and wraps the
sync in-tree hmac-sha1-lib.  With the shim loaded, ah_output_done
runs on every SYN-ACK egress through a transport-mode AH SA and
skb->sk arrives as a request_sock (TCP_NEW_SYN_RECV); after this
patch, xfrm_output_resume() receives the listener (the result of
sk_to_full_sk()) and consumer derefs land on full-sock fields as
intended.

Fixes: 9ab1265d5231 ("xfrm: Use actual socket sk instead of skb socket for xfrm_output_resume")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ah4.c |    2 +-
 net/ipv6/ah6.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -143,7 +143,7 @@ static void ah_output_done(void *data, i
 	}
 
 	kfree(AH_SKB_CB(skb)->tmp);
-	xfrm_output_resume(skb->sk, skb, err);
+	xfrm_output_resume(skb_to_full_sk(skb), skb, err);
 }
 
 static int ah_output(struct xfrm_state *x, struct sk_buff *skb)
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -337,7 +337,7 @@ static void ah6_output_done(void *data,
 	ah6_restore_hdrs(top_iph, iph_ext, extlen);
 
 	kfree(AH_SKB_CB(skb)->tmp);
-	xfrm_output_resume(skb->sk, skb, err);
+	xfrm_output_resume(skb_to_full_sk(skb), skb, err);
 }
 
 static int ah6_output(struct xfrm_state *x, struct sk_buff *skb)


