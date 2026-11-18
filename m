Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038666;
	b=rOv+k2j11HArfi4VLqWjEsewkpp7zBpUvM2PefKTjGZVtDey9OkNOF5qYqOTmpj3+576
	 1CdShuc8KBlZxAGqJMjoBWcJhJN2rmGNhyh5eMoyqTCLnRv6IhuSvwuUFo4omGPKcYQMG
	 ZXmLbCiMgbQCG9a1hSjRr3GmhyitL6OvHzIQNFRypXNWyoYhXeXiKQ6OGzaYLx1wbJ3DQ
	 5Mrhbqnyu5T3TGUs/J1yOKauLF1yUYykomWO3gg6tlCPj1OW0mSUKag1GyQRT5dG1a9u3
	 0REc4lJX31fCxdPuFi1gI9tTJn7w9wReHGLXehF4ybfAmaObt1PYr/5N6Y0zxKwQEgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=EGyZfa8PPpbfY/11adGdwSR12VsYAnMxKdcsXWiz21Q=;
	b=zzLhfofF/K3t0cHjCjej1VNrci1fA+2cRrtfBKUKzDojqJAiqjsXKSNNNmhqgNY9TNCV
	 cKJzr8DMI4RuUVY1/Nxuo9ybGpqJjbnIEIDKc+3xURRXe4ekOfpmeH+Fh2I27/JvlhK+9
	 uEnNAqDFpDX9zQ+AATkU9Wthrspza2hBps6KBB2O08DSgbuNBJheoYplYAuSXhK8/AE2k
	 Xet4bSliOjNOnXlIM11KwKZvs/RSRiXgr/gL9Nv84cHRQXHTNe90XEXG7dO1VcohjWOk+
	 yaWUygxu8OW6DDFU/8ZcLrab2Ze+km2CUBWqBmJJVqNml3OCDCyUq1jPaqxWW2F4KMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iil2/iDy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C793606A31C;
	Wed, 18 Nov 2026 21:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iil2/iDy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B921F000C4;
	Wed, 18 Nov 2026 21:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038666;
	bh=EGyZfa8PPpbfY/11adGdwSR12VsYAnMxKdcsXWiz21Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iil2/iDyGl4eW/l2zcGijOOpn1yQx2lmpheF47TFlQkFP/gxVIvpAg9OrQRmBdAvw
	 YYjDRAiw3bApjRKRkITk5DmNNIjHDHFhTTgwsUKKnU1DjFbLST1G4vOhVl/H4IIrSe
	 YN85EAGMf9Y4cRwdNHVQkyddY5gLrlqe/AAOgCmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1822/3318] virtio_fs: read the vring size under virtio_fs_mutex in ->get_tree
Date: Wed, 18 Nov 2026 15:40:44 +0100
Message-ID: <20261118150416.521803832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit e7ccc777a040343b80f95f4cc5c12ce1df3187f4 ]

The vring size was read after virtio_fs_find_instance() had dropped
virtio_fs_mutex, so a concurrent virtio_fs_remove() could free the
virtqueue first. The reference from the lookup keeps the virtio_fs
alive, but not its virtqueues.

Hold the mutex across the lookup and the read.

This issue was found by an in-house static analysis tool.

Fixes: a7f0d7aab0b4 ("virtiofs: split requests that exceed virtqueue size")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
[ sashal: Adjusted context to preserve kref_get(&fs->refcount) instead of upstream’s kobject_get(&fs->kobj). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/virtio_fs.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index b5ecbd146301b..d78ad4cc4fc94 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -265,26 +265,23 @@ static int virtio_fs_add_instance(struct virtio_fs *fs)
 	return 0;
 }
 
-/* Return the virtio_fs with a given tag, or NULL */
+/* Return the virtio_fs with a given tag, or NULL.
+ * Callers hold virtio_fs_mutex, which also keeps the virtqueues alive.
+ */
 static struct virtio_fs *virtio_fs_find_instance(const char *tag)
 {
 	struct virtio_fs *fs;
 
-	mutex_lock(&virtio_fs_mutex);
+	lockdep_assert_held(&virtio_fs_mutex);
 
 	list_for_each_entry(fs, &virtio_fs_instances, list) {
 		if (strcmp(fs->tag, tag) == 0) {
 			kref_get(&fs->refcount);
-			goto found;
+			return fs;
 		}
 	}
 
-	fs = NULL; /* not found */
-
-found:
-	mutex_unlock(&virtio_fs_mutex);
-
-	return fs;
+	return NULL; /* not found */
 }
 
 static void virtio_fs_free_devs(struct virtio_fs *fs)
@@ -1488,13 +1485,17 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 	 * in fc->iq->priv. Once fuse_conn is going away, it calls ->put()
 	 * to drop the reference to this object.
 	 */
+	mutex_lock(&virtio_fs_mutex);
 	fs = virtio_fs_find_instance(fsc->source);
+	if (fs)
+		virtqueue_size = virtqueue_get_vring_size(fs->vqs[VQ_REQUEST].vq);
+	mutex_unlock(&virtio_fs_mutex);
+
 	if (!fs) {
 		pr_info("virtio-fs: tag <%s> not found\n", fsc->source);
 		return -EINVAL;
 	}
 
-	virtqueue_size = virtqueue_get_vring_size(fs->vqs[VQ_REQUEST].vq);
 	if (WARN_ON(virtqueue_size <= FUSE_HEADER_OVERHEAD))
 		goto out_err;
 
-- 
2.53.0



