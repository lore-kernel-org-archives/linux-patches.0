Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098922BD012;
	Wed,  4 Feb 2026 15:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219054; cv=none; b=SJJHBF9xpZNSK0hPNXFoJZGokquBliW1JGUUbv37GMla9Ah8XVXJ2FgCaPT1PcR4DCkaiozSRZtdzFeqaFggHpRpGHVas8W6Wne4DgoixTU4j5UuvjVELKfgIr5rw91TMV9K173b9pgM4xJBB5btiWWSORF8nJ37RYIuf/8vKIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219054; c=relaxed/simple;
	bh=9hPi2L0mhSIE/SLy4Av5LP3QFOG9nohFZi044rmolCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzHrXpFHtK9SMdZKoGYe0W445DEXfK+oaVMYJdGVeulKYNRIBE+vJQDYdqwwHQ3KUWWf0g7/KwXmxJt+ia8rxHVsgKf8NPKMBAlIm2OIO6zJzuN773STnhM0Etst3fCZZSSxItu/VC9/IOLl55iE9I/v8jA6ffrl0GVUQVIFbCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXHEgmj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXHEgmj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A1FC116C6;
	Wed,  4 Feb 2026 15:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219053;
	bh=9hPi2L0mhSIE/SLy4Av5LP3QFOG9nohFZi044rmolCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXHEgmj6jbONryX765V+9aCIaXdyQuDOFtGsLwtX43hKWgdwd/ohGiYg4qZzub/3J
	 rblDDlsVgHsFfrTJ9rGLlQDGVwqyyTDuri1B8kDN8BiY88sDhGVvRFJaaPNf5D7wEn
	 2HfyXkwpTdFQqs56oO3KgJ6NZPDX4mmzwaGEFjJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shida Zhang <zhangshida@kylinos.cn>,
	Coly Li <colyli@fnnas.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 052/122] bcache: fix I/O accounting leak in detached_dev_do_request
Date: Wed,  4 Feb 2026 15:40:34 +0100
Message-ID: <20260204143853.727442698@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



