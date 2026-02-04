Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C111C18859B;
	Wed,  4 Feb 2026 15:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218681; cv=none; b=XbFy3vWwp4x0snEWFWvqWyidUjlF3t3QFmsI0bUaPonaFmoXAZZbUCnC9xGL2elKG0mgjxJSjCpaQv6u1KhzLvCBe463Jlczq1qDCfwVmQtKVCKgHZljOkAdZHpZlIFz96vE0/ezFoXbHZ5v4tyF2d+s2WV+VDTuB2ld342ncKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218681; c=relaxed/simple;
	bh=W+Jw5Q/paeESKLSoTUf6FZRHAoSqvqEGo+m9bln4XqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aB0LqRi3KP47yPHwY8KxbnbJ3f8YRILVIzg1nGAErnObHOu4cuXvugy+CxZuXZpt23reWxmeuqU2i7+jvVEe5bK9tcyxg8LZGS5jnwZGAcErGlQ0RPeURhyNQ0mKozhopcqTzDANrHzayFe6EQXo0bKS1sK30zZPdg16k6GywCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jD5NAota; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jD5NAota"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E220C4CEF7;
	Wed,  4 Feb 2026 15:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218681;
	bh=W+Jw5Q/paeESKLSoTUf6FZRHAoSqvqEGo+m9bln4XqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jD5NAotaBmvIiXzux4aQtMKfQ/HWR+p6mkshoVqqYIwMcjZsN7fhA/gkmJWW4AcS/
	 XnRPab5z+i13TeQr5BCVHuy/cmy2pJffaFk9aX74SSA/+soqeDaQfu26qevPRHd63L
	 I683iZdJ4yZhdadIOecFgwwVlGC8+dUzh5Hh/gCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shida Zhang <zhangshida@kylinos.cn>,
	Coly Li <colyli@fnnas.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 30/87] bcache: fix I/O accounting leak in detached_dev_do_request
Date: Wed,  4 Feb 2026 15:40:28 +0100
Message-ID: <20260204143847.995871393@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shida Zhang <zhangshida@kylinos.cn>

[ Upstream commit 4da7c5c3ec34d839bba6e035c3d05c447a2f9d4f ]

When a bcache device is detached, discard requests are completed
immediately. However, the I/O accounting started in
cached_dev_make_request() is not ended, leading to 100% disk
utilization reports in iostat. Add the missing bio_end_io_acct() call.

Fixes: cafe56359144 ("bcache: A block layer cache")
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
Acked-by: Coly Li <colyli@fnnas.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/request.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index a02aecac05cdf..6cba1180be8aa 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1107,6 +1107,7 @@ static void detached_dev_do_request(struct bcache_device *d,
 
 	if (bio_op(orig_bio) == REQ_OP_DISCARD &&
 	    !bdev_max_discard_sectors(dc->bdev)) {
+		bio_end_io_acct(orig_bio, start_time);
 		bio_endio(orig_bio);
 		return;
 	}
-- 
2.51.0



