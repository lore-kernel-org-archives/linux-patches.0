Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04D3175A99;
	Mon, 17 Aug 2026 14:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976624; cv=none; b=ovpgyuKBnm4GAr0lFZmG5fAId+J9qePSnVxNtFua4YX5LRQONOvzl7LtHe2s4UjXQ/5yZ8V/I/YYVymWqfxqNl2wYK+lJjlJmvCCXud3mPYdHJKECqufJgCtEbi/I7IFEiXj+Fjb4iTtu1uLAS8PWjPFyruC5D+3aqly/+IphdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976624; c=relaxed/simple;
	bh=aWQ+CsHKm7pxaZ1ioTQyPCGIzzpt9BaItEeZF/0nQJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbsOTpoJ9Ch3x01W25hpYsYL7wIAr+jrsrthh5HN4bc/ZhpwtjmJLo/hqwiVWmlCjOnqNDz+BFvRqE2+T/++f57vjYJRnXFExs3JsuUrIN+lQbPtOAgF5w+JeG2uJo4t+Yw9bpJhY1tfsdy0CUEkrI4CZ3mfNVgcm5q5sWtY7G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKkx1mzw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKkx1mzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F631F000E9;
	Mon, 17 Aug 2026 14:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976622;
	bh=1aO6e773FIONLyjd7d+zwmyeI6Kn1D7fzXO9jXHNmz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LKkx1mzwMD5neCin/P03aNemzcLhIKtkBNC5j+jm71c5Lw+F4QrTvKWqsGgMgGDwP
	 UqkdXDpr9bJ+ai8CsiMD+yybkknPfZV18q9HV32u7J+gITAEbpYCOc6EjMdio7NAb+
	 ML6E7/0wK1kK29pwanS3rf+RMe877/2+f3hf9y0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/456] smb/client: handle overlapping allocated ranges in fallocate
Date: Mon, 17 Aug 2026 15:27:16 +0200
Message-ID: <20260817132541.841138269@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huiwen He <hehuiwen@kylinos.cn>

[ Upstream commit b09ae45d85dc816987a71db9eebc54b0ae288e94 ]

smb3_simple_fallocate_range() can skip holes when an allocated range
returned by the server starts before the current fallocate offset. The
skipped hole is not zero-filled, but fallocate still returns success. A
later write to that hole may therefore fail with ENOSPC.

The function queries allocated ranges so that it can preserve existing
contents and write zeroes only into holes. However, the server may return
a range that starts before the current fallocate offset.

For example, assume the fallocate request is [100, 400) and the only
allocated range returned by the server is [0, 200):

        Request:      [100, 400)
        Server range: [  0, 200)  allocated

        Correct:
        [100, 200)    allocated data, skip
        [200, 400)    hole, zero-fill

        Current:
        [100, 300)    skipped
        [300, 400)    zero-filled afterwards

The current code adds the full server range length, 200, to the current
offset 100 and moves to 300. As a result, the hole in [200, 300) is
skipped without being zero-filled.

Fix this by advancing only over the part of the allocated range that
overlaps the current fallocate offset.  Ignore ranges that end before the
current offset and reject ranges whose end offset overflows.

This also prevents a malformed range length from causing an out-of-bounds
zero-buffer read.

Fixes: 966a3cb7c7db ("cifs: improve fallocate emulation")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 5d80ab4fa08777..3aaa45375d8ba0 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3721,6 +3721,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 	struct file_allocated_range_buffer in_data, *out_data = NULL, *tmp_data;
 	u32 out_data_len;
 	char *buf = NULL;
+	u64 range_start, range_len, range_end;
 	loff_t l;
 	int rc;
 
@@ -3757,13 +3758,21 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 			goto out;
 		}
 
-		if (off < le64_to_cpu(tmp_data->file_offset)) {
+		range_start = le64_to_cpu(tmp_data->file_offset);
+		range_len = le64_to_cpu(tmp_data->length);
+		if (check_add_overflow(range_start, range_len, &range_end) ||
+		    range_end > S64_MAX) {
+			rc = -EINVAL;
+			goto out;
+		}
+
+		if (off < range_start) {
 			/*
 			 * We are at a hole. Write until the end of the region
 			 * or until the next allocated data,
 			 * whichever comes next.
 			 */
-			l = le64_to_cpu(tmp_data->file_offset) - off;
+			l = range_start - off;
 			if (len < l)
 				l = len;
 			rc = smb3_simple_fallocate_write_range(xid, tcon,
@@ -3780,11 +3789,13 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 		 * until the end of the data or the end of the region
 		 * we are supposed to fallocate, whichever comes first.
 		 */
-		l = le64_to_cpu(tmp_data->length);
-		if (len < l)
-			l = len;
-		off += l;
-		len -= l;
+		if (off < range_end) {
+			l = range_end - off;
+			if (len < l)
+				l = len;
+			off += l;
+			len -= l;
+		}
 
 		tmp_data = &tmp_data[1];
 		out_data_len -= sizeof(struct file_allocated_range_buffer);
-- 
2.53.0



