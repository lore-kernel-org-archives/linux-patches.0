Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C864553161E;
	Wed, 23 Sep 2026 14:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173587; cv=none; b=hGE/thX+OV60hVK41hG7lyYbe5n7XMVQp6kzmoQPnOIvuxa0zBIhZF4PPd2KrnznNV+0LzUHs7FLOpoYX38ELXGkXnHagMNZ9ovqpMOZ0wCs1Npk+PKRELMDazcZKDoUY/ixk0d2PVYuF7btUqBj96xCh2SoCiFOJxUeavTeyzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173587; c=relaxed/simple;
	bh=CP3RzYDVN4nmdgPlO3HXLl3orXgXmOHO3bcqts+aikM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7Gk8EoMjZY6J+BQr36wYeqxcQIrkUnhpW6+Mj9t3JKtsmfO037M3jLdDHBvi6bbEPQsLNW+SppF4it2uw7L0i7d7BVmO/ER/mqtJpY1sA39kz0fHcd0X8tX9vKRWxFbDnX5GwUVMG8duQlvAKT0touzFg4S5FcJ1Ab3465FL+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e30E6dKE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e30E6dKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02741F00893;
	Wed, 23 Sep 2026 14:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173585;
	bh=XwcTvu56zY40QjtliYIaM6ELYwbxVri7m93w1Sp+UOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e30E6dKE2if1dC4X7yzT97WEZPAekEDb3B8uzBF2er9oMTj6zB7JGpmiGM2zPwTnW
	 j54u6qRq0o9M+d+zS7CsGA6KECipoaJJssgX6k0dQQ7I9B9TwGpMl4IuepI/1I/NUh
	 rCffdRlllTEUjWcC387dvjnRG/ajDTNbbyRpWvds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Klein <amit.klein@mail.huji.ac.il>,
	Tamir Shahar <tamir.shahar1@mail.huji.ac.il>,
	Inbal Schussheim <inbal.lipshtat@mail.huji.ac.il>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.2 259/438] tcp: exclude old ACKs from tcp fast path
Date: Wed, 23 Sep 2026 16:04:40 +0200
Message-ID: <20260923140651.487795304@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6490,6 +6490,7 @@ reset:
  *	  or pure receivers (this means either the sequence number or the ack
  *	  value must stay constant)
  *	- Unexpected TCP option.
+ *	- ACK sequence number is outside [SND.UNA, SND.NXT].
  *
  *	When these conditions are not satisfied it drops into a standard
  *	receive procedure patterned after RFC793 to handle all cases.
@@ -6539,7 +6540,7 @@ void tcp_rcv_established(struct sock *sk
 
 	if ((tcp_flag_word(th) & TCP_HP_BITS) == tp->pred_flags &&
 	    TCP_SKB_CB(skb)->seq == tp->rcv_nxt &&
-	    !after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt)) {
+	    between(TCP_SKB_CB(skb)->ack_seq, tp->snd_una, tp->snd_nxt)) {
 		int tcp_header_len = tp->tcp_header_len;
 		s32 delta = 0;
 		int flag = 0;


