Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062909;
	b=cyxN7zU0xOlaNgIVQMnQUlw3lJ8ZG7yzwAfQm4/I8IaURI67a2BT9wp3K23e1fJIzDEp
	 FV2d0WYiZJcGI/eIQA9KQ3NgaahgfDWXI+7mPMRc3y2X7rcBCpPHBtaPHParwshomtn4A
	 lYHStPKyFvOO/TGFVLffiW7NH4lWEhZj3/wfsHKqTSh9UgOoOoovATVxeIGayXIg0amdg
	 8mmBJdjojJrhxFbx0XHJlyLmROjE3R/FsWJpctnQwsKrtr4E4rwoJZgzK0AF1mob5r1L2
	 vnCMopbNYn+9N3udRXIEDVZ5NVQt3DGDXDboVIxJaPwmnaoGVXMoUvyBJPvs/xJToyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qGSgKXjEd7dI2jFt9tiM5TmlXKY/gUQ2VOz1weKrIss=;
	b=4XzhKBauBvWaqiFs9jd/+wVLRn5RAXTkTzQV7qf70CKl6h9kdifFBUEt4DbZCLcw2Vf0
	 Fk9Ks1WoN97ME/lMKpYjvpbHtixmuRqDMK4tAL4fPtCtvZ4wWs3u4LsqpaipmkojDS5N7
	 +aX/fbQJXLny3yROnZ4+iWbCGD0uSHfZAGIZXZVpMK5iS3aUuC9IAGtW9j27KouU+3hn0
	 tQUifX7EoPopualZn71CJK8+GKD2o09QbHUSd3WPWeYyLY3PuuUpDey2Vsdjp4wFXIAUB
	 6jMj+NGfSAMrx5Cl+Y8kMiM3Iph8isBojhxoO20YypR01jc9L9gxlyDqu2stY8zfkNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TebewDNy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31AC606A326;
	Sat,  7 Nov 2026 14:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TebewDNy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00F41F0089F;
	Sat,  7 Nov 2026 14:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062908;
	bh=qGSgKXjEd7dI2jFt9tiM5TmlXKY/gUQ2VOz1weKrIss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TebewDNyTR7MvxKsw7FR+xJDv+53eeQ8xqmhxSHKeZKpP97zWKQqpVP3FYkj0NnR0
	 WaXByFYlHnEqbtCP8lGG3CBdXC1t52lrfwoGPVJip0o23Sogj5IZJ6rAYRxJJFoHsG
	 xkafHQnZ+BThHekWYFAmBbsMr5JhGqTl6WoTSung=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Sakai <msakai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 133/869] dm vdo indexer: prevent delta list overflow on load
Date: Sat,  7 Nov 2026 08:46:55 -0500
Message-ID: <20261107134856.954222474@linuxfoundation.org>
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
index 0ac2443f0df36..a42de1af4b693 100644
--- a/drivers/md/dm-vdo/indexer/delta-index.c
+++ b/drivers/md/dm-vdo/indexer/delta-index.c
@@ -803,7 +803,7 @@ static void compute_new_list_offsets(struct delta_zone *delta_zone, u32 growing_
 		(delta_zone->size * BITS_PER_BYTE - delta_lists[tail_guard_index].size);
 }
 
-static void rebalance_lists(struct delta_zone *delta_zone)
+static int rebalance_lists(struct delta_zone *delta_zone)
 {
 	struct delta_list *delta_lists;
 	u32 i;
@@ -814,9 +814,17 @@ static void rebalance_lists(struct delta_zone *delta_zone)
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
@@ -944,8 +952,11 @@ int uds_start_restoring_delta_index(struct delta_index *delta_index,
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



