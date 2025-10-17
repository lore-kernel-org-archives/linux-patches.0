Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B4F330B06;
	Fri, 17 Oct 2025 15:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715895; cv=none; b=JTVnS52nS5O+2uVWjeFo5LfvzI/dFnUHJ9SJYsuHtaQnhN4fhORzaNIo5/dRh4CG9WUpdLvLg0sfRZt8s6GgKC39YS9GDbEJhlRC/hSL0r2ikPlcRjt69/nS82DZh4efWnezOY9+5CIqzbxE5FpORHymRExy0RMqTn7D9oH15fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715895; c=relaxed/simple;
	bh=4b7C8TJm69FA7uyvOZ4O6YG59VqytHs4pfKI+GvYfW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USj2ov6bCQFJ/YXXwk1Y2DZyDd8+gVKWcaWeJMwg1tdj0Solw/tVgv6U99GuZLz4Sc3g47AuHmSrv48jSMKTmD3lSLcEpvFFN5fDeGKBlV2TruF9nf3/iT7lmjA98l2nxPNGySK1h/v1gLLYZsw9kJJ4G4UHn1BJVib13jvrXCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZzP9Wsqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZzP9Wsqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E303FC113D0;
	Fri, 17 Oct 2025 15:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715895;
	bh=4b7C8TJm69FA7uyvOZ4O6YG59VqytHs4pfKI+GvYfW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZzP9WsqmoKExa+9MMEMlca2LwnjKztZI7Mditdhbdh42cQyueJyfKnlJQvwffNoLT
	 IHHLhutQMm9aGZEKSGufF17zNurwYpmCWwoOeUCAaV1O8i1yyIN64ZmfiuRiQgmdEC
	 TIPUZSavms+vqqipGw36BmGd9rdGnW3kB2WlpJYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.17 344/371] ext4: fix an off-by-one issue during moving extents
Date: Fri, 17 Oct 2025 16:55:19 +0200
Message-ID: <20251017145214.526629844@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

commit 12e803c8827d049ae8f2c743ef66ab87ae898375 upstream.

During the movement of a written extent, mext_page_mkuptodate() is
called to read data in the range [from, to) into the page cache and to
update the corresponding buffers. Therefore, we should not wait on any
buffer whose start offset is >= 'to'. Otherwise, it will return -EIO and
fail the extents movement.

 $ for i in `seq 3 -1 0`; \
   do xfs_io -fs -c "pwrite -b 1024 $((i * 1024)) 1024" /mnt/foo; \
   done
 $ umount /mnt && mount /dev/pmem1s /mnt  # drop cache
 $ e4defrag /mnt/foo
   e4defrag 1.47.0 (5-Feb-2023)
   ext4 defragmentation for /mnt/foo
   [1/1]/mnt/foo:    0%    [ NG ]
   Success:                       [0/1]

Cc: stable@kernel.org
Fixes: a40759fb16ae ("ext4: remove array of buffer_heads from mext_page_mkuptodate()")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-ID: <20250912105841.1886799-1-yi.zhang@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/move_extent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -225,7 +225,7 @@ static int mext_page_mkuptodate(struct f
 	do {
 		if (bh_offset(bh) + blocksize <= from)
 			continue;
-		if (bh_offset(bh) > to)
+		if (bh_offset(bh) >= to)
 			break;
 		wait_on_buffer(bh);
 		if (buffer_uptodate(bh))


