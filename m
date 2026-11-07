Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062981;
	b=u4cw1o35AD8YzDHl8ZTxo98HjN+T7ZmFCruMFxKflZ+aVhSV7fna/iRAX/nPFEW7xUJU
	 hPmhwIFSlJkXjraeTS0f7Yez5msvvW82f+M7zz8wKDPnlYIL3VCe3QG0+VmOoqGfhPuRP
	 Ratv4fpCxQhJisgimBRO7JixHyXfI7x+GpViEdxVMtVMlPzfi/LpQK1ZUEaGYjXveFyqO
	 qlc6CvadqrzbtzrXGyqNJ9uwktGBut2c89nFXltRkigLWguAHJYOuzepHbVYS1e4NCwzD
	 qwYQFKJX81o2FYHlpid+mwpv1foc/HN5phvZtYO4n44tJ7n0zPyFe99QWQ8AiZhROjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C2UpDKZT5Ay3wcZ45tSDhQfKlvMwnrZFBRzimSYaX5A=;
	b=mn6tkVmZ90T/LQPq8XGkmUlE5Ngb2gAUdjOr4BA6er1xg0AktvF/rUoMW8793Gr7Vb0a
	 S70XgDx4tbuKOHg0oob6nN8nVxkxgc9E9IBYU/zyB+aJKxlBMQRxRS1EWXK2DAjcrGpfG
	 ny4XklB0b1mHfWREgJOGQ4nrkya3QDosCRjOivXCEO7O8rmdWgxQKTrR7uTC/Jm5vYFO8
	 3F3U+l6h4imVRpkB3ASksVQnDylL06h1x7LI1NVX4SegHqp546llg197Wjv7O7L/CPoaD
	 uhaDIby5rXTNUZLBbdh34wPSxNKJG4xYK/JgdK+jgZXLgU+pMepVa9YXIjvGZ+JiEcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zyGzAWm7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9C6606A32C;
	Sat,  7 Nov 2026 14:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zyGzAWm7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BF41F0089F;
	Sat,  7 Nov 2026 14:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062980;
	bh=C2UpDKZT5Ay3wcZ45tSDhQfKlvMwnrZFBRzimSYaX5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zyGzAWm7OjkILqW3SdbZ66JlIXYafo4ud3gOt7+Fabsa8mIfVp3tdr5s8diqooQ0i
	 VX0w9UOOZ03x2TVrVgxRMAQK0Htn3F+mHH+ncbiexuQ56mzfeYEjtyjRW9nDZ9HiiO
	 XiRaBVH8CAoaWjdQES2XGpL/wmBte0H9sGqQecEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 241/869] fuse: dont drop destination page cache on a zero byte copy reply
Date: Sat,  7 Nov 2026 08:48:43 -0500
Message-ID: <20261107134859.990797960@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit f7585e1ce3418ec282485854b3d8d31c6a961e37 ]

__fuse_copy_file_range() clears the destination page cache after the
server replies:

	truncate_inode_pages_range(inode_out->i_mapping,
				   ALIGN_DOWN(pos_out, PAGE_SIZE),
				   ALIGN(pos_out + bytes_copied, PAGE_SIZE) - 1);

A server may legitimately reply that it copied nothing, eg if the source
file turns out to be shorter than the size the kernel has cached for it.

If pos_out is 0 as well, the end of the range is ALIGN(0, PAGE_SIZE) - 1,
which is -1. lend is a uoff_t and truncate_inode_pages_range() takes -1
as its end of file sentinel, so rather than clearing nothing it drops
every folio in the destination mapping.

That is not only a cache drop. truncate_cleanup_folio() calls
folio_cancel_dirty(), and fuse_writeback_range() only wrote back
[pos_out, pos_out + len - 1], so dirty data elsewhere in the destination
file is discarded without ever reaching the server.

Skip the call when the server copied nothing, since there is nothing
stale to clear in that case.

Fixes: 9b46418c40fe ("fuse: copy_file_range should truncate cache")
Cc: stable@vger.kernel.org
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index a7a3ac5b34f42..18a3ef3a96953 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3094,9 +3094,11 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
 		goto out;
 	}
 
-	truncate_inode_pages_range(inode_out->i_mapping,
-				   ALIGN_DOWN(pos_out, PAGE_SIZE),
-				   ALIGN(pos_out + bytes_copied, PAGE_SIZE) - 1);
+	if (bytes_copied)
+		truncate_inode_pages_range(inode_out->i_mapping,
+					   ALIGN_DOWN(pos_out, PAGE_SIZE),
+					   ALIGN(pos_out + bytes_copied,
+						 PAGE_SIZE) - 1);
 
 	file_update_time(file_out);
 	fuse_write_update_attr(inode_out, pos_out + bytes_copied, bytes_copied);
-- 
2.53.0



