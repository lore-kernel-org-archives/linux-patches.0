Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F693322B93;
	Tue,  6 Jan 2026 17:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719748; cv=none; b=UxvXtv/ZFgs/8QsdbQLtKp6d218LQsVthghSckZCPZmCvBWJB7P48yjDERSLwNx+dgwaheOO4mzY7wAV00KMDLwf1m9GK9hdsBpUKeMPdz6B+nhGfDjSt6J4kPq9WUgqegbSq1TRrzUz9KZK7uHb3H2ddMb1O8MUl/SxVOJBbx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719748; c=relaxed/simple;
	bh=V2maSuC8HR8PvlPAY2iNTMkKt/o8r69vs8M8HJh+QUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnvqfoYrZ2MO8QqpLQLTTJv16DXleoSmbWoP5QrW7vBQBhneElN3W74QDqLqllrUqvTiiQ+efU81g4flkfs/tAz7K/zQpoyJnyTU1zpdv/xuU/WdaY7a0KWqeazEUOg6aeNtxk+Mo+VOBpJ99kTMdv7HqFk8jzVKWmgVKJ2nFoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xA0jRWaa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xA0jRWaa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B724C16AAE;
	Tue,  6 Jan 2026 17:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719746;
	bh=V2maSuC8HR8PvlPAY2iNTMkKt/o8r69vs8M8HJh+QUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xA0jRWaa/BfyJvME2UWG1XRkjMIaLDJWxne+84JCNitfedcW2Pu8aUgEcgcFCRfVB
	 exkbYMZYZ9cDrzFtpnAjWRw5GxuzbABVA3BI1MyC6ekJhsdW9DYi3EJ1rHd5/DtJ/d
	 e1sCkAk9YUDUg0bkVrGZdKW8GY5psQYc2WtfJzpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/567] fs/ntfs3: check for shutdown in fsync
Date: Tue,  6 Jan 2026 17:56:49 +0100
Message-ID: <20260106170452.349410891@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 1b2ae190ea43bebb8c73d21f076addc8a8c71849 ]

Ensure fsync() returns -EIO when the ntfs3 filesystem is in forced
shutdown, instead of silently succeeding via generic_file_fsync().

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 902dc8ba878ef..f1122ac5be622 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -1396,6 +1396,18 @@ static ssize_t ntfs_file_splice_write(struct pipe_inode_info *pipe,
 	return iter_file_splice_write(pipe, file, ppos, len, flags);
 }
 
+/*
+ * ntfs_file_fsync - file_operations::fsync
+ */
+static int ntfs_file_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	struct inode *inode = file_inode(file);
+	if (unlikely(ntfs3_forced_shutdown(inode->i_sb)))
+		return -EIO;
+
+	return generic_file_fsync(file, start, end, datasync);
+}
+
 // clang-format off
 const struct inode_operations ntfs_file_inode_operations = {
 	.getattr	= ntfs_getattr,
@@ -1420,7 +1432,7 @@ const struct file_operations ntfs_file_operations = {
 	.splice_write	= ntfs_file_splice_write,
 	.mmap		= ntfs_file_mmap,
 	.open		= ntfs_file_open,
-	.fsync		= generic_file_fsync,
+	.fsync		= ntfs_file_fsync,
 	.fallocate	= ntfs_fallocate,
 	.release	= ntfs_file_release,
 };
-- 
2.51.0



