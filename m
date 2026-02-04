Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39D4223323;
	Wed,  4 Feb 2026 14:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216823; cv=none; b=iPhOZK3CVyLneHBBLXDMhyjD67S6XfhITlm4/M4zkAl4PhfvH3OvQ3gl5vTIMH0JMRf6V38PZwoDupBJEGFUo/ybKd6k/vL63ktMjrkT1rVDQTjT+daCoHNR+6GXJNxnS9RjS+m11aH2KNtNxJO4rOTPNYakPi6TxYDdsAcuO10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216823; c=relaxed/simple;
	bh=RaWDu2BHUtigv1V6wdi5qocO/zwieVbCTiglU0ZSG1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BD5gaT8n/PM6MuL6lUnYlfGVaFrpT7fz+nriFfOzU/qfAXUsyB3zSs+7WBwp0QZ8t191Ulc1kD00A2/oGdgP0ZwccSgqpyBsz6msW/dpwsoonUpi0T+4IZm0Fn5J3uZesr03e2PZNuISop440DFf2RyVLfykqFstWYwz4rYcoGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UISTYtxr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UISTYtxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6186EC4CEF7;
	Wed,  4 Feb 2026 14:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216822;
	bh=RaWDu2BHUtigv1V6wdi5qocO/zwieVbCTiglU0ZSG1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UISTYtxrICM9npqB1pKasL7t2K7VLXvX7/53nmHYKUPuMEDg3fLI/Jv2NbTdHLlUV
	 SXV0M2mztd2RQ5+6MslE2BJHeRVb3Zjk8so3XvUXkb0e33wu5jd18V7I9cGbF5IJnF
	 6xDIUAS1/QiepCy1eduvxW82Nk/iYwq4Jdc1cRbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kent.russell@amd.com,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 041/206] drm/amd: Clean up kfd node on surprise disconnect
Date: Wed,  4 Feb 2026 15:37:52 +0100
Message-ID: <20260204143859.691255047@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

commit 28695ca09d326461f8078332aa01db516983e8a2 upstream.

When an eGPU is unplugged the KFD topology should also be destroyed
for that GPU. This never happens because the fini_sw callbacks never
get to run. Run them manually before calling amdgpu_device_ip_fini_early()
when a device has already been disconnected.

This location is intentionally chosen to make sure that the kfd locking
refcount doesn't get incremented unintentionally.

Cc: kent.russell@amd.com
Closes: https://community.frame.work/t/amd-egpu-on-linux/8691/33
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6a23e7b4332c10f8b56c33a9c5431b52ecff9aab)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3999,6 +3999,14 @@ void amdgpu_device_fini_hw(struct amdgpu
 
 	amdgpu_irq_fini_hw(adev);
 
+	/*
+	 * device went through surprise hotplug; we need to destroy topology
+	 * before ip_fini_early to prevent kfd locking refcount issues by calling
+	 * amdgpu_amdkfd_suspend()
+	 */
+	if (drm_dev_is_unplugged(adev_to_drm(adev)))
+		amdgpu_amdkfd_device_fini_sw(adev);
+
 	amdgpu_device_ip_fini_early(adev);
 
 	amdgpu_gart_dummy_page_fini(adev);


