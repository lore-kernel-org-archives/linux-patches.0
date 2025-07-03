Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132532EE287;
	Thu,  3 Jul 2025 14:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554074; cv=none; b=qI3DJMqVbjGTMWId76b25qIqoDma2xC1KPbm7fvzUhZyJk714yeNLoFhU05EUFftmedvrP7ZsxEoClpsmgM+UvEad4TONBSJsmMd6GIhjt3CdQmdjiuczEBqhJfdOeJjCpxbCrf3zfe+dkexvdYdR6Y2EAptjC7iU/nSWQ8Ovjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554074; c=relaxed/simple;
	bh=OxXYITxY9snVyE/jxDxKzGEhv40Uq05R/Mjnbu9M6yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SI9UV15d8hxUXHzO7KeiLeUy9nUIE3LtZsKVKNxxtLUWFIYdyA+Z0IXwkvL94+GqSTUym82H6qh+FvMKOdlQH6LD9vIIul/yJwYvcPAJNAJJAtKhqw9XzrLlKmRDMp+g8losRuTKpLdgnzWH5B9O03gmUnYiW7Hx3ULBbMLtUUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HdhV1D96; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HdhV1D96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756DFC4CEE3;
	Thu,  3 Jul 2025 14:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554073;
	bh=OxXYITxY9snVyE/jxDxKzGEhv40Uq05R/Mjnbu9M6yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HdhV1D965ioqimxF7qHfJzou6zyEF7RBrcZJdF8QZ+UlSS9Xa6dpTG5RFMk7Nin3s
	 e20omDaBcaDydyJFATHXeyUcE2m1THwsdA3p8EDnQZYjSy+ftGb6KrD5db1O9MFX5j
	 iVLlRuKx/i10YEQwtqftIvgRudda1Qjzq9SESf7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@intel.com>,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/218] accel/ivpu: Separate DB ID and CMDQ ID allocations from CMDQ allocation
Date: Thu,  3 Jul 2025 16:40:21 +0200
Message-ID: <20250703143958.859404005@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Karol Wachowski <karol.wachowski@intel.com>

[ Upstream commit 950942b4813f8c44dbec683fdb140cf4a238516b ]

Move doorbell ID and command queue ID XArray allocations from command
queue memory allocation function. This will allow ID allocations to be
done without the need for actual memory allocation.

