Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5AD21B199;
	Mon, 18 Aug 2025 12:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521619; cv=none; b=Jd2RWJOeDZnbi+YmyXdJxqoKdI7UcGQdom5HjmuxCJOH1kXGGdbsAXYbO+7UywGFe2LTg4Vg8NnTY4VhdD5hqgeeY31EkwEEPEZTM47JqHpJH02s1iK1gKq+5TnkVjgAk/UumlB+bC1Hpgc2noP+wNRengCt529Lfsz4ngLFfGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521619; c=relaxed/simple;
	bh=Qr6DUbJcs/sa+k3J8TUY1rF4JHSH8X3XtZlR+HsfcsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eL9X+hTTcRN3mXWaIA9ZWO9CQ0qoJxVjGT9OPKmfh0X/LeVZkwapusN9PLFaPdMr0sA+h6rqzzZ/S92spQhteec0aU1zdeRu8arAqHFC7pseyIILbLbyeulo4cE5JgIMxc6zel12ICFWinmfDdMUfZMVL5wM6WNPSZoiXGeg/oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTGqlnq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTGqlnq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73012C4CEEB;
	Mon, 18 Aug 2025 12:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521618;
	bh=Qr6DUbJcs/sa+k3J8TUY1rF4JHSH8X3XtZlR+HsfcsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTGqlnq2+8Uj844brHtR5GATMRPHdlGVk7YaXIAFSBE8DWZlJ7THsYDEnYRWdq5DL
	 +2CVYlykcoNDBmfinPYoMmKkztTkSmzBWnotASJ4GpK3HHcoM5QzT4VzqAgb/VxL9w
	 ryntnO7CwVRGphwHtOs53MarEaobdOr8SNT2vCQs=
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
Subject: [PATCH 6.12 073/444] dm-stripe: limit chunk_sectors to the stripe size
Date: Mon, 18 Aug 2025 14:41:39 +0200
Message-ID: <20250818124451.695238591@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-stripe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 4112071de0be..c68dc1653cfd 100644
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



