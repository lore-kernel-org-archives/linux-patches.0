Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DC943AD7;
	Tue, 14 May 2024 11:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687276; cv=none; b=lQf/V1Pt4y+3R6Opc7tug7K8jr/LKFgrtWKSqzla57fOQ1ISbeb9iHTuaWRd51KPOH8QwJFyXTHw+fNZeH5pqm0+PyM4YF4/sSKWYOWUiCMTEjN3VR38IJcbPaFJ5MKbSe0YYpshdfcUFDq1rLznzuk1tVNnQXAiZ28uxSilIro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687276; c=relaxed/simple;
	bh=JS3DDoVs6r48aYDIaeEXUanZ4u7YPeL+IwAjXeTWSZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soORwkf9V4eScpXEH/jAKZvtvoZmGhNosbBtz+3xKPA+hpIE0ZQNINn34RkTp3xmPgidEoqhVrPWEfmwM8LrJLPz0MfUT3y0Sw54AgfoB4YeR41EaepGfcn6R9qcl5jqM8XnfGFrFjM2PYH0O5A249grJNwDkdhzD85F6a/vHrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXy4RNMh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXy4RNMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39131C2BD10;
	Tue, 14 May 2024 11:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687276;
	bh=JS3DDoVs6r48aYDIaeEXUanZ4u7YPeL+IwAjXeTWSZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXy4RNMhOYK135ecgoc4Z+dRtAWFTQ6FdVxVhtPH3xFwVZ9QkdU7L+g4PIl/SEKlh
	 pJMdhrYOUM9Iu664LEX4CqmMzjZGxHuUWQSNpYM/2U2cX3g6jzXFllY0930rAYd6XX
	 2U/PhAOWDmaU5vWWY4YhNW9SlrhmYiF4LBd3yeoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Gobert <richardbgobert@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/111] net: gro: add flush check in udp_gro_receive_segment
Date: Tue, 14 May 2024 12:19:38 +0200
Message-ID: <20240514100958.657915968@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Gobert <richardbgobert@gmail.com>

[ Upstream commit 5babae777c61aa8a8679d59d3cdc54165ad96d42 ]

GRO-GSO path is supposed to be transparent and as such L3 flush checks are
relevant to all UDP flows merging in GRO. This patch uses the same logic
and code from tcp_gro_receive, terminating merge if flush is non zero.

Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_offload.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 445d8bc30fdd1..a0b569d0085bc 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -431,6 +431,7 @@ static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
 	struct sk_buff *p;
 	unsigned int ulen;
 	int ret = 0;
+	int flush;
 
 	/* requires non zero csum, for symmetry with GSO */
 	if (!uh->check) {
@@ -464,13 +465,22 @@ static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
 			return p;
 		}
 
+		flush = NAPI_GRO_CB(p)->flush;
+
+		if (NAPI_GRO_CB(p)->flush_id != 1 ||
+		    NAPI_GRO_CB(p)->count != 1 ||
+		    !NAPI_GRO_CB(p)->is_atomic)
+			flush |= NAPI_GRO_CB(p)->flush_id;
+		else
+			NAPI_GRO_CB(p)->is_atomic = false;
+
 		/* Terminate the flow on len mismatch or if it grow "too much".
 		 * Under small packet flood GRO count could elsewhere grow a lot
 		 * leading to excessive truesize values.
 		 * On len mismatch merge the first packet shorter than gso_size,
 		 * otherwise complete the GRO packet.
 		 */
-		if (ulen > ntohs(uh2->len)) {
+		if (ulen > ntohs(uh2->len) || flush) {
 			pp = p;
 		} else {
 			if (NAPI_GRO_CB(skb)->is_flist) {
-- 
2.43.0



