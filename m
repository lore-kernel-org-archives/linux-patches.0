Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B520E257AE7;
	Thu, 17 Apr 2025 18:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914308; cv=none; b=NBos2zmmlbytxAnvRNh7zphcDzQnbodNhY5mvKDyu1an6iERElNzQZp9rrHLkkdaahBnXQsALet/Z//NXbE778p/3xtYvUc4ApI5TiC01kTApiYQHUN/TZ76C3n12KkSIlxCRbtWVOamGXINvmj0GDr+tJmWp8LffEB7Q+Qpdxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914308; c=relaxed/simple;
	bh=/FVi5GF+t8iurFB3E9pJ5WiTJf8s34DYaajTJ4H71sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+NU31XDP3p6KdNCAuuDqLlNHle/t55Kd8rIKm1UuvKnYA+u7MbniVHgThSXx4zmVJm9Jb8d3ejXm0Yr19pSJX5gf1JsBbmszieIv+4CT7z+cB/UsPqvafT2ietUL9QEtM+rg3OParXcDgumNwYg2++Wlr8uvs5KhH05+caidKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Ox2ob1G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Ox2ob1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E51C4CEE4;
	Thu, 17 Apr 2025 18:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914308;
	bh=/FVi5GF+t8iurFB3E9pJ5WiTJf8s34DYaajTJ4H71sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Ox2ob1GPFohK4pPBMT6UUpD6WgqjOEd/8fVh7WehAVLGPdNO1fgz7uQXsgVzJk82
	 BGEumi3zNZmLfrAMwAx4Olu/InY6Xuw34MKPTeSES3174J4UOtAQN8K8XKWvz6J4mv
	 6uUj2BW/q2xOFglkzO5Dnz43DhFabKaP/6hEWyww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yat Sin <David.YatSin@amd.com>,
	Jay Cornwall <jay.cornwall@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 146/414] drm/amdkfd: clamp queue size to minimum
Date: Thu, 17 Apr 2025 19:48:24 +0200
Message-ID: <20250417175117.296497474@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Yat Sin <David.YatSin@amd.com>

[ Upstream commit e90711946b53590371ecce32e8fcc381a99d6333 ]

If queue size is less than minimum, clamp it to minimum to prevent
underflow when writing queue mqd.

Signed-off-by: David Yat Sin <David.YatSin@amd.com>
Reviewed-by: Jay Cornwall <jay.cornwall@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 10 ++++++++++
 include/uapi/linux/kfd_ioctl.h           |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 065d878414591..33df35cab4679 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -212,6 +212,11 @@ static int set_queue_properties_from_user(struct queue_properties *q_properties,
 		return -EINVAL;
 	}
 
+	if (args->ring_size < KFD_MIN_QUEUE_RING_SIZE) {
+		args->ring_size = KFD_MIN_QUEUE_RING_SIZE;
+		pr_debug("Size lower. clamped to KFD_MIN_QUEUE_RING_SIZE");
+	}
+
 	if (!access_ok((const void __user *) args->read_pointer_address,
 			sizeof(uint32_t))) {
 		pr_err("Can't access read pointer\n");
@@ -461,6 +466,11 @@ static int kfd_ioctl_update_queue(struct file *filp, struct kfd_process *p,
 		return -EINVAL;
 	}
 
+	if (args->ring_size < KFD_MIN_QUEUE_RING_SIZE) {
+		args->ring_size = KFD_MIN_QUEUE_RING_SIZE;
+		pr_debug("Size lower. clamped to KFD_MIN_QUEUE_RING_SIZE");
+	}
+
 	properties.queue_address = args->ring_base_address;
 	properties.queue_size = args->ring_size;
 	properties.queue_percent = args->queue_percentage & 0xFF;
diff --git a/include/uapi/linux/kfd_ioctl.h b/include/uapi/linux/kfd_ioctl.h
index fa9f9846b88e4..b0160b09987c1 100644
--- a/include/uapi/linux/kfd_ioctl.h
+++ b/include/uapi/linux/kfd_ioctl.h
@@ -62,6 +62,8 @@ struct kfd_ioctl_get_version_args {
 #define KFD_MAX_QUEUE_PERCENTAGE	100
 #define KFD_MAX_QUEUE_PRIORITY		15
 
+#define KFD_MIN_QUEUE_RING_SIZE		1024
+
 struct kfd_ioctl_create_queue_args {
 	__u64 ring_base_address;	/* to KFD */
 	__u64 write_pointer_address;	/* from KFD */
-- 
2.39.5



