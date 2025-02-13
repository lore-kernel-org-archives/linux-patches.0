Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EA43D97A;
	Thu, 13 Feb 2025 15:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460038; cv=none; b=tGJhwhYW2amxiBkfAOsO7xnPy8g+jRGzvoHbwcP4FxDLDUwOAkbfBq/7BJg61H7EWZzTwW/dJGYAVycz7Z0pPtuISjvtHS2KhfKtWIc+QlGTWr9ZUOm1kJs0ktBV6fLyqeoZ8zi5IJsaR6NlWWJJgr5G/40Z39GKmiGCzPMvUDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460038; c=relaxed/simple;
	bh=SkHi8kfp84Eyw9ShcPLSDalq4FisM0XGC1ehA3jkg8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyWubRqj2Yn/rruvJgayetAfLTX44fG0QGcjFW6eJqG7oWOZFGeucA9agyR4xBG+Lz1B1LpOxPJoXdM6hHUcNl7CA2nfUko2m3VtoIAe/h5QuiSJtQbS6IGUXECPdccKFg1+mpWUtgS2Q8cjSRy4vjg+S2qLJz/xWpR6v2mwjZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnBZeMgJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnBZeMgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E004C4CED1;
	Thu, 13 Feb 2025 15:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460038;
	bh=SkHi8kfp84Eyw9ShcPLSDalq4FisM0XGC1ehA3jkg8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnBZeMgJ7ofuchCSDyBBnXv2HitY9cxRpCMrPSev5p80GocuG51r0APbh+/yCi9k3
	 g+CjEy9NgSwoov+v4wv4VwXAdErWCWiJ5nPOxjm9AZ0j5WNrKQMvKKhIuf7B+pGrO4
	 LnFoBD65bWlTQzT6fSapXbSs4Lo6jiQQvMoO544c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Coly Li <colyli@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.13 439/443] md: Fix linear_set_limits()
Date: Thu, 13 Feb 2025 15:30:04 +0100
Message-ID: <20250213142457.555336046@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit a572593ac80e51eb69ecede7e614289fcccdbf8d upstream.

queue_limits_cancel_update() must only be called if
queue_limits_start_update() is called first. Remove the
queue_limits_cancel_update() call from linear_set_limits() because
there is no corresponding queue_limits_start_update() call.

This bug was discovered by annotating all mutex operations with clang
thread-safety attributes and by building the kernel with clang and
-Wthread-safety.

Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Coly Li <colyli@kernel.org>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Fixes: 127186cfb184 ("md: reintroduce md-linear")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250129225636.2667932-1-bvanassche@acm.org
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md-linear.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -76,10 +76,8 @@ static int linear_set_limits(struct mdde
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
 	lim.io_min = mddev->chunk_sectors << 9;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
-	if (err) {
-		queue_limits_cancel_update(mddev->gendisk->queue);
+	if (err)
 		return err;
-	}
 
 	return queue_limits_set(mddev->gendisk->queue, &lim);
 }


