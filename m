Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3873B42E7;
	Wed, 30 Sep 2026 19:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796237; cv=none; b=NRCncN9hFfVpC0o3q9+J4qiCAiSN01OKTbkJqFeFCGFQagIXztR3P1rKP4HNytWYNfHl3QC0DlSC6PmPAYNrfzgi2QMNUyudO50VcXp95a4lVE+hnFIpDiqng3CxkL+saLjJLMmBmtzHrPl0nnyD2JU+PCkTs+CkZs0Cp4T2suw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796237; c=relaxed/simple;
	bh=8Mbhn3TPU/MJ6wpC8QvgfnKMQ6cIkAd73ja/sOddoNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXz2aVk6+42m4S70yhFSIV1Y+cXb9NySVxYsgSStXBkxAj0E1xtws4a7jD4SCv9Dz8jatAnKi7eyDiJN6I5EdamR+Vb6C5ctsxszxNGvT+S3+RwxaPy+fhxQ8UfacwQ1d/vTyE4uadF4/QpvXQWbtnGAqq0EtrHjXkxsMuHdGYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uz327xoJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uz327xoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16531F000FF;
	Wed, 30 Sep 2026 19:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796236;
	bh=G4x58QaAPC/VbqTlVljPy3T5WYNewUuEXCfamzugL2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uz327xoJ9ucH2hakxUnGM5WdRteG12wzSHUW5idnGatx2tuxMTvHNt4EdUa+waUMV
	 iJtBR+WWDr6PwXJJD9EV1Q9S7mHDFwAY6JOYH25/nipZxCH4Zgi8vKlCX29AB+xNMw
	 JGsMDAJwUssimwLK5/39S74lcPwpiNZAcrFaGFNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Klein <amit.klein@mail.huji.ac.il>,
	Tamir Shahar <tamir.shahar1@mail.huji.ac.il>,
	Inbal Schussheim <inbal.lipshtat@mail.huji.ac.il>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 0841/1193] tcp: exclude old ACKs from tcp fast path
Date: Wed, 30 Sep 2026 17:25:25 +0200
Message-ID: <20260930152452.926842858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6029,6 +6029,7 @@ reset:
  *	  or pure receivers (this means either the sequence number or the ack
  *	  value must stay constant)
  *	- Unexpected TCP option.
+ *	- ACK sequence number is outside [SND.UNA, SND.NXT].
  *
  *	When these conditions are not satisfied it drops into a standard
  *	receive procedure patterned after RFC793 to handle all cases.
@@ -6077,7 +6078,7 @@ void tcp_rcv_established(struct sock *sk
 
 	if ((tcp_flag_word(th) & TCP_HP_BITS) == tp->pred_flags &&
 	    TCP_SKB_CB(skb)->seq == tp->rcv_nxt &&
-	    !after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt)) {
+	    between(TCP_SKB_CB(skb)->ack_seq, tp->snd_una, tp->snd_nxt)) {
 		int tcp_header_len = tp->tcp_header_len;
 
 		/* Timestamp header prediction: tcp_header_len


