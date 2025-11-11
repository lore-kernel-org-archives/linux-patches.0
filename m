Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33FA1C4A24;
	Tue, 11 Nov 2025 01:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824684; cv=none; b=P9OLSdO489PUbkJPzWYWdyURCYRyCaUKvnAUVsU8R89M5LD7T2UnV78Lypzw79MZrdDvTocqVrJNyxkXrZTwdYgDbHae9AkfdXbUDVThwldyCV1NevWvHmzjnNWwZFyoh2f7GZ4lbzgueONVsWUmWCaiqmuYKZrtac+zIZxJRTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824684; c=relaxed/simple;
	bh=L5BXdPRY6l+a7/wnxJuhMCUJr109/IPtshG8S7bKvso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKc1b+zNKhFzK3dlOMt3gB1O37Q44C1kyAeCAeXZ+hCd4z11mv7n8NJs3TK57TSMGAXuO+2Y3Q9RQiQnuAbABhPTTrPe59aEHu8ByhD8ciEUJx2x1HPQcFzIEuevZJ1N+J+1jZeBDYp5IJ6yZdrcrqp7czSsbfigcLgJQj9uWr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fslSfwt4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fslSfwt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC6FC19421;
	Tue, 11 Nov 2025 01:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824683;
	bh=L5BXdPRY6l+a7/wnxJuhMCUJr109/IPtshG8S7bKvso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fslSfwt4Y6VeoSmLyckvO5hImBcDd+cOsiWNaw9JdYB4SRXsaJeBanNw0HiccvHde
	 yKkmvdT4vOSocueUhLaMrV+EdEzuKCcRNyU9HhUvC98vEo16XhwEz3goJl/AspBOOj
	 7xF3DVpswjYV6c5IDzMonDOW+j/5DKTJ6VrvDFp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Ce Sun <cesun102@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 550/849] drm/amdgpu: Release hive reference properly
Date: Tue, 11 Nov 2025 09:42:00 +0900
Message-ID: <20251111004549.703042603@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit c1456fadce0c99175f97e66c2b982dd051e01aa2 ]

xgmi hive reference is taken on function entry, but not released
correctly for all paths. Use __free() to release reference properly.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Ce Sun <cesun102@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 7 +++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.h   | 4 ++++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 274bb4d857d36..56a737df87cc7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -6880,7 +6880,8 @@ pci_ers_result_t amdgpu_pci_error_detected(struct pci_dev *pdev, pci_channel_sta
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
 	struct amdgpu_device *adev = drm_to_adev(dev);
-	struct amdgpu_hive_info *hive = amdgpu_get_xgmi_hive(adev);
+	struct amdgpu_hive_info *hive __free(xgmi_put_hive) =
+		amdgpu_get_xgmi_hive(adev);
 	struct amdgpu_reset_context reset_context;
 	struct list_head device_list;
 
@@ -6911,10 +6912,8 @@ pci_ers_result_t amdgpu_pci_error_detected(struct pci_dev *pdev, pci_channel_sta
 		amdgpu_device_recovery_get_reset_lock(adev, &device_list);
 		amdgpu_device_halt_activities(adev, NULL, &reset_context, &device_list,
 					      hive, false);
-		if (hive) {
+		if (hive)
 			mutex_unlock(&hive->hive_lock);
-			amdgpu_put_xgmi_hive(hive);
-		}
 		return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
 		/* Permanent error, prepare for device removal */
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.h
index bba0b26fee8f1..5f36aff17e79e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.h
@@ -126,4 +126,8 @@ uint32_t amdgpu_xgmi_get_max_bandwidth(struct amdgpu_device *adev);
 
 void amgpu_xgmi_set_max_speed_width(struct amdgpu_device *adev,
 				    uint16_t max_speed, uint8_t max_width);
+
+/* Cleanup macro for use with __free(xgmi_put_hive) */
+DEFINE_FREE(xgmi_put_hive, struct amdgpu_hive_info *, if (_T) amdgpu_put_xgmi_hive(_T))
+
 #endif
-- 
2.51.0



