Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F999273803;
	Mon, 29 Dec 2025 16:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024925; cv=none; b=fRFUj+/PSNdgrq6ComCLy+BYSbmsn7IylSCQhx5b6tVIVIPilhn9lTuEIaRkeJ7p+2YORRyU/NVWY55CUY+NtCY4LHaxScbVzPgzPv7CcsW71lzhc34dg6f3yT9mSZHT3B/zH1phi6QEM0BXrWc4lws1DAyiQCS7nOzOTF1Q9UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024925; c=relaxed/simple;
	bh=yOfId5Z1v954mkKuVXDeNYIl977yTSiyxYFXt9aYugw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=il3OpoEspqt7BKl/TylKunhdjgZF/Gjeg1PMXRoP1p4mObgFAVMBqB7fXwZqGbodcnalzoLAP1FAflQ5R0lYh3xve6P3IiCvl7ktJN27YAhsllbkdvsomirXFHuYcVHXUOphLkbTcXfUQNAVD0WnsDGxXO2bVHiju1jukUgj/bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSjsOGP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSjsOGP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1069C4CEF7;
	Mon, 29 Dec 2025 16:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024925;
	bh=yOfId5Z1v954mkKuVXDeNYIl977yTSiyxYFXt9aYugw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iSjsOGP/b4g3YX1YG2EDFea0L3I39rT4Hlw/F6DrcXwHliDSk1dKAjhsSpT7r/zmB
	 1eME8N+O9BFg0QXTQtTA2Qmxbo5XFr+A5OEsBZpy/pURPQ0RM1Sp4oQCNJSZcwScW+
	 fck6/SpWZDor+yxLc6NgNALjBNvxaO7lciPBHwmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 033/430] fs/ntfs3: check for shutdown in fsync
Date: Mon, 29 Dec 2025 17:07:15 +0100
Message-ID: <20251229160725.584676052@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
index 4c90ec2fa2eae..83f0072f0896c 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -1375,6 +1375,18 @@ static ssize_t ntfs_file_splice_write(struct pipe_inode_info *pipe,
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
@@ -1397,7 +1409,7 @@ const struct file_operations ntfs_file_operations = {
 	.splice_write	= ntfs_file_splice_write,
 	.mmap_prepare	= ntfs_file_mmap_prepare,
 	.open		= ntfs_file_open,
-	.fsync		= generic_file_fsync,
+	.fsync		= ntfs_file_fsync,
 	.fallocate	= ntfs_fallocate,
 	.release	= ntfs_file_release,
 };
-- 
2.51.0



