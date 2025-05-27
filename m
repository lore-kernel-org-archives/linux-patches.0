Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB5127F16A;
	Tue, 27 May 2025 17:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365997; cv=none; b=dSTK/B8gNQzhtKfc5J0Xkgywz8kOFSjEzUr3aL56HRh8UYXHSj0X3o9qd0gdiv4jzZ0QbKuARnM1ucPuwcdD2apXxT+hkLPXgaDiMflC3wlIBMxrK7EU0DI1QmrCm8qOVwXGaZlwmYy61JoPTHXUXSiKi6Y9eqCO/GIxddxhr9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365997; c=relaxed/simple;
	bh=QmZ9ZqS8NxDjqu8qkc4818NX7OLru3xefzTVhp1pqTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foa5Z9k1eG9whKmGNR5uAmtsk5iIHSh+0X0fdstUVKejWavgcNI0NOf+LeK5OnS0YGsAHoAJrpCtVsx5wTMA55g8TjgX86ZiRTwuTZfWqRWjhxMp2ZVoSDIEmTD9eJe5dZPBXWXSMfnUUO1SldKf/QFcE9+cf4ogYd3e02L6rU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kRCjv9jW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRCjv9jW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4A6C4CEE9;
	Tue, 27 May 2025 17:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365997;
	bh=QmZ9ZqS8NxDjqu8qkc4818NX7OLru3xefzTVhp1pqTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRCjv9jWXsIgVZcnuMIsMfNTZ/BIy1ius3bfwqI/JiDCngaawTIo33YSaxZIAVm+d
	 4HZFaFxz9/GIWOPz6CIY5weK3STw+KlVe47/cKHtBZBGz7pY0ui7G+8WKdE9Lc3wde
	 vqvz5BKT8bfH12xV34UmKFOLkcNrBS3b7ltqH1Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hesse <mail@eworm.de>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 558/626] loop: dont require ->write_iter for writable files in loop_configure
Date: Tue, 27 May 2025 18:27:31 +0200
Message-ID: <20250527162507.642320643@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 355341e4359b2d5edf0ed5e117f7e9e7a0a5dac0 ]

Block devices can be opened read-write even if they can't be written to
for historic reasons.  Remove the check requiring file->f_op->write_iter
when the block devices was opened in loop_configure. The call to
loop_check_backing_file just below ensures the ->write_iter is present
for backing files opened for writing, which is the only check that is
actually needed.

Fixes: f5c84eff634b ("loop: Add sanity check for read/write_iter")
Reported-by: Christian Hesse <mail@eworm.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250520135420.1177312-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index fa9c77b8f4d23..0843d229b0f76 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -969,9 +969,6 @@ static int loop_configure(struct loop_device *lo, blk_mode_t mode,
 	if (!file)
 		return -EBADF;
 
-	if ((mode & BLK_OPEN_WRITE) && !file->f_op->write_iter)
-		return -EINVAL;
-
 	error = loop_check_backing_file(file);
 	if (error)
 		return error;
-- 
2.39.5



