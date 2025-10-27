Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E0731E0F2;
	Mon, 27 Oct 2025 19:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591958; cv=none; b=Ot/2nLXtRl4kaojFTpBWlpxZMJwM+sUI+iLDW0Z0rseEZxPAZp4DCFA90TKY75CA9Dy6NxE8ebuvSsMp+phlGRoOgjTP4WEpR6eaQO51ovPOpcI+uFWeLXlOxlaTeN2qBobhAsqKbDEqjlQMtiXuQBG2GNPJBeb6nN5H3N2I4LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591958; c=relaxed/simple;
	bh=OrhHCllAyDCpHforBJX/tVzi12vJWr1H5tmWlXii7sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kmb1XT3du460OL8vLyPiQDwiBXryEJ8qh1Yw/N5h90Z7PGZhGEC/k5ZMgrnL0H8IQYhDQwZXJZUGACd8FFdg00zGiI7g5E0g6VW4GZGO0ex8UOd9rF0W7Gv+FENpGZjEw92LCzklUntbJN9SibyVyPq2J19SdC84ncvt5NBDDo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wg4ZE9oi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wg4ZE9oi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6E4C4CEF1;
	Mon, 27 Oct 2025 19:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591958;
	bh=OrhHCllAyDCpHforBJX/tVzi12vJWr1H5tmWlXii7sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wg4ZE9oitD78ezsh8nDWaBwFvoPMBWkTuq4KngQxybt2dRtR1ddjfk2LtL5qw9FmC
	 y0Lz9HuVi7rQ4irgkzgmALOxx41lnyOXSi3nVuJPxq3tAO79wLVhOQoGg9pahnMi74
	 r0cihtGjM++ZzubiJAZj7E6O+knMr7FPFACiHsso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Simakov <bigalex934@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/123] sctp: avoid NULL dereference when chunk data buffer is missing
Date: Mon, 27 Oct 2025 19:35:42 +0100
Message-ID: <20251027183448.054911353@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

From: Alexey Simakov <bigalex934@gmail.com>

[ Upstream commit 441f0647f7673e0e64d4910ef61a5fb8f16bfb82 ]

chunk->skb pointer is dereferenced in the if-block where it's supposed
to be NULL only.

chunk->skb can only be NULL if chunk->head_skb is not. Check for frag_list
instead and do it just before replacing chunk->skb. We're sure that
otherwise chunk->skb is non-NULL because of outer if() condition.

Fixes: 90017accff61 ("sctp: Add GSO support")
Signed-off-by: Alexey Simakov <bigalex934@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Link: https://patch.msgid.link/20251021130034.6333-1-bigalex934@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/inqueue.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/sctp/inqueue.c b/net/sctp/inqueue.c
index 7182c5a450fb5..6a434d441dc70 100644
--- a/net/sctp/inqueue.c
+++ b/net/sctp/inqueue.c
@@ -163,13 +163,14 @@ struct sctp_chunk *sctp_inq_pop(struct sctp_inq *queue)
 				chunk->head_skb = chunk->skb;
 
 			/* skbs with "cover letter" */
-			if (chunk->head_skb && chunk->skb->data_len == chunk->skb->len)
+			if (chunk->head_skb && chunk->skb->data_len == chunk->skb->len) {
+				if (WARN_ON(!skb_shinfo(chunk->skb)->frag_list)) {
+					__SCTP_INC_STATS(dev_net(chunk->skb->dev),
+							 SCTP_MIB_IN_PKT_DISCARDS);
+					sctp_chunk_free(chunk);
+					goto next_chunk;
+				}
 				chunk->skb = skb_shinfo(chunk->skb)->frag_list;
-
-			if (WARN_ON(!chunk->skb)) {
-				__SCTP_INC_STATS(dev_net(chunk->skb->dev), SCTP_MIB_IN_PKT_DISCARDS);
-				sctp_chunk_free(chunk);
-				goto next_chunk;
 			}
 		}
 
-- 
2.51.0



