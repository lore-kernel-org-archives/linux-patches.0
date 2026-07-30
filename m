Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9522C446BFB;
	Thu, 30 Jul 2026 15:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425644; cv=none; b=MIu7N4GWs6I1QUfAs4Su99R5ZjeaKNkQa1Ss11l63UQPGpEObbSZICiJHsTn9RMtAN4xxb0XmaioqUflDUXZK6iTPUOLdRY/LWZNEsCkFhrejdu2YUj692Ju+EUWvHIcvFSdzQl0QvqF7zBYyyoa+SWcGGgJjDOy7Y8s9MkNozA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425644; c=relaxed/simple;
	bh=+u/yMO9qEV6i/twJ1jG54x+Ff+hfyK8Df8CNOTp/zwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7RtrL/Hd+8cl5aeEcIbqkeMYj3a7/XQCZ/Z4abJtrvnX+pwIc5GgaB0Fpm/ZmH35t5cgwI82PYNHkONy0tLbWIbg++Y3dekTYmeIAo0FkxvemQ0gKUWlAX24crk+R+3KXzRr/G0tXEyOhBgcA0FCpth0rl1XzafB2XFfbxdiqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=msVhLeUz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="msVhLeUz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01371F00A3A;
	Thu, 30 Jul 2026 15:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425643;
	bh=P2K34y6XeLo1n1RZD+WIozFYQUBh42nvAQ3ftmDHM/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=msVhLeUzqFm1nvoaP/MOAWgWea6euqLKWvGuKJ9MSxQo/2A7b63qfdCV6fm4OE3qU
	 iqlaBIyFTkLm/8gxyWglZqO0rqbNxf02norxOziMyVyT35p2OpbHPxDYKzz9hc7i9h
	 gn10YIDD7gKxpsR+wg9kzTJjFfuAiYY7Jr01nJ9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/602] smb/client: handle overlapping allocated ranges in fallocate
Date: Thu, 30 Jul 2026 16:08:08 +0200
Message-ID: <20260730141438.012314040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
 fs/smb/client/smb2ops.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index f63361bc1641d5..61309fead04e57 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3482,6 +3482,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 	struct file_allocated_range_buffer in_data, *out_data = NULL, *tmp_data;
 	u32 out_data_len;
 	char *buf = NULL;
+	u64 range_start, range_len, range_end;
 	loff_t l;
 	int rc;
 
@@ -3518,13 +3519,21 @@ static int smb3_simple_fallocate_range(unsigned int xid,
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
@@ -3541,11 +3550,13 @@ static int smb3_simple_fallocate_range(unsigned int xid,
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



