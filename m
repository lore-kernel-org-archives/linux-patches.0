Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73AD436BC6;
	Tue, 21 Jul 2026 19:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661467; cv=none; b=Nu/EgRXMqPJtKLLzgBQYJp/zIagkXRvdufHv+zRRlOnIp2OrnJI37gz/xWpPyc+EaudJBBsTlwlz1HvQ3Q9XxuQso352au7Z1qa0YQIaedHBKQhTocifzT01gIzVP8SmVpU/ooKeHBrVxzZSYoENnlIzjn6Kea6lcc3pdcprLVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661467; c=relaxed/simple;
	bh=3z7x1ENI0dsxWEGzH85R1faneoZeu/WGtBFQXyuAw1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qb/EZTVhaDZhfvF+bFlhb84JJbt+2v7ZfknvW/Lh5CVVQDmQ0RJHOm8AmuLAWLGz1SdmQu7ItOYr4AkaCRTmJtm/ImPNGA1tWWkkSnCA4eOeLUD/NCFF8bjfxlJuueErlOqh2ordOFZbqxoFui/kfQe2bx6K25P4NhOE4V6w+p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=085CohOA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="085CohOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7071F00A3D;
	Tue, 21 Jul 2026 19:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661465;
	bh=JyH9ARrAMQlKQZ2QuMQsff3MflwYHkdEcuvSImETkqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=085CohOAm2WzczvYXAyVDbHLb4Ur92tjabWCpK9mXSm8d0+jPdQOOwb+WjNqBhIij
	 /IlBYUgtK+nhqgdiyogEmocCNF/JypjTdFOUE/hPTxrJgGeTcpVL769ncGXGF/YqVz
	 /3SJnAsQGGDh64l/tVPlbsiIDfyTGAtE++IDOEMA=
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
Subject: [PATCH 6.12 0076/1276] drm/amdkfd: Validate CRIU-restored IDs before idr_alloc
Date: Tue, 21 Jul 2026 17:08:39 +0200
Message-ID: <20260721152447.795911829@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6bca87b99f7c32..e75ca4dfc6a9ac 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -2322,6 +2322,9 @@ static int criu_restore_memory_of_gpu(struct kfd_process_device *pdd,
 	const bool criu_resume = true;
 	u64 offset;
 
+	if (bo_priv->idr_handle > INT_MAX)
+		return -EINVAL;
+
 	if (bo_bucket->alloc_flags & KFD_IOC_ALLOC_MEM_FLAGS_DOORBELL) {
 		if (bo_bucket->size !=
 				kfd_doorbell_process_slice(pdd->dev->kfd))
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
index 4e5ae565628388..0b5f1e574afeee 100644
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



