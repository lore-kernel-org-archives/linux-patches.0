Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4AB38DC66;
	Wed, 30 Sep 2026 18:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792057; cv=none; b=aBADKD+LLPK+wKuIpzLiajjcF0Z8kisl5FFFgx0qxp21xeZ39tyh1kg8TpX0jo84tnDhFYL5fCqaLnVL0UdxUCygsuQVXDLBdoYv/i+gbSmO5isH6YgdOMcfb/erxrv39pPpgFCsADAd+cZ3iUCi/FqwNU1/nqLo4rrPLtBPtt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792057; c=relaxed/simple;
	bh=sQxW3XkMhalzX5M6Ld7qssmSra0EIdzolyoFFt7wWcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/nAOD59iqxCagHoVlydLLjdpRSi0g/rj8NzFVx1JSbxAwXKJU82WrgAPTGhq/NU55xhlIlNrTDUEqicEPLZJjKyt0DdfhE15AgAP3SPPdScV/RCgCRwidpz9VRXvdid7TvfCXe9G9bC4vB3SbL5Cin35GVZOT3HgJQrs5ZWqA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uOez94d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uOez94d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AFC1F000FF;
	Wed, 30 Sep 2026 18:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792055;
	bh=gucl2YklFSG5rffQmNwAXWRtBcrBjhJhruyHHILSoug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0uOez94dGH6Z2Ckkn2SqYBLrY742cdFxeKH66NiGLiMaLRcAVpF/iosXtNThukxfP
	 vko5ht4bPzEcr/JGDvLZPcK5eQhqpZDaTFYlOfLUHHqendBC7EQLo2Otv4kpTWZh1/
	 U7IZSlLsIxyjablaTqn7KuPMtZxFT6Fqe8b4qXKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Klein <amit.klein@mail.huji.ac.il>,
	Tamir Shahar <tamir.shahar1@mail.huji.ac.il>,
	Inbal Schussheim <inbal.lipshtat@mail.huji.ac.il>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 521/752] tcp: exclude old ACKs from tcp fast path
Date: Wed, 30 Sep 2026 17:26:31 +0200
Message-ID: <20260930152409.530921997@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Inbal Schussheim <inbal.lipshtat@mail.huji.ac.il>

commit f81e6c3fb06327bc49cdd6e559845293ba06a704 upstream.

Exclude old ACKs before SND.UNA from the tcp fast path
as well as ACKs after SND.NXT.

Such ACKs will fall through to the slow path, where tcp_ack()
performs the appropriate validation and challenge ACK handling
according to RFC5961 and Commit 3d501dd326fb1c7 ("tcp: do not
accept ACK of bytes we never sent").

This prevents old ACKs from being accepted
or modifying connection state as part of the fast path before
appropriate ACK validation is applied.
In particular, this prevents payload carried by a segment with
an excessively old ACK from advancing RCV.NXT before the ACK
is rejected.

Fixes: 31770e34e43d ("tcp: Revert "tcp: remove header prediction"")
Reported-by: Amit Klein <amit.klein@mail.huji.ac.il>
Reported-by: Tamir Shahar <tamir.shahar1@mail.huji.ac.il>
Reported-by: Inbal Schussheim <inbal.lipshtat@mail.huji.ac.il>
Suggested-by: Eric Dumazet <edumazet@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Inbal Schussheim <inbal.lipshtat@mail.huji.ac.il>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260914090408.1435080-2-inbal.lipshtat@mail.huji.ac.il
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5891,6 +5891,7 @@ discard:
  *	  or pure receivers (this means either the sequence number or the ack
  *	  value must stay constant)
  *	- Unexpected TCP option.
+ *	- ACK sequence number is outside [SND.UNA, SND.NXT].
  *
  *	When these conditions are not satisfied it drops into a standard
  *	receive procedure patterned after RFC793 to handle all cases.
@@ -5938,7 +5939,7 @@ void tcp_rcv_established(struct sock *sk
 
 	if ((tcp_flag_word(th) & TCP_HP_BITS) == tp->pred_flags &&
 	    TCP_SKB_CB(skb)->seq == tp->rcv_nxt &&
-	    !after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt)) {
+	    between(TCP_SKB_CB(skb)->ack_seq, tp->snd_una, tp->snd_nxt)) {
 		int tcp_header_len = tp->tcp_header_len;
 
 		/* Timestamp header prediction: tcp_header_len


