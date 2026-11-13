Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591474;
	b=lcUhL5vSNPZkb2ZwfCCTIX3y4WRACe/KpKF2PKKRkoMwKwc5SJUWr4cY+z+BQkRQqOPa
	 2243bqyuxFs7ftz3Dpqc4loCVxm7Cm0ss/fAM5HbRZD2IYKpo2VvmeagcHa1gctKtv4Bc
	 dOUVfs/LpXaeA/d4gwZ1pRidiXa3bpWVJ/G82TKZvZ3iIDjgO5RUzpS6K0XLl3OTgg6Ii
	 I4Jtz+eI66mJJ6OF4I/AupMqNvoDyis4gTO3n6Aiy9kA8G9lGhR5/rmZdEJ59XTRoquDo
	 YAC9isc9zdH5zGKAd4ghDYvJ9pSe8k5q9xKWzkAP0NZykEHuOt4RtafHgf05NY2Iwjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591474;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HUevjJUY8H4MU+15F7oaLtNtHT1ObI2heW4I8UtV5SI=;
	b=shUo/gJMPqf/o+4EXyi0leMML2KXO88u6O6cCD3e2hBtp2Ga/8uq5FVHpdSzOkcN91tj
	 cSD+ZggZNgbhJSwTulsfeS0Nip/Gq4sU0Gtf5H2s6uPrgkqXagChE2lOrFIz54TOPgcHA
	 DMJQRaSSfRgHtCMggRMlx4v72gWFi+fHQc8BQU9P5Cx7uZxs9N6eNYS9V0yM4RP3Gdp12
	 4vQe9wU2HQfSB1Mj03zQzXmwSUd5CqTuLnOf6AXLc6bWN1XqMgXRGGBs0dVr9/fyIAnMA
	 bg9ZucK8kLrfYtrTaa11/Psf8WWh3+4xQNzcwEWYSZp6GsLyJlb0vpkURoEnLk/UdLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EP0pjnSb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB00607D2DB;
	Fri, 13 Nov 2026 17:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EP0pjnSb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377CD1F000C4;
	Fri, 13 Nov 2026 17:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591474;
	bh=HUevjJUY8H4MU+15F7oaLtNtHT1ObI2heW4I8UtV5SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EP0pjnSb9D05bNJJvZhSOP4OIGCxuo8GQxcFp7G2Lo2BQnYYSJILU1Ek0u7zCjfoE
	 FwCVMe8OR3wQovfySIqsSVPrLgj5aXmPeADTjw4Q2ngT9/2FXGI0c8/6eYKT0eP/NP
	 Z4WtmXtdGAYl+8FXF8pczX0PxbVl/b4/+XLBqdnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 556/670] dm-bufio: fix non-working memory limit
Date: Fri, 13 Nov 2026 10:52:00 -0500
Message-ID: <20261113153830.726420762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Retained params.last_accessed in place of the upstream local oldest_buffer variable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-bufio.c | 41 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 601c3e3fe56bb..d2a4fc35c8380 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -2526,6 +2526,13 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
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
@@ -2861,9 +2868,23 @@ static unsigned long __evict_a_few(unsigned long nr_buffers)
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
@@ -2888,11 +2909,23 @@ static void evict_old(void)
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



