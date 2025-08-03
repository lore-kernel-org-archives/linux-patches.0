Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F181EDA3A;
	Sun,  3 Aug 2025 21:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754255947; cv=none; b=GxzUj4zGb7YbN01NeuEPlg0oLqaDHhZWi8kn2UJtccEsupx7y0l902RXewgikSJ4SWH+9RPIiNCsjpusXUsDcKPNl3z7JMsEHSngso+VeEGitaEQj7KCpg9w+cFhNJNZ4o25INTjntRk5TU3Z073Uz1HMzn59vAeIIsCIuv1x8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754255947; c=relaxed/simple;
	bh=Fkf4wf3fk8d6tqq9k8H3QsuDGvB23tNyp9U7+U50A6w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pmcUaSsug7WKmJncmlfo10HNaM2D7/CM/2c/np8Ls+ulPiidUyPDUixqSLyOxHYzZYIiwWKDyPMmgyURECCTnYe80XjSY6a4uGpUEAK4Ll2onBADRMqSF2UyYEwvN9ptz2OuNhQJqDjT6Wv06oygF2hlVycjECO+SJBZx1brFIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sNkLQj6V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sNkLQj6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A2CC4CEEB;
	Sun,  3 Aug 2025 21:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754255946;
	bh=Fkf4wf3fk8d6tqq9k8H3QsuDGvB23tNyp9U7+U50A6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sNkLQj6VwT9vq2zb3omSo2g3rcxqRjDYRE9AOnvLq3QhQAWqrLso01BccLeNAuGjt
	 mjzvk802b24CCmyAFA6h+xjU5BJcKx9IFvSambzineNOCnLPnZtCYhkNPx41PRUeDT
	 zCtfBmvogif1bYxtrIYdv3mbwsuXL1PFg4rvhnRwzLy6LuBsOudC/vi+MMDYZ8GAWm
	 XZmcff3XUF5+YOK7gzNqIiP1M9BUgIAOheNhxDNJrG58q2Zj5fn906xbm7YA/6U+Gi
	 mD0G7igAHt4SBC/hQ5bHfycRPd1gHvR5rTWv7S2kWTy4j2HrUhbKCOMKWaN+MfJ3KE
	 9HP/NaoX8hH0Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: John Garry <john.g.garry@oracle.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	agk@redhat.com,
	snitzer@kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.15 12/34] dm-stripe: limit chunk_sectors to the stripe size
Date: Sun,  3 Aug 2025 17:18:14 -0400
Message-Id: <20250803211836.3546094-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803211836.3546094-1-sashal@kernel.org>
References: <20250803211836.3546094-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.9
Content-Transfer-Encoding: 8bit

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 5fb9d4341b782a80eefa0dc1664d131ac3c8885d ]

Same as done for raid0, set chunk_sectors limit to appropriately set the
atomic write size limit.

Setting chunk_sectors limit in this way overrides the stacked limit
already calculated based on the bottom device limits. This is ok, as
when any bios are sent to the bottom devices, the block layer will still
respect the bottom device chunk_sectors.

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20250711105258.3135198-6-john.g.garry@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit and the kernel repository context,
here is my assessment:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Bug Fix**: This commit fixes a correctness issue where dm-stripe
   was not properly setting the `chunk_sectors` limit. The commit
   message explains that this is needed to "appropriately set the atomic
   write size limit." Without this fix, atomic writes on dm-stripe
   devices may not work correctly or may have incorrect size limits.


3. **Small and Contained**: The change is minimal - just a single line
   addition:
  ```c
  limits->chunk_sectors = sc->chunk_size;
  ```
  This sets the chunk_sectors field in the io_hints function, which is a
  straightforward fix with minimal risk.

4. **Fixes Regression/Incorrect Behavior**: The block layer commit
   `add194b01e4a` shows that the stacking code now relies on
   `chunk_sectors` instead of `io_min` to determine atomic write limits.
   Without this dm-stripe fix, atomic writes would be incorrectly
   limited or potentially fail on dm-stripe devices because the
   chunk_sectors field would be unset.

5. **No New Features**: This doesn't add new functionality - it simply
   ensures that an existing feature (atomic writes, enabled by commit
   `30b88ed06f80`) works correctly by providing the required
   chunk_sectors information.

6. **Clear Dependencies**: The commit is self-contained and only depends
   on the atomic writes infrastructure already being present
   (DM_TARGET_ATOMIC_WRITES flag), which was added earlier.

The fix addresses a real issue where atomic write operations on dm-
stripe devices would have incorrect size limits because the block layer
stacking code expects chunk_sectors to be set but dm-stripe wasn't
providing this value. This is exactly the type of bug fix that stable
kernels should receive - it's small, fixes incorrect behavior, and has
minimal risk of introducing regressions.

 drivers/md/dm-stripe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index a1b7535c508a..8f61030d3b2d 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -459,6 +459,7 @@ static void stripe_io_hints(struct dm_target *ti,
 	struct stripe_c *sc = ti->private;
 	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
 
+	limits->chunk_sectors = sc->chunk_size;
 	limits->io_min = chunk_size;
 	limits->io_opt = chunk_size * sc->stripes;
 }
-- 
2.39.5

