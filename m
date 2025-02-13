Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFC126B086;
	Thu, 13 Feb 2025 14:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458485; cv=none; b=RvMJmvRO0urdLQkwnJM6o0JBhyN4D4HIL3z4ioEKfl1Ezlwyfu9bfjBKt3NgxrRGJLKetsoXwV2fglIOSfT0HQq9gRgaCcIFqQJ30uefyeeDYVz9BXqpiKv9xKOGrXLghOcUjZ97W6G2Y4/NtotI/wSwsA6S8DFx6F3Eemzx4sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458485; c=relaxed/simple;
	bh=g+eBZ7QnxjRrnlZkG+NRe9s4dns3nQSJKWRmwrMUtZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKFyKeSAs/51jO5Cx7FbsygbdPyAXBvotqWArsho2havUSP828jIvcxsrww4YviG805TfH7OgL9Z39KJ373Zxfgro9vZBfMuVzLHIgtlgZk8ZFgdVIT9vaqTDMKLs/+lr4TEIGjBmu7NdaH4OTi/siRpUBRBwpdyerIqzz24Yc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=As+W+i6T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="As+W+i6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21A8C4CED1;
	Thu, 13 Feb 2025 14:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458485;
	bh=g+eBZ7QnxjRrnlZkG+NRe9s4dns3nQSJKWRmwrMUtZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=As+W+i6Tr2vCYC208C5LiQojTCDnrupQml2T8fb25jPod2vm4bk28+K2eW6WBmt9a
	 2FFslZPkfHiBQgXdt1K3jREM62uEAwUh3LiAcv0OrfyEy2NwFAUUXQf7DrI6tk2riE
	 KOXRMmKJiS9D2NIVGDrhBew3ETdskADCpvxRSduE=
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
Subject: [PATCH 6.12 414/422] md: Fix linear_set_limits()
Date: Thu, 13 Feb 2025 15:29:23 +0100
Message-ID: <20250213142452.540516001@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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


