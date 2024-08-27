Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141AE1C9DC2;
	Tue, 27 Aug 2024 15:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771923; cv=none; b=Z+zVwF8b9/lE/7UN1+0sk+xCeqjqMVeYn1t/8JrBFeBpkd89Mw+UZw3WbE55rWGfOo/PNJvtaOsH6Jgm/b4M+qtmGn0atUepDlEdxj7U/kfY32UVbG27ELQdrXhOfp7OQtTYH6gLxvdBlf+nlaQrp0Zw1XeHMrtJ5HelbFxXAOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771923; c=relaxed/simple;
	bh=gxuBoakmVpZvoPtZPJKWwd/lALN9v3mT76y2e9G2wfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDRoINB+C/VsPmQES2z/U/3rPbNe/rFrK7qI5uHS+3kso+KuoX9uxYRyRl1thjCBt13oyBCvV46DxTOUvEruw9hNjzMK11cZlrQ8ikFw2YwtxsDjyBqOfjP94+eR3Ulh3yteUcqOFfP7sEPLyQgnBsYbnSkJuiOE55NhF9eBbeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kf+L0ID3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kf+L0ID3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF03C61067;
	Tue, 27 Aug 2024 15:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771921;
	bh=gxuBoakmVpZvoPtZPJKWwd/lALN9v3mT76y2e9G2wfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kf+L0ID3U7l8NXvWdfoH3V8+k8YNeIoj8EPv3YEU4bWWWVbxL3S8ssNFUAm65o9n2
	 CBpIE+1KoPGwvJ+6+O49JYtO9Rv2vW+1Ia7GeQkVNriMRhptiQNe5Wh0MFHL46pALm
	 b2XP9Lr/VMuSrBdP3z92KlMTffuVyqN6K0weoe9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8bb053b5d63595ab47db@syzkaller.appspotmail.com,
	Xin Long <lucien.xin@gmail.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/321] net: sctp: fix skb leak in sctp_inq_free()
Date: Tue, 27 Aug 2024 16:36:08 +0200
Message-ID: <20240827143840.521932209@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 4e45170d9acc2d5ae8f545bf3f2f67504a361338 ]

In case of GSO, 'chunk->skb' pointer may point to an entry from
fraglist created in 'sctp_packet_gso_append()'. To avoid freeing
random fraglist entry (and so undefined behavior and/or memory
leak), introduce 'sctp_inq_chunk_free()' helper to ensure that
'chunk->skb' is set to 'chunk->head_skb' (i.e. fraglist head)
before calling 'sctp_chunk_free()', and use the aforementioned
helper in 'sctp_inq_pop()' as well.

Reported-by: syzbot+8bb053b5d63595ab47db@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?id=0d8351bbe54fd04a492c2daab0164138db008042
Fixes: 90017accff61 ("sctp: Add GSO support")
Suggested-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/20240214082224.10168-1-dmantipov@yandex.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/inqueue.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/sctp/inqueue.c b/net/sctp/inqueue.c
index 7182c5a450fb5..5c16521818058 100644
--- a/net/sctp/inqueue.c
+++ b/net/sctp/inqueue.c
@@ -38,6 +38,14 @@ void sctp_inq_init(struct sctp_inq *queue)
 	INIT_WORK(&queue->immediate, NULL);
 }
 
+/* Properly release the chunk which is being worked on. */
+static inline void sctp_inq_chunk_free(struct sctp_chunk *chunk)
+{
+	if (chunk->head_skb)
+		chunk->skb = chunk->head_skb;
+	sctp_chunk_free(chunk);
+}
+
 /* Release the memory associated with an SCTP inqueue.  */
 void sctp_inq_free(struct sctp_inq *queue)
 {
@@ -53,7 +61,7 @@ void sctp_inq_free(struct sctp_inq *queue)
 	 * free it as well.
 	 */
 	if (queue->in_progress) {
-		sctp_chunk_free(queue->in_progress);
+		sctp_inq_chunk_free(queue->in_progress);
 		queue->in_progress = NULL;
 	}
 }
@@ -130,9 +138,7 @@ struct sctp_chunk *sctp_inq_pop(struct sctp_inq *queue)
 				goto new_skb;
 			}
 
-			if (chunk->head_skb)
-				chunk->skb = chunk->head_skb;
-			sctp_chunk_free(chunk);
+			sctp_inq_chunk_free(chunk);
 			chunk = queue->in_progress = NULL;
 		} else {
 			/* Nothing to do. Next chunk in the packet, please. */
-- 
2.43.0



