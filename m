Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789EF1AD415;
	Thu, 15 Aug 2024 14:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730934; cv=none; b=mgQ1gUBmMrh1JAAQZZLLXD5na0K1XCE9M7vOon8rBxCMG07hl3npnkRBWPiY+9Cdk8KJhIodKtuvoYnKdOnkSTFbxphqqbUC0KDs7B4/EYvA0lYWxQAIOQlVHOaqiXsJF74rWaoV7aAPgzHeFO6NpzrGxZlXz/oznIYIYZu3RmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730934; c=relaxed/simple;
	bh=oIoq8Z5GqPkSnKX3LKDvxiHgIzgJ+QIwtiMwrk1m4Og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MO3ScJb6TLvDdjs1KpJ3LQFYuj/nG23KobaTOFIjMUb1zkwjqjwQ4eLu0fpbbdXFbMaWs0TPZyPaUw+s13uqtoLsXwHkfrsnDCh28rGKDXQbJtGCFfAz+l7JRM1YiJ2wMXTbLNH++PKYrJ+wQND544wkxWfUjB+k6i34RTYDpYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z08Z29DV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z08Z29DV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8CCC4AF0C;
	Thu, 15 Aug 2024 14:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730934;
	bh=oIoq8Z5GqPkSnKX3LKDvxiHgIzgJ+QIwtiMwrk1m4Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z08Z29DVDczcF49YI31WsjfbUevbnjUbJ2GfICz58O98zLPO8cFTQx0adOsqAv5Yt
	 h+3VGNa9GBFcOWlg76Mo1tc4ZoTBgn+mFPrvqI3eCRELCniOedZHu3nVfVr1U+7lUa
	 s7hn6+56APkCLVy1VOukr002zKaOnbwQsoXk7Wvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8bb053b5d63595ab47db@syzkaller.appspotmail.com,
	Xin Long <lucien.xin@gmail.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 38/67] net: sctp: fix skb leak in sctp_inq_free()
Date: Thu, 15 Aug 2024 15:25:52 +0200
Message-ID: <20240815131839.781097193@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



