Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BAF4D1784;
	Wed, 30 Sep 2026 17:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788573; cv=none; b=klaynKs5ZdcaMzPGKyS/x2/+cRYKdc+Hux0X/vVUb2MN8g488FKUzsM2N25Mvn/tUPRlzhxriY4A4yqXiRVgMDIE8I39MOX028CDQEcvO45eVu485c/BPP7WzxIJosACNfzXSVzCZk8vt638UM+qm6+URMcXQQLxtlJfjK/kVKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788573; c=relaxed/simple;
	bh=GQvtBA66+Cr4ALlbqzGCG37iroBHAU2WnVi1pegS7Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r94k9W6/7miz0mQGQcpNxI3dWS2TX7G1GXhVU9hh8j9f42p46KqsizhRO0GAixqPl2rq1uKN6pQhOpKR8UD87brMiFx91DVQkj3ScKlLZmcB4xAcxJDXPyGUt4Ha75uExy1Xx1O4uNY6sPN0IP5cUdQ7/L0GWscyqBeAO8voGME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4Ky358F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4Ky358F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F99C1F000FF;
	Wed, 30 Sep 2026 17:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788572;
	bh=RE68Hom41PGG93Ma6SwMiBgM+MhzX3uSpHFshXrMLxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b4Ky358Fodn6gdOeVjPVQFkVLVbN5YSLiAIMS8U1J4TKhol8YDdo/fyOBZbnAQ9bX
	 M0jqBSoNAQlI9EPN7JKSyPZ4WQT+2tD9Mo8qO7+M4GoIlzxvRKi0ArgxbmcmZq9gy0
	 im69oRdbunl3kw0QM0kX+na/HGhxJB2t80Z11Blw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Klein <amit.klein@mail.huji.ac.il>,
	Tamir Shahar <tamir.shahar1@mail.huji.ac.il>,
	Inbal Schussheim <inbal.lipshtat@mail.huji.ac.il>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 173/877] tcp: exclude old ACKs from tcp fast path
Date: Wed, 30 Sep 2026 17:18:04 +0200
Message-ID: <20260930152418.460694272@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
@@ -6138,6 +6138,7 @@ reset:
  *	  or pure receivers (this means either the sequence number or the ack
  *	  value must stay constant)
  *	- Unexpected TCP option.
+ *	- ACK sequence number is outside [SND.UNA, SND.NXT].
  *
  *	When these conditions are not satisfied it drops into a standard
  *	receive procedure patterned after RFC793 to handle all cases.
@@ -6186,7 +6187,7 @@ void tcp_rcv_established(struct sock *sk
 
 	if ((tcp_flag_word(th) & TCP_HP_BITS) == tp->pred_flags &&
 	    TCP_SKB_CB(skb)->seq == tp->rcv_nxt &&
-	    !after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt)) {
+	    between(TCP_SKB_CB(skb)->ack_seq, tp->snd_una, tp->snd_nxt)) {
 		int tcp_header_len = tp->tcp_header_len;
 
 		/* Timestamp header prediction: tcp_header_len


