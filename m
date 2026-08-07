Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31EB46D2CC;
	Fri,  7 Aug 2026 15:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117089; cv=none; b=tpleNiaQOUGuFB7epkGXgA9bzEGtDeZ5AVhfDzZzzuKyrfZDZUzur44zJAaPqVPStG/iVatkNSK1aMfRS62ZNFRy4UydAopbKeU6n/7/NXklTQ2vcOBtsOJ92tMkZ3DnV7/ZH1ot+DirL5ocHGvwfy1AEmop6qt7HsFg+tWHQBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117089; c=relaxed/simple;
	bh=UhocW1AiNC/NTYvoiQbavKc+aRut3v1I+XlBc07apIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hET2zG6VkocuDwEYAoLOi4wgqvuzkest/DuaK8o8irCqZbJqClcjSBG0fMWGkk8ho+tNL3qZPmwyt0yl9vJR3p3IZZa6XhVMtwQYj27RgQimSVGO27n65lK8uzU68FqUATtr566tuvIQ7bqS2Wglhya/I6QeIny8tD/vEA9rS2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdyRx/tM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdyRx/tM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C80C1F000E9;
	Fri,  7 Aug 2026 15:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117088;
	bh=jPMg5GbPKUtGRAyCFWnvWwx0PWlnRni7vXlmm5PG6aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdyRx/tMAxt1TtkFK2fHTfXsTfpEkpErdqrIGurpI97eoh71b1k3JogKxH0oA3/i0
	 WCCtSH5qMfVRoNjslCVlkF4bjUtbDC+s+RCvIL5F81MB/RbIujaNQ3lA731USPjQcG
	 U3wsSIrEimJITBc6tH3cTmBMOSUrbr+bxzuoQnYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>,
	"Anirudh Rayabharam (Microsoft)" <anirudh@anirudhrb.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 195/438] mshv: Publish VP to pt_vp_array before installing the file descriptor
Date: Fri,  7 Aug 2026 16:36:31 +0200
Message-ID: <20260807143432.183964313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>

[ Upstream commit 72e3b0311aa90568a4b42a64445d1d3e1dc5a34d ]

mshv_partition_ioctl_create_vp() called anon_inode_getfd() before
publishing the new VP into partition->pt_vp_array.  anon_inode_getfd()
includes fd_install(), so the fd was live in current->files before the
publish ran.

A concurrent MSHV_RUN_VP ioctl on that fd does not serialise against the
in-progress MSHV_CREATE_VP — it takes vp->vp_mutex, not the partition
mutex.  Once the VP starts running and traps, mshv_intercept_isr() can look
up partition->pt_vp_array[vp_index] and observe NULL, silently dropping the
intercept message.

Split the fd creation: reserve an fd with get_unused_fd_flags(), create the
file with anon_inode_getfile(), publish the VP via smp_store_release(), and
finally call fd_install() as the userspace-visibility commit point.

Fixes: 621191d709b14 ("Drivers: hv: Introduce mshv_root module to expose /dev/mshv to VMMs")
Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Reviewed-by: Anirudh Rayabharam (Microsoft) <anirudh@anirudhrb.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/mshv_root_main.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/hv/mshv_root_main.c b/drivers/hv/mshv_root_main.c
index 8a15448e2ace9..cc2cfce2aefdb 100644
--- a/drivers/hv/mshv_root_main.c
+++ b/drivers/hv/mshv_root_main.c
@@ -1072,6 +1072,8 @@ mshv_partition_ioctl_create_vp(struct mshv_partition *partition,
 	struct mshv_vp *vp;
 	struct page *intercept_msg_page, *register_page, *ghcb_page;
 	struct hv_stats_page *stats_pages[2];
+	struct file *file;
+	int fd;
 	long ret;
 
 	if (copy_from_user(&args, arg, sizeof(args)))
@@ -1146,14 +1148,18 @@ mshv_partition_ioctl_create_vp(struct mshv_partition *partition,
 	if (ret)
 		goto put_partition;
 
-	/*
-	 * Keep anon_inode_getfd last: it installs fd in the file struct and
-	 * thus makes the state accessible in user space.
-	 */
-	ret = anon_inode_getfd("mshv_vp", &mshv_vp_fops, vp,
-			       O_RDWR | O_CLOEXEC);
-	if (ret < 0)
+	fd = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
+	if (fd < 0) {
+		ret = fd;
 		goto remove_debugfs_vp;
+	}
+
+	file = anon_inode_getfile("mshv_vp", &mshv_vp_fops, vp,
+				  O_RDWR | O_CLOEXEC);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		goto put_unused_vp_fd;
+	}
 
 	/* already exclusive with the partition mutex for all ioctls */
 	partition->pt_vp_count++;
@@ -1165,8 +1171,17 @@ mshv_partition_ioctl_create_vp(struct mshv_partition *partition,
 	 */
 	smp_store_release(&partition->pt_vp_array[args.vp_index], vp);
 
+	/*
+	 * fd_install() is the userspace-visibility commit point.  Must be the
+	 * last operation that can fail or be observed.
+	 */
+	fd_install(fd, file);
+	ret = fd;
+
 	goto out;
 
+put_unused_vp_fd:
+	put_unused_fd(fd);
 remove_debugfs_vp:
 	mshv_debugfs_vp_remove(vp);
 put_partition:
-- 
2.53.0



