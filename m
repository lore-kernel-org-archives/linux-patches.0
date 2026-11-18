Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038403;
	b=TN/2ivZAMs+378qSBzJ9Dh9xSwh4skB5/2PsLPNJI+IfZvMU8SzsKcTRSph41U5w0HXH
	 40SLGx6Us0O86Sa2OOtMNEKk++cA+b2UWde16O0ML7HcvpQMCVL5kGBurDq2nPn/8JGWN
	 Y5kSm1qUZFzvGDfUFJ3yyv5LEQgEeRzrG7KVWUFOXVQp/hil19jRiDJev7M9Jcw2/WBo8
	 QwCO4BD4DJzEiuh4saHUTEbA1b7PXR3luJA/QmSmyugb0VSxo7YjFUt2vomAX2n+llIMU
	 k6brBHXH0OG1uakFS53zSnQzOBEcVYBDWtCEdSy1XEjdIJQHWOFAAC7ozVJpcspHwfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JF4Wy0uSA4XvxkUGqagoW/mg/Vu+U9iasVgziIFc6Hk=;
	b=4RjuxghJjQaSJw58fhWE87mWozmkFk2tKdDj72rcB8hASK4CTfbuSCoQDvyAXF0bwkhL
	 aMGANjXCZHWBX/4/xuf+CP/jdy0jlBwcRH+nVE4gAGkwF4niCNszP+IsRNQIFuoj2PRBJ
	 8XRlmbqmg5H8mcD7K1u5gT08tqcPi2Sv1l4sHiEJVPalOkPVXacfK0J7Hh6OLJSU+KoIQ
	 MOfAdBkMVK3BCkRYYfKW/pAbw0PjDJC4SSAH4uwPY5RmmzdypprrEo8AmYyaEtQKje9Km
	 XeZUlfbk0T7C18ys8qSdVJA/c6LhaDeQFKRFw5i7kg1bJZyIkZ6KuK35MD2TeYzdNFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f1w4Vv7s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD259606A31C;
	Wed, 18 Nov 2026 21:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f1w4Vv7s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238E81F000C5;
	Wed, 18 Nov 2026 21:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038403;
	bh=JF4Wy0uSA4XvxkUGqagoW/mg/Vu+U9iasVgziIFc6Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f1w4Vv7s/qziIiy1L1xJwUV4lJjk1aG2vZ+QI/FR5B/OBM79ao/4vFFFIB4vY0FL0
	 KfmVF78DfJ/5B1UMCOjaj2uyqvgED9hl8skQEY4aVB57AEDUCzA9jN69Q48X/NKg0Y
	 n5owU/roaX2VuFstRBkwMuhrPkf5qFb/Shq3PiEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1731/3318] dm-bufio: fix non-working memory limit
Date: Wed, 18 Nov 2026 15:39:13 +0100
Message-ID: <20261118150413.796792110@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted the oldest_buffer assignment to use params.last_accessed. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-bufio.c | 41 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 8f121a7e87bca..b8addbc3a3430 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -2499,6 +2499,13 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
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
@@ -2828,9 +2835,23 @@ static unsigned long __evict_a_few(unsigned long nr_buffers)
 	count = __evict_many(c, &params, LIST_CLEAN, nr_buffers);
 	dm_bufio_unlock(c);
 
-	if (count)
+	if (count) {
 		c->oldest_buffer = params.last_accessed;
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
@@ -2855,11 +2876,23 @@ static void evict_old(void)
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



