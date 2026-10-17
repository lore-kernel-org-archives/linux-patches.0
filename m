Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB74D3BD64A;
	Sat, 17 Oct 2026 17:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258163; cv=none; b=UEwnUMwXVinYAapHyfrfNOJVGcdx5xgobdvk5oqGoakGDDnpoxtlfsARCbgAKVI7YC2E+WRrHdTmTGedJBCVzjkGCZxBslZPImfmH9hRt0O+Egnt70MCPCO8U+JPifNKAW4thnENR+EPxrG5Eh0p9T+1d750r4cWvXHvfD0bpe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258163; c=relaxed/simple;
	bh=/U64AD+bNhlRAW4apF2p3gvKd05v+ZzWN6lLuBc71ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTIPaJ7yri0sDa9jQbx8DB0Ra3XoG6l/kWhnlN8+g5Nm4t1UAW/MmyHIADgikzSKE0qKQmBz+P66xjii1ccLNnX/7yGp5JlLH8IxrzdDoG3QCy87AJFjrVZGjG4zHo1Hyksp+nrDWRQAI9DaSktvLrFffuEuUCIYKqhe6KJTbJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nP7Jq+Sg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nP7Jq+Sg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA301F000C4;
	Sat, 17 Oct 2026 17:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258162;
	bh=bk8FAqC8Ia9YXWSC2/HNGhkCqgX0kNs9VVCbRiYEJZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nP7Jq+Sg0X8cMM/ZQ5E8Em0xXtlxxqEJpgQ1e2zo6LNol8+BlKYeg5AaGX8wV/rhy
	 UNTKgO0bKQ/VF8Y9yOLbIu3z9ZfP4Swf9BUVuMoXMybxe8jhZJaO5XU2ivwdBvhRsi
	 ExmMCEvapFsvz6l2GzxKUko/Btsz5WUrAK6awsX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0791/1674] dm-stripe: limit chunk_sectors to the stripe size
Date: Sat, 17 Oct 2026 17:51:03 +0200
Message-ID: <20261017160451.409318774@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Stable-dep-of: 1071d560afb4 ("dm-stripe: fix a possible integer overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-stripe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 67026e1cbc857..aad50e9fe9958 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -458,6 +458,7 @@ static void stripe_io_hints(struct dm_target *ti,
 	struct stripe_c *sc = ti->private;
 	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
 
+	limits->chunk_sectors = sc->chunk_size;
 	limits->io_min = chunk_size;
 	limits->io_opt = chunk_size * sc->stripes;
 }
-- 
2.53.0



