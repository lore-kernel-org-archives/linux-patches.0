Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9654BC002;
	Sat, 28 Feb 2026 17:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301353; cv=none; b=O9+JWgxqFHNl3AvUO5+out2vJO0qArWBpqBbfdlLsc0pRA6dG321min72fpAfNQNM4sfQ6ZOrjnOH9GRt/UK88lz/ppWdh53BJ3GvxDmO0V5EEin1MVvX+ZSASYqj7XFyaqG4XcSVaEYq4eFanViZm7uF7CLD7o+tFJGXKiaTU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301353; c=relaxed/simple;
	bh=g+lQ6eEmCsqoIVmNzQsNBTXxuJYWt6+/ZurWb0pCyQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lu8TGggZymnPPo2G8gMXkV4PMMXiYcoycuGfVYLyAa0QfXrywSegDCLbl1pX4ZxpHO57OG5dBwC1y1tAmhs8J1SYGtLWVGeYUG+Fus0GGdp6Tq8F4bwZKo2VfgdqTP+v6rc4HOVD5QIJ0VcBLPh7Bl9ElW+a94YoAty3Cx/25hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nWE/uZhW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nWE/uZhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1964C19423;
	Sat, 28 Feb 2026 17:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301353;
	bh=g+lQ6eEmCsqoIVmNzQsNBTXxuJYWt6+/ZurWb0pCyQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nWE/uZhWknhT1NLqF2At+TLVfc3nUZVQrveYJlZkxKLcKnLl2uYbEyI8pamtVf5cX
	 t6tErP5TNnD1qLG2Q6wQ0IzzYwM/6paHyB29ahzDuQhMThPfamBdFvKsHZJmcWg9Rd
	 v2VVe40OvZeW6t4IBnKKmKATfDu9u404gwDoj22As0TBkR7q4H38ek1LH/fQ6dYSrO
	 /BuC2gRCIeuTrehI2IugbJAIlCpNHTsOyTp+HpY6WwQ3xBOLRJ4tBrKpTr9kZIY9Lc
	 TppaC4CMv7kp6eUoEDIXlveWrJ/N4m399puwp+QGzfFRD2tM5jDxU3OMR0jrDtyNBQ
	 ogoNkXi9CD+hQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Michael Liang <mliang@purestorage.com>,
	Mohamed Khalfella <mkhalfella@purestorage.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 541/752] dm: clear cloned request bio pointer when last clone bio completes
Date: Sat, 28 Feb 2026 12:44:12 -0500
Message-ID: <20260228174750.1542406-541-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Michael Liang <mliang@purestorage.com>

[ Upstream commit fb8a6c18fb9a6561f7a15b58b272442b77a242dd ]

Stale rq->bio values have been observed to cause double-initialization of
cloned bios in request-based device-mapper targets, leading to
use-after-free and double-free scenarios.

One such case occurs when using dm-multipath on top of a PCIe NVMe
namespace, where cloned request bios are freed during
blk_complete_request(), but rq->bio is left intact. Subsequent clone
teardown then attempts to free the same bios again via
blk_rq_unprep_clone().

The resulting double-free path looks like:

  nvme_pci_complete_batch()
    nvme_complete_batch()
      blk_mq_end_request_batch()
        blk_complete_request()        // called on a DM clone request
          bio_endio()                 // first free of all clone bios
          ...
        rq->end_io()                  // end_clone_request()
          dm_complete_request(tio->orig)
            dm_softirq_done()
              dm_done()
                dm_end_request()
                  blk_rq_unprep_clone()  // second free of clone bios

Fix this by clearing the clone request's bio pointer when the last cloned
bio completes, ensuring that later teardown paths do not attempt to free
already-released bios.

Signed-off-by: Michael Liang <mliang@purestorage.com>
Reviewed-by: Mohamed Khalfella <mkhalfella@purestorage.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-rq.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 5e08546696145..923252fb57aec 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -109,14 +109,21 @@ static void end_clone_bio(struct bio *clone)
 	 */
 	tio->completed += nr_bytes;
 
+	if (!is_last)
+		return;
+	/*
+	 * At this moment we know this is the last bio of the cloned request,
+	 * and all cloned bios have been released, so reset the clone request's
+	 * bio pointer to avoid double free.
+	 */
+	tio->clone->bio = NULL;
+ exit:
 	/*
 	 * Update the original request.
 	 * Do not use blk_mq_end_request() here, because it may complete
 	 * the original request before the clone, and break the ordering.
 	 */
-	if (is_last)
- exit:
-		blk_update_request(tio->orig, BLK_STS_OK, tio->completed);
+	blk_update_request(tio->orig, BLK_STS_OK, tio->completed);
 }
 
 static struct dm_rq_target_io *tio_from_request(struct request *rq)
-- 
2.51.0

