Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054161;
	b=Wnj8TUUoRj7IzX1srFbrcGvkugr8QSIwIVq2omM+3pjD9pJyj13KeNcbyxORKgGVUaL6
	 AbcpIKkEH/F0fd7UpAUwxtR2aF6NKXNmCfaT6NaDUof9sUpM1XzYBIf88RG9sabxOd2Dj
	 cJ3YVRnWi325XwVrPAo2/c4nK0MQFcOYZpbRYOy2EngaCZx076O2Yj7uQJ4xa78LwLKXo
	 kntj4ZX3ZJQkLEw4LrOWTDQ9Z0tpONPZ58mhLEMXLG7b0s6e0QpDcJY6GcvY6FOFa0Z3N
	 A2+txrdukgrUt4L8SS3SFOp02//9f3GJmpWbqFGdQag30RVGZWuWBhxclbirm5OP4kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054161;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bq4dcJk+o0Hl9d9Zz1J8dQc1perOnvneJYMfpw9+yiw=;
	b=wem4kI2x5mOkc5N/sc7HXfM+UXNu4eL0jKY6ck+6H7XkYtk/0J1CE5sCsiT5v3vYHDn8
	 8jP1HfLntIx8LlzwvDVeONvP9nDINGVtSQoQaOppzTm7atQIjNvZPjgnyN2O3q4VUQQs8
	 K8Cse9TFLuOInkI7TuvwXw2oZEBIPANd6pmwsRNuBmWTb9vtAWGh6bH8zkQjt1ojILdRw
	 njRacuFoAuxyIJ73CUhxt2VG808/Hx+N6sxK+5UY3LMuQLpqqzblOhG7DKd5Q3DqUpcIy
	 q8nnryX1vavWFGLuhY8QdLmIZAry4ljuzP28aXIsaa9F3O+v/gBzRRFQ2n/A+pT5D6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M4w8qUbI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98376606A325;
	Thu, 19 Nov 2026 02:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M4w8qUbI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17181F000C4;
	Thu, 19 Nov 2026 02:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054161;
	bh=bq4dcJk+o0Hl9d9Zz1J8dQc1perOnvneJYMfpw9+yiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M4w8qUbI7tn1JiNEKBk2PCB1hSYUTewjDuOq47+MRu/nATTY/djWfQ8j3mF8XgQNL
	 IyTE/4REVjNi9EOF1EK5tLykXmczEs4HE0VDc0khK/FFZY/Vl5Z2NKBBZ95Ki9N5aw
	 qa4PMs14hdTJiF9EYP1eBLzDiBTk923uGZ/lQs0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1176/2214] virtio_fs: read the vring size under virtio_fs_mutex in ->get_tree
Date: Wed, 18 Nov 2026 15:47:32 +0100
Message-ID: <20261118150059.014828059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for kref_get() instead of kobject_get() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/virtio_fs.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 14c1ae5075938..9ebcf26621ac7 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -252,26 +252,23 @@ static int virtio_fs_add_instance(struct virtio_fs *fs)
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
@@ -1489,13 +1486,17 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
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



