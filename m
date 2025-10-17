Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D472F12D0;
	Fri, 17 Oct 2025 15:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714643; cv=none; b=T30c/MCgoz+NkEkIWcQHLfG0rPb6GdbC/VHqaU23luGfkfnmcUGPxFx3Wn5AKRySKUf8gcpQPDSd1nDbiC9y+q7FBXgfQGRl6XSVzmY8YJBmKShUm2jcxPl6f5AGv+FTRhKPcX/YLS/Wm9gkI4YBH4+3Xe0IKtnWzNbmOFxf9oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714643; c=relaxed/simple;
	bh=QOovSz7EcVuLPXOkZdVqM0SoM8Du7NscYI2cBk4CEVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ub+nigTrE+GdHYHhBhH6GIMqS4FB6qJrM0Hc5Enc14Qvq3fyOgsZgqFcYXYrecI250Z3cQTFnPmDgvxYtKHxWM28L/ie50M9bR95EzsFpKaX2qUJlIAc0jpEyM3rElPL/RePltN7lNjCzq+GEXBS0NEKg8EkqPkw6opMF1DO9YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/PGo1Gf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/PGo1Gf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48816C4CEE7;
	Fri, 17 Oct 2025 15:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714643;
	bh=QOovSz7EcVuLPXOkZdVqM0SoM8Du7NscYI2cBk4CEVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/PGo1GfrA7sxbwFYvKjuceIirIuh5zJdCvrETbNRJPXJOl//4ycMVbtSPXbqGKQ6
	 A5UjvDzr7QZPhmzjvVCHE+EfF8/QIpie6I4JTFDwwPUJczvFrBHAm/LnOoQ5oghS0a
	 eAmpsMQkS3/qyrHnkaOJzrLAWp7kiZdk8ni6uDNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.12 217/277] ext4: fix an off-by-one issue during moving extents
Date: Fri, 17 Oct 2025 16:53:44 +0200
Message-ID: <20251017145155.053021357@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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


