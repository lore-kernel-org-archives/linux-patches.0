Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EB41EB1BF;
	Thu, 17 Apr 2025 18:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912995; cv=none; b=NZwhEfux/xhj6gjCViPJ6THpnqsMXBH+Qvti5Y72pf2vdEx4YXOxEySkD+XSkP65Nz7hxd6LxalsjjYkwlPUlvvuWngNUhqe5wl6x/mLFdh0mNyRLncPsuTS6cRAWwdH5LbhXixAeK85CtGfZcA2NxzUVcNMnPfRbpeb9d1pcSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912995; c=relaxed/simple;
	bh=6Lv6NM8CzA7gNG3mYHrO+n+dZ++6NdztPcQ/v3aYehg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTw94ZSvFVkyDR4XyOyvJ2dcBfKiz5TdAQtZuNuxYfIvM/AwMyduVVVtkOBFG8lVtjYalKrLIAX4DgUsL3nqjAIAk3JC6p3HaXbk6vLT0+L6rh28K3oEmrv2Pc1Sv6GJXyetB8UjgrV7yB+UkovePGJMsfTknUUV9CEqammb4f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PxMG8366; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PxMG8366"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE8CC4CEE4;
	Thu, 17 Apr 2025 18:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912995;
	bh=6Lv6NM8CzA7gNG3mYHrO+n+dZ++6NdztPcQ/v3aYehg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PxMG8366wdLJ2pUSYaqGVeNIvz7rvAbkr+PqMiIXNpvQdr0ZI6ca33pVnCo4Mq0Hy
	 /SJonsL3aP3sW0DEL/wWsMqVhlbCw0v9DxNAAMH4w13sxejP2di6/OXQQaZWvxaggo
	 XammLBET0V8Vi5fVMm+6Y/tkC2nSlgwcckGYOrs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yat Sin <David.YatSin@amd.com>,
	Jay Cornwall <jay.cornwall@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 165/449] drm/amdkfd: clamp queue size to minimum
Date: Thu, 17 Apr 2025 19:47:33 +0200
Message-ID: <20250417175124.625254256@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



