Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063455;
	b=2SFYpT6Pe2m/x4t2dr8y3Gw0Piz6sbDqfFsE5AaHkz5PTOokVNzO2zcB8Wp+3yp7k/SG
	 XWPBZ35iy8QayuY46RsaAcUkFfgzLqisMPXvgDK7x2deRlh3mXLyshqYqv9Xz75ZbGexK
	 1mWza2zFzlagHt2OSJbztz353TyBT64LyGaXI29ThA7vmQ0K9T/FViCAG0grHCEtdIP9W
	 fmSjd6H68Y4ROs003mMl84wXVsCQJ3MxQTgfHPJrbF1+8MoqvYFP79BQ9bPa2L8kpMz9i
	 FF2f+BTJtVXSgETAOle8Zubc11o534cuI6aNM5ljonIeya8zbuMtHh+dUIdG1idJr8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063455;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ONjToDKfkP38/LFDjdQWLeil8Lm33Wp0GIfIMyCgUg4=;
	b=S+rawblyj/FjqQFA5MVDYdjCEa43Fu8d2fuTFZ3X3GlqL6q0KkgrYv9+rtxm/qvmOIzr
	 mQMn7hXQwJKqU2S8Vj6DPuv1Wti2IFOZTIY9bVnbA0f7LtQvfHb7HmegWcp2fnpTb7Nv9
	 FFJYYIzSzMq3EsWNmS5nzIeA9HT708+xp8xN0kLrvYaonVTTKM35Nh7vkjraykZlLUpx+
	 vMCBIEmIcrzyYb2b8GhstkjV+gQrO92e/J5IJBvXsRMKCUfFljdJRsRuCDcxoW7rzIU8p
	 VeCgojZn4GwkEv5dcHxA8RXsX+CJVSEVJxaglACxAZjkMFUnOJPgyN/Jf3Kyu5A9FYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EnEZyHus;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9367660A5BC9;
	Sat,  7 Nov 2026 14:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EnEZyHus
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9121F008A1;
	Sat,  7 Nov 2026 14:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063455;
	bh=ONjToDKfkP38/LFDjdQWLeil8Lm33Wp0GIfIMyCgUg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EnEZyHus9YsIMTp+GDTJBGhb15JJB2M8T58FoUvUoZlUkY1jjUyrssRZD0eJuOlFD
	 jSwnBbJIJzB9mOpduzuBTkvZPs2UJ0Ngmi0BNTa+6NBI+J9q7Quw02q5SiQGv7UB+3
	 4IpeqQvY4/BQld65iF6oBcDTvhLJ0uWAgU+0FfMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 612/869] virtio_fs: read the vring size under virtio_fs_mutex in ->get_tree
Date: Sat,  7 Nov 2026 08:54:54 -0500
Message-ID: <20261107134913.821311900@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/virtio_fs.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 2b3daa93e299a..e475f7f9e83d4 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -454,26 +454,23 @@ static int virtio_fs_add_instance(struct virtio_device *vdev,
 	return ret;
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
 			kobject_get(&fs->kobj);
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
@@ -1675,13 +1672,17 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
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



