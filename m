Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063974;
	b=5N0Kh+VK8A9LceX/7Yvpo8VV3mTchGEIwsQvsD8E99K3IcUDTm8+wntVuVg4/Hbc7hoK
	 kmM8jI44k42szfovcC7SUggErLNP29r0bHOzzn+qs/rjUjMqEACCVLTi0jI7aLA0bdGGV
	 A2GziYKhjewoLHnLN8ZOqA/Yg2P0Csnu9SCC9IfhhZ0SbVwFdnCNKBtynnGY67XMMz8z8
	 pxFkVkZC44n0amJL+itJ87cJmCyBR3VZM1BVc2c9NY9hc1s8krKid/mzTE/WlgIt1iIOl
	 XQEltkJfXmMVx3k4fz4HC457WG8EAHA1u0gL6XWMyhoF5iVvV8bVOu4JyDzoEF/f6+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9NTNP9nZzueEhuE1bZNkusVXEa6xHxCQLir19na4Vpk=;
	b=n6fwym9zm/AtbwZ822Km4coDEhUjYyrbaRUBibdZyqJHMDiZgQdkdBlOvIu1g1kw/6os
	 oatAPZJq+TVCkPhnYinaPimAH/zelmtwPbiij1wrrO9QcB6LDmGE2x6cT/fc0wfn1dWwb
	 LyMKhGIKW2P3i66iUGYGZxmgPlnCWQGXm/1zVCDAhK7urGmKrUUx47Xn+7E7kXf+3sVWj
	 25/SZkKpOUJjmL9ueUuod24G3LwltB7/DQkEa+v/nBVjTjONcWu+E9mt9IPDsjBcINQ+5
	 EHrF0qCCkFAVO15Np7rymAllLSGxacux2ksms7KtT/RtKV4wY/OuswdSr2IsPW2wOTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lWemEOMO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBE2608362B;
	Sat,  7 Nov 2026 15:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lWemEOMO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A54A1F008A4;
	Sat,  7 Nov 2026 15:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063973;
	bh=9NTNP9nZzueEhuE1bZNkusVXEa6xHxCQLir19na4Vpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lWemEOMOAw8ALBmTiSTf9j9sq1VVSJV0tULz0bgGLBh9tZQFfRUENyZ+3szZavwkh
	 nZ7kZzaJerDBpubyMW08HukPi3t4WmxYwk6aaJXrb93yJAVlYGIZQ4ZkbLPaRoWOTc
	 CDfL+cCjAzQ9wy5TfgoCMPtZf25FiyTN1+f/KRms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Sakai <msakai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0158/1257] dm vdo indexer: prevent delta list overflow on load
Date: Sat,  7 Nov 2026 08:40:54 -0500
Message-ID: <20261107134943.687601425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Sakai <msakai@redhat.com>

[ Upstream commit 936293c9f3f4f2a0d1b80df9332e96c552ac3b37 ]

Check for corrupted delta lists sizes that overflow the
memory available for the delta_lists. An overflow can
cause the delta list data to be written outside the
reserved delta memory space.

Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-vdo/indexer/delta-index.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/delta-index.c b/drivers/md/dm-vdo/indexer/delta-index.c
index b288749067dee..257612b81a9d9 100644
--- a/drivers/md/dm-vdo/indexer/delta-index.c
+++ b/drivers/md/dm-vdo/indexer/delta-index.c
@@ -800,7 +800,7 @@ static void compute_new_list_offsets(struct delta_zone *delta_zone, u32 growing_
 		(delta_zone->size * BITS_PER_BYTE - delta_lists[tail_guard_index].size);
 }
 
-static void rebalance_lists(struct delta_zone *delta_zone)
+static int rebalance_lists(struct delta_zone *delta_zone)
 {
 	struct delta_list *delta_lists;
 	u32 i;
@@ -811,9 +811,17 @@ static void rebalance_lists(struct delta_zone *delta_zone)
 	for (i = 0; i <= delta_zone->list_count + 1; i++)
 		used_space += get_delta_list_byte_size(&delta_lists[i]);
 
+	if (delta_zone->size < used_space) {
+		return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
+						"delta zone lists overflow zone size %zu",
+						delta_zone->size);
+	}
+
 	compute_new_list_offsets(delta_zone, 0, 0, used_space);
 	for (i = 1; i <= delta_zone->list_count + 1; i++)
 		delta_lists[i].start = delta_zone->new_offsets[i];
+
+	return UDS_SUCCESS;
 }
 
 /* Start restoring a delta index from multiple input streams. */
@@ -941,8 +949,11 @@ int uds_start_restoring_delta_index(struct delta_index *delta_index,
 	}
 
 	/* Prepare each zone to start receiving the delta list data. */
-	for (z = 0; z < delta_index->zone_count; z++)
-		rebalance_lists(&delta_index->delta_zones[z]);
+	for (z = 0; z < delta_index->zone_count; z++) {
+		result = rebalance_lists(&delta_index->delta_zones[z]);
+		if (result != UDS_SUCCESS)
+			return result;
+	}
 
 	return UDS_SUCCESS;
 }
-- 
2.53.0



