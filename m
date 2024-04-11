Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B53145FEF;
	Thu, 11 Apr 2024 10:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829873; cv=none; b=Ich724LZY44iRnKxzoD0fmla8GWO97T4uvw8fMckul10IWb6d0DrJSwgjlzdX0w2dGQI2kZrlSSfE3GOqRcYubsDWVpM3PUE6OOLcgSNbpDzQO0z1hIUE3XiqT/SRA/2IWA0hKZoH4mE36mnL+HS0lOxqEaEZg4T0l+QfvZ8XPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829873; c=relaxed/simple;
	bh=ihakqqCV2wdjCnXZPvpLUvjwiw8TM9+14bnckk/x8jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgJSMwQ2upJB7nfsO9FSojWnem+HWSpd5XcNfLb/CKRlUhR5CuYxkWVrMEmQ2RPB10LxvzmTPMX05v71cmH6MbjIG6lCJbzwGaqZFK+Z6hXrMbv3VgeZA73lEdBABqC/l1ubLxF01AZzE3l+0/hNKGhJ/+aLsLays+m/wFf1tGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCG9cIqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCG9cIqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5F9C433C7;
	Thu, 11 Apr 2024 10:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829873;
	bh=ihakqqCV2wdjCnXZPvpLUvjwiw8TM9+14bnckk/x8jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WCG9cIqVPCFFgChgpvZUac8VLXSLFg0VySZft4iG5vo6h4Y69UzYF9Ntrh136tbzn
	 z16FHOM7ip4PZBEXQeY7Q7bWI+GHMEHyl4Cu4p2ZD8qQOHo8/U4wzqzuja38pppYgA
	 XnZf/kmUE6IVSC2RBoqTSC/RA9LVyoz/fJCKiWvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 135/175] fs: add a vfs_fchmod helper
Date: Thu, 11 Apr 2024 11:55:58 +0200
Message-ID: <20240411095423.629223160@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 9e96c8c0e94eea2f69a9705f5d0f51928ea26c17 ]

Add a helper for struct file based chmode operations.  To be used by
the initramfs code soon.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 4624b346cf67 ("init: open /initrd.image with O_LARGEFILE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/open.c          | 9 +++++++--
 include/linux/fs.h | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index e072e86003f56..fc634ab5af0d6 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -569,14 +569,19 @@ static int chmod_common(const struct path *path, umode_t mode)
 	return error;
 }
 
+int vfs_fchmod(struct file *file, umode_t mode)
+{
+	audit_file(file);
+	return chmod_common(&file->f_path, mode);
+}
+
 int ksys_fchmod(unsigned int fd, umode_t mode)
 {
 	struct fd f = fdget(fd);
 	int err = -EBADF;
 
 	if (f.file) {
-		audit_file(f.file);
-		err = chmod_common(&f.file->f_path, mode);
+		err = vfs_fchmod(f.file, mode);
 		fdput(f);
 	}
 	return err;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7d93d22ad1062..95e35e0740117 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1661,6 +1661,7 @@ int vfs_mkobj(struct dentry *, umode_t,
 		void *);
 
 int vfs_fchown(struct file *file, uid_t user, gid_t group);
+int vfs_fchmod(struct file *file, umode_t mode);
 
 extern long vfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
-- 
2.43.0



