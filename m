Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063322;
	b=biNNKVz5coAgMsao+xHTuBcYF/Gf+Cfcv9dl5NWH3QTFy6ShheBCNsEJuFaCg9y3VO0P
	 IUg2Cx9df3bLMtVz7Lj1BorgpTu/BFafAkZD4olSwmrG1aBnzI//un9cIH9KmwfaLQoDw
	 wJ2DjXiVYZAcxfsoOQBWbnLErJD5QfATbpmj/WsC997DRyxS5vLB40SlctICcS2KA05fZ
	 IfUW0oluTizmEJQzpxmCmXEqv/1sfGEFiCi1hjOmgvlK4RdWGAKe234IPXWe1FLWEh4B5
	 2PI8ON44QKif9PfxJkADLJj/ow74/YuMzql6FTJTIMoMDCLUj1nNzYXvxsegKZRk/9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZN8dBBV7uS0VAnGzOzdesbnhev/LqLovj0+lgT1wDcY=;
	b=J3aZFJte2FFGyhOKNFHe93Lb9fe0R8WepwV914vULgL6pLBqJN9KnbbDOEP2DNd4+BpX
	 zGI52Guhbf+opILv0i6wyr/q5hdmj3rqtrsnKX+QzbVhUViZU1fg0vsSIuQqApD46Q35h
	 2tXij7EEQrfyzcKacjCSMBfmqnc4T9oQj2cbG/53be6I0YmjnrJKsh4jB1I7+3pLMcdP8
	 8IdVG1DSBBUNgV4NQUK5/gglfUiLOS05zOHM27POapkLg27KovrswSmS1Yz2NNdSQUX+3
	 +efyr12skxWb60j86Hl/5oAeT0USnvdZAFrXJyWkDqFW5mDPpUCZOWKSAK1ZOiP3GSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UObjGIu2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C6B606EE8B;
	Sat,  7 Nov 2026 14:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UObjGIu2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FD71F0089F;
	Sat,  7 Nov 2026 14:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063322;
	bh=ZN8dBBV7uS0VAnGzOzdesbnhev/LqLovj0+lgT1wDcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UObjGIu2iZdutq5Z35bPQwu481PoagK1tDebetdE0bOj10evVjpDevd0fJMZSoozg
	 cBleCsemshAWAM9nwaZ1ao6byAcSMlpKN7/iAlzEuJrf7I2sr/ihTJqoCCNv1OE5qL
	 zcDGptNskeBlECwbEM4cq063R46WyAiFEGblq/yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 507/869] dm-bufio: fix non-working memory limit
Date: Sat,  7 Nov 2026 08:53:09 -0500
Message-ID: <20261107134910.783810170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 1190dbeaeaa026a4879e675b8556a150c36a7ced ]

The function evict_old is supposed to loop and evict buffers while the
allocated size is above the threshold. However if it hits one bufio
client that is empty, it stops and doesn't attempt to scan other
clients.

This commit fixes it, so that it skips empty clients and retries up to
dm_bufio_client_count times.

Fixes: 450e8dee51aa ("dm bufio: improve concurrent IO performance")
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-bufio.c | 41 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 59e5d8aa42b71..6d76511953a25 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -2521,6 +2521,13 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	init_waitqueue_head(&c->free_buffer_wait);
 	c->async_write_error = 0;
 
+	/*
+	 * A client with no buffers yet is not holding the oldest buffer in
+	 * the system; leaving this zeroed would claim exactly that and keep
+	 * the client pinned at the front of dm_bufio_all_clients.
+	 */
+	c->oldest_buffer = jiffies;
+
 	c->dm_io = dm_io_client_create();
 	if (IS_ERR(c->dm_io)) {
 		r = PTR_ERR(c->dm_io);
@@ -2755,9 +2762,23 @@ static unsigned long __evict_a_few(unsigned long nr_buffers)
 
 	dm_bufio_unlock(c);
 
-	if (count)
+	if (count) {
 		c->oldest_buffer = oldest_buffer;
-	__insert_client(c);
+		__insert_client(c);
+	} else {
+		/*
+		 * We evicted nothing, so 'oldest_buffer' tells us nothing new
+		 * and the client keeps its old, possibly very stale, value.
+		 * Requeue it at the back rather than by that value, otherwise
+		 * __insert_client() would put it straight back at the front
+		 * and every subsequent call would pop this same client again,
+		 * never reaching any of the others.
+		 *
+		 * This leaves the list slightly out of order, which is fine -
+		 * it is only ever an approximation.
+		 */
+		list_add_tail(&c->client_list, &dm_bufio_all_clients);
+	}
 
 	return count;
 }
@@ -2782,11 +2803,23 @@ static void evict_old(void)
 {
 	unsigned long threshold = dm_bufio_cache_size -
 		dm_bufio_cache_size / DM_BUFIO_LOW_WATERMARK_RATIO;
+	int unproductive = 0;
 
 	mutex_lock(&dm_bufio_clients_lock);
 	while (dm_bufio_current_allocated > threshold) {
-		if (!__evict_a_few(64))
-			break;
+		if (__evict_a_few(64)) {
+			unproductive = 0;
+		} else {
+			/*
+			 * This client had nothing to give.  Try the others
+			 * before giving up: one idle client, or one whose
+			 * buffers are all held, must not stop us evicting
+			 * from everybody else.  Stop once a whole sweep of
+			 * the client list has freed nothing.
+			 */
+			if (++unproductive >= dm_bufio_client_count)
+				break;
+		}
 		cond_resched();
 	}
 	mutex_unlock(&dm_bufio_clients_lock);
-- 
2.53.0



