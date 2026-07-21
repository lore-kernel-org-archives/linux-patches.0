Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AE33998AF;
	Tue, 21 Jul 2026 17:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653627; cv=none; b=YjvrJNfC9hxtwtKgB1JJB+KoTnNfMK0X0bKYjriWndbXgUapsfibwcQDheUbCkRlbsFwMygr2l9EtWBZpvg7/iFfS0oS+VEWdkn1RHRGyMeijCW196Q8lxucpa36mXCqiULQ9bHevQ8TCh4EH0typLtE5A5+QqClwNjGrI8OiRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653627; c=relaxed/simple;
	bh=uEJ5Tuta4hGjISZm2UWQWZgS2AYCiCrN84eSl4HZg1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAI+DqVT1sk9wUQzp97BssrfbW5TIY21M5opRIpYriNdFrAvXAvsLvQUCqdnhB6eWC+lYny6/JP9K0uqqcXcZdw5EiEJ+rYTzIDoexQLtTWU+J3BCIYt02MATtrS+JfUmAgshoSg32e0WC/hjfmhrEc8CLChJViC8FD8dp8aGy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFORXAu+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFORXAu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9F51F000E9;
	Tue, 21 Jul 2026 17:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653626;
	bh=QsHUilXRTXdXxyYMe6uFG+hSpIH/wggZt74cwQ3Or+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LFORXAu+meVlGGvcXa3DBOMf4gVvsGRyQcdvbiOaR4xgsabcTHg6pnqY0BviHQMXY
	 bdUUQh2kbEjpXUwu9ttOxtxkfLzO1GBHS0T/z0HUqDQEZA2lCb/f25UPGkqKM/Gn0K
	 fwYAMefQinWr5nH3Hab6HD5fhk3QgOWqtBLv4zCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brajesh Gupta <brajesh.gupta@imgtec.com>,
	Alessio Belle <alessio.belle@imgtec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1399/2077] drm/imagination: Fix returned size for DRM_IOCTL_PVR_DEV_QUERY
Date: Tue, 21 Jul 2026 17:17:52 +0200
Message-ID: <20260721152625.807908973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brajesh Gupta <brajesh.gupta@imgtec.com>

[ Upstream commit d431b4012fd22920523dbd2806da663c1048e386 ]

For a few subtypes of DRM_IOCTL_PVR_DEV_QUERY, driver was overriding
the returned size unconditionally. This would have resulted in
increase of reported size beyond the amount of data returned to
userspace when args->size < size of query structure.

Updated behaviour matches with the description of
drm_pvr_ioctl_dev_query_args.size and written byte length.
None of the structures of DRM_IOCTL_PVR_DEV_QUERY changed after addition,
so change will not break any compatibility with earlier version.

Fixes: f99f5f3ea7ef ("drm/imagination: Add GPU ID parsing and firmware loading")
Fixes: ff5f643de0bf ("drm/imagination: Add GEM and VM related code")
Signed-off-by: Brajesh Gupta <brajesh.gupta@imgtec.com>
Reviewed-by: Alessio Belle <alessio.belle@imgtec.com>
Link: https://patch.msgid.link/20260701-b4-b4-query-v2-1-a1b491387875@imgtec.com
Signed-off-by: Alessio Belle <alessio.belle@imgtec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imagination/pvr_drv.c | 6 ++++--
 drivers/gpu/drm/imagination/pvr_vm.c  | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/imagination/pvr_drv.c b/drivers/gpu/drm/imagination/pvr_drv.c
index 268900464ab693..cfb67f77bde6cb 100644
--- a/drivers/gpu/drm/imagination/pvr_drv.c
+++ b/drivers/gpu/drm/imagination/pvr_drv.c
@@ -514,7 +514,8 @@ pvr_dev_query_quirks_get(struct pvr_device *pvr_dev,
 	if (err < 0)
 		return err;
 
-	args->size = sizeof(query);
+	if (args->size > sizeof(query))
+		args->size = sizeof(query);
 	return 0;
 }
 
@@ -595,7 +596,8 @@ pvr_dev_query_enhancements_get(struct pvr_device *pvr_dev,
 	if (err < 0)
 		return err;
 
-	args->size = sizeof(query);
+	if (args->size > sizeof(query))
+		args->size = sizeof(query);
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/imagination/pvr_vm.c b/drivers/gpu/drm/imagination/pvr_vm.c
index e1ec60f34b6e64..396d349fb6ce48 100644
--- a/drivers/gpu/drm/imagination/pvr_vm.c
+++ b/drivers/gpu/drm/imagination/pvr_vm.c
@@ -1019,7 +1019,8 @@ pvr_static_data_areas_get(const struct pvr_device *pvr_dev,
 	if (err < 0)
 		return err;
 
-	args->size = sizeof(query);
+	if (args->size > sizeof(query))
+		args->size = sizeof(query);
 	return 0;
 }
 
@@ -1069,7 +1070,8 @@ pvr_heap_info_get(const struct pvr_device *pvr_dev,
 	if (err < 0)
 		return err;
 
-	args->size = sizeof(query);
+	if (args->size > sizeof(query))
+		args->size = sizeof(query);
 	return 0;
 }
 
-- 
2.53.0



