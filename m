Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABFD32ABC6;
	Mon, 27 Oct 2025 18:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590838; cv=none; b=fRIkmRK95v4db+0DfAnzUPHYJOkxWvnvmg6zMBOzXLvEXvt3UKOyswzPoP6RFesX817fl/Kq3TjpZnznRk+Papc8sz573WpdR1jmsoPeHoaa+8XNok+kU7EUmAwMGZkL9xGH8UlcF/TUJZIEX9not6TLCegW+wnzasdgWR4pNU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590838; c=relaxed/simple;
	bh=TGu57wkya5WjqlABO9OFyooL83KfpIB/Qe+MxcG5/jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jgWh4fixw7t9OSYIXYKRPhxiJfnTnbMeLJmO+ALXPGl0XzXifhgwHB+ln6sqKL7EQGy0wvmSqAukZV09eGY6KnMiXf1adts9E/ZcnjTSzuKey506ylS3V307o3PuhC6s9AimCMRzy1Gi83rubJ3qZevFcOWzMhJEbU12DHRk+5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIe4cCk4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIe4cCk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A404C4CEF1;
	Mon, 27 Oct 2025 18:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590837;
	bh=TGu57wkya5WjqlABO9OFyooL83KfpIB/Qe+MxcG5/jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIe4cCk4u/UBtLSJWTG6SFfKOyU3TWMpsqW8CBVZKRnhCsawGketjQQXdf1TmIXTS
	 Ec68uvN8yd5i6uWhYtHvsVfsdkBfzHAT01YfBpsu/KcKKbmWaVatU+a5i9uf9UyrGL
	 NEcpd/l7Lni9kpRQiV7YkWrfj/CmpIUcaGJXq+Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Simakov <bigalex934@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 193/224] sctp: avoid NULL dereference when chunk data buffer is missing
Date: Mon, 27 Oct 2025 19:35:39 +0100
Message-ID: <20251027183513.990184614@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