Signed-off-by: Karol Wachowski <karol.wachowski@intel.com>
Signed-off-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250107173238.381120-2-maciej.falkowski@linux.intel.com
Stable-dep-of: a47e36dc5d90 ("accel/ivpu: Trigger device recovery on engine reset/resume failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_job.c | 88 +++++++++++++++++++++++++----------
 1 file changed, 64 insertions(+), 24 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_job.c b/drivers/accel/ivpu/ivpu_job.c
index 5eaf219170eee..e57acae3b42ef 100644
--- a/drivers/accel/ivpu/ivpu_job.c
+++ b/drivers/accel/ivpu/ivpu_job.c
@@ -86,23 +86,9 @@ static struct ivpu_cmdq *ivpu_cmdq_alloc(struct ivpu_file_priv *file_priv)
 	if (!cmdq)
 		return NULL;
 
-	ret = xa_alloc_cyclic(&vdev->db_xa, &cmdq->db_id, NULL, vdev->db_limit, &vdev->db_next,
-			      GFP_KERNEL);
-	if (ret < 0) {
-		ivpu_err(vdev, "Failed to allocate doorbell id: %d\n", ret);
-		goto err_free_cmdq;
-	}
-
-	ret = xa_alloc_cyclic(&file_priv->cmdq_xa, &cmdq->id, cmdq, file_priv->cmdq_limit,
-			      &file_priv->cmdq_id_next, GFP_KERNEL);
-	if (ret < 0) {
-		ivpu_err(vdev, "Failed to allocate command queue id: %d\n", ret);
-		goto err_erase_db_xa;
-	}
-
 	cmdq->mem = ivpu_bo_create_global(vdev, SZ_4K, DRM_IVPU_BO_WC | DRM_IVPU_BO_MAPPABLE);
 	if (!cmdq->mem)
-		goto err_erase_cmdq_xa;
+		goto err_free_cmdq;
 
 	ret = ivpu_preemption_buffers_create(vdev, file_priv, cmdq);
 	if (ret)
@@ -110,10 +96,6 @@ static struct ivpu_cmdq *ivpu_cmdq_alloc(struct ivpu_file_priv *file_priv)
 
 	return cmdq;
 
-err_erase_cmdq_xa:
-	xa_erase(&file_priv->cmdq_xa, cmdq->id);
-err_erase_db_xa:
-	xa_erase(&vdev->db_xa, cmdq->db_id);
 err_free_cmdq:
 	kfree(cmdq);
 	return NULL;
@@ -231,30 +213,88 @@ static int ivpu_cmdq_fini(struct ivpu_file_priv *file_priv, struct ivpu_cmdq *cm
 	return 0;
 }
 
+static int ivpu_db_id_alloc(struct ivpu_device *vdev, u32 *db_id)
+{
+	int ret;
+	u32 id;
+
+	ret = xa_alloc_cyclic(&vdev->db_xa, &id, NULL, vdev->db_limit, &vdev->db_next, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+
+	*db_id = id;
+	return 0;
+}
+
+static int ivpu_cmdq_id_alloc(struct ivpu_file_priv *file_priv, u32 *cmdq_id)
+{
+	int ret;
+	u32 id;
+
+	ret = xa_alloc_cyclic(&file_priv->cmdq_xa, &id, NULL, file_priv->cmdq_limit,
+			      &file_priv->cmdq_id_next, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+
+	*cmdq_id = id;
+	return 0;
+}
+
 static struct ivpu_cmdq *ivpu_cmdq_acquire(struct ivpu_file_priv *file_priv, u8 priority)
 {
+	struct ivpu_device *vdev = file_priv->vdev;
 	struct ivpu_cmdq *cmdq;
-	unsigned long cmdq_id;
+	unsigned long id;
 	int ret;
 
 	lockdep_assert_held(&file_priv->lock);
 
-	xa_for_each(&file_priv->cmdq_xa, cmdq_id, cmdq)
+	xa_for_each(&file_priv->cmdq_xa, id, cmdq)
 		if (cmdq->priority == priority)
 			break;
 
 	if (!cmdq) {
 		cmdq = ivpu_cmdq_alloc(file_priv);
-		if (!cmdq)
+		if (!cmdq) {
+			ivpu_err(vdev, "Failed to allocate command queue\n");
 			return NULL;
+		}
+
+		ret = ivpu_db_id_alloc(vdev, &cmdq->db_id);
+		if (ret) {
+			ivpu_err(file_priv->vdev, "Failed to allocate doorbell ID: %d\n", ret);
+			goto err_free_cmdq;
+		}
+
+		ret = ivpu_cmdq_id_alloc(file_priv, &cmdq->id);
+		if (ret) {
+			ivpu_err(vdev, "Failed to allocate command queue ID: %d\n", ret);
+			goto err_erase_db_id;
+		}
+
 		cmdq->priority = priority;
+		ret = xa_err(xa_store(&file_priv->cmdq_xa, cmdq->id, cmdq, GFP_KERNEL));
+		if (ret) {
+			ivpu_err(vdev, "Failed to store command queue in cmdq_xa: %d\n", ret);
+			goto err_erase_cmdq_id;
+		}
 	}
 
 	ret = ivpu_cmdq_init(file_priv, cmdq, priority);
-	if (ret)
-		return NULL;
+	if (ret) {
+		ivpu_err(vdev, "Failed to initialize command queue: %d\n", ret);
+		goto err_free_cmdq;
+	}
 
 	return cmdq;
+
+err_erase_cmdq_id:
+	xa_erase(&file_priv->cmdq_xa, cmdq->id);
+err_erase_db_id:
+	xa_erase(&vdev->db_xa, cmdq->db_id);
+err_free_cmdq:
+	ivpu_cmdq_free(file_priv, cmdq);
+	return NULL;
 }
 
 void ivpu_cmdq_release_all_locked(struct ivpu_file_priv *file_priv)
-- 
2.39.5



