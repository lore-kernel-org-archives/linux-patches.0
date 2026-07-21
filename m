Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7772D5436;
	Tue, 21 Jul 2026 17:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655640; cv=none; b=WoIk8mZ0ILenHH6vhINV4+sAm8AJUBymPOERKLnz91OsdM2q2/IcVl8fAa9VGeNdHO/xrZc/WDsCv7MQw3zbPpFYWKPWCGb72+kDVuf6Hdrepx7ePI7idJ349km3Jm4HidnWIIThJjRa3FG042q4KQQs+CTR8R0wW9modT9QMqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655640; c=relaxed/simple;
	bh=GiHg+sHw/9j++uchSfuDqfAe91rjR25InpIKMd0t/jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGpfXoFVK4pFAjzt50ytj7gRSCjMrdHJietX3OSvw27T1T0QypXP8KIBJ3NnonSqj5iUXIe0ycSXOs0qOFI+HhKep/UeiEQ3ZC/z33Z+ZTXM7gLX5TwN5LZvJY6+QlVF/kZA9QtkGFO7mbtrUs7wzSHko27ToZYl3Q0oj0xgfhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkTKAWTe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkTKAWTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A998C1F000E9;
	Tue, 21 Jul 2026 17:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655639;
	bh=1wL4OzbV/Z0WZQEWZeAMguo4KGon/BrgzZybRnIJ89E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zkTKAWTe9RfJT8h8cNVgptwTu5Ji0zmeKl6YgK8dpABbgjQueP/O5ccs9Tlen/26O
	 AM35eQyNV8+LB5MHvILiJVTYvosJOs5W7iNs+nkOxxYNccY/QZhRyFeCRVDrvhOFAF
	 B78NEfRNnMG911R7xGtQagjEdBYi1NfFLpciRE5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	David Yat Sin <david.yatsin@amd.com>,
	Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0084/1611] drm/amdkfd: Validate CRIU-restored IDs before idr_alloc
Date: Tue, 21 Jul 2026 17:03:20 +0200
Message-ID: <20260721152516.735394284@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 85043dd49c2f51a37b22618168e3ae59ab92f0d6 ]

The KFD CRIU restore flow restores previously saved object IDs from
userspace.

For event restore:

  kfd_criu_restore_event()
      -> create_signal_event() / create_other_event()
          -> allocate_event_notification_slot()
              -> idr_alloc(..., *restore_id, *restore_id + 1, ...)

For BO restore:

  criu_restore_memory_of_gpu()
      -> idr_alloc(..., bo_priv->idr_handle, ...)

In both cases, the restored ID comes from userspace-provided CRIU data.

idr_alloc() expects the ID range values to fit within signed int
limits. If a restored ID is larger than INT_MAX, it can trigger a WARN
in the IDR layer.

A kernel WARN is undesirable because it prints a warning trace and may
cause a panic or reboot on systems with panic_on_warn enabled.

Smatch reported these paths as allowing unchecked userspace values to
reach idr_alloc().

Add INT_MAX validation before using restored IDs in:

- kfd_criu_restore_event()
- criu_restore_memory_of_gpu()

If the restored ID is invalid, return -EINVAL.

This prevents invalid restore data from reaching the IDR layer and
avoids WARN-triggering paths, while keeping valid restore behavior
unchanged.

Fixes: 40e8a766a761 ("drm/amdkfd: CRIU checkpoint and restore events")
Reported-by: Dan Carpenter <error27@gmail.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: David Yat Sin <david.yatsin@amd.com>
Cc: Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: David Yat Sin <david.yatsin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 3 +++
 drivers/gpu/drm/amd/amdkfd/kfd_events.c  | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 09ebfe8a30628d..c2100fd78b522b 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -2315,6 +2315,9 @@ static int criu_restore_memory_of_gpu(struct kfd_process_device *pdd,
 	const bool criu_resume = true;
 	u64 offset;
 
+	if (bo_priv->idr_handle > INT_MAX)
+		return -EINVAL;
+
 	if (bo_bucket->alloc_flags & KFD_IOC_ALLOC_MEM_FLAGS_DOORBELL) {
 		if (bo_bucket->size !=
 				kfd_doorbell_process_slice(pdd->dev->kfd))
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
index 261db87e86fe63..63039035b19412 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -480,6 +480,11 @@ int kfd_criu_restore_event(struct file *devkfd,
 	}
 	*priv_data_offset += sizeof(*ev_priv);
 
+	if (ev_priv->event_id > INT_MAX) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
 	if (ev_priv->user_handle) {
 		ret = kfd_kmap_event_page(p, ev_priv->user_handle);
 		if (ret)
-- 
2.53.0



