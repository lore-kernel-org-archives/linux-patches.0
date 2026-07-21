Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34C144AB88;
	Tue, 21 Jul 2026 21:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668745; cv=none; b=uK/HLO2dwYkmURbbV0mu9rJlJa8s7yy+NihEmAZWW7hbYV52pXbADpb69qWksC/aCUWRtGWHqhE4dB0jE9PFuO36UjK8HY/QdCM4k6o3I0lTNGnEOPELqZ4vyse5pwIbQzTpdQdzgG2Q9+UVff1xj1VBMaRzgVQSW7I3lpzKuPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668745; c=relaxed/simple;
	bh=CsmmKAiK5V9n2NHv7K7NnxZZo+gxuCinxgqSCTH7e4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbl14hUBmIls2+cLLYBbnCcwql4sUc6QX1SCKArFpK7qDAGlqDI7enpSqPROsO14xCo2HYrP7BwCiQ+S6RBK2WQsuxaK/sB1Elz43PyEuQNegK5oIryAo/Ao2KTMuZeLuHf3uWt7XQaanKwdnau+7EkIg9Rw2BonN9llJaUbLVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KEdVQB4/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KEdVQB4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B921F000E9;
	Tue, 21 Jul 2026 21:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668744;
	bh=HUTWBQPflxVYrdqeHk8mxlqiNVyiwFcGoYsoqoz6S1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KEdVQB4/BCXbA5TywyIv9gHusGXDm6EGaiEPIhT1OS7d7vGNSwj9q0IEcAwV55/tJ
	 /HTq7KQscdGl//0atOHEqnuYrBzzqltFelVQBFxuXBiVXXALkyqdlw69Dv7GWPEh7z
	 2o9eGWkE8PKq6K78my9TFs6oU3kdKzY4YngXHIJo=
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
Subject: [PATCH 6.1 0285/1067] drm/amdkfd: Validate CRIU-restored IDs before idr_alloc
Date: Tue, 21 Jul 2026 17:14:46 +0200
Message-ID: <20260721152430.977908673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2002ab2f14ab1c..4853a8b43f08b4 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -2233,6 +2233,9 @@ static int criu_restore_memory_of_gpu(struct kfd_process_device *pdd,
 	const bool criu_resume = true;
 	u64 offset;
 
+	if (bo_priv->idr_handle > INT_MAX)
+		return -EINVAL;
+
 	if (bo_bucket->alloc_flags & KFD_IOC_ALLOC_MEM_FLAGS_DOORBELL) {
 		if (bo_bucket->size != kfd_doorbell_process_slice(pdd->dev))
 			return -EINVAL;
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
index 14f1f14e16d73e..3f4cb39c852525 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -478,6 +478,11 @@ int kfd_criu_restore_event(struct file *devkfd,
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



