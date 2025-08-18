Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5791335BC1;
	Mon, 18 Aug 2025 13:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525015; cv=none; b=tnRBQhaf6sxGNrFllF16cI9QR6mVBsCDI0hBaQO41+eIuPWZ1isdQtOzDxPQm/+nUOH+Dnjo8YXBA9MBPxej2VXC4j38EGLvsYQvdLSO30jNYlMTZsGEHY/16H6wLzL7FRb8O0rBi7mEZb3I2QhNGVT5llCGAAWpmHbNxeWoA9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525015; c=relaxed/simple;
	bh=yRTT4jR2ZNnsB2h5yrETfw7me3LaomgCBMYBAYBp9No=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdqL35aK/zXtg9+1JaaNgaNdrPmYkBzQv1Uoai26CN0sCSYOnnWFybU9v5XFInhpmlXj61inx+Ib0hlsEcdPd/8Lyg1NT/RTCLqQORLQslgJ2OdDG17hUqh2L2uCay7aKySfVzzqwVi0sTK6OwvVgWZY9pkGbhM7On9ELjvxfKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xtzhkUEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xtzhkUEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6885AC4CEF1;
	Mon, 18 Aug 2025 13:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525014;
	bh=yRTT4jR2ZNnsB2h5yrETfw7me3LaomgCBMYBAYBp9No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xtzhkUEjeR/erdlodjYmM++U0BYmkcDF+IgtahiV64suEQ4W7damZhcGWWTWw6tb0
	 VYyQW9aAMPKoXn2lprefESZ7Ttlskqb0uDJUOUjppNC77qj8jNPG+PCUIRvo20IRwd
	 x/EEkJXaqWRmCZv28gM6ON5a2yFRJtuH5xUb+EqY=
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
Subject: [PATCH 6.16 101/570] dm-stripe: limit chunk_sectors to the stripe size
Date: Mon, 18 Aug 2025 14:41:28 +0200
Message-ID: <20250818124509.702782717@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index a7dc04bd55e5..5bbbdf8fc1bd 100644
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
2.39.5



