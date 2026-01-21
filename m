Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0535828000F;
	Wed, 21 Jan 2026 18:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020413; cv=none; b=JnmZJC6xs64q37WZZ6SULNOJZMq9uOI0l4d0sxGTtoymb6fXm+DG8mUVnz8GcBMHgY/Rf24U9hjIwKzv2ciR4PSfNpDzqe2n6BowsVc931F//ktnagHh1Xm0quVHnHGuevB0Xi8B/KGYkpqDHOmstDpygGS7FOKnNm1C5W8IuTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020413; c=relaxed/simple;
	bh=8Cc0/pkWQDoSosx+dP5peHLqi3qSLsPtmk11bqH9C8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2GTbADa0aAb+kADw4ZjQc4XxFKtdjRs06Y0P1cBu9346d7nn4p1TsTQ3JQzP+VlVHFVjmRPIK+ctrus8q4iDPhWuyDM0SP2F9igagMkDT17FnC0sfIgdxKAPcnV8fIwa1u59SW+4Fkk77ctRHzDEvH0xMa+LLgj4FhsaqeStDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzTJUDA5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzTJUDA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B6FC4CEF1;
	Wed, 21 Jan 2026 18:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020412;
	bh=8Cc0/pkWQDoSosx+dP5peHLqi3qSLsPtmk11bqH9C8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzTJUDA5/m8vxMLVhuECk4/AMz6gxmGaZt+nImGwjYYIJUSB4nl2SgqSZBmevd53D
	 EYzcfbRg7FxCfh2untM6z8XgL7EWIEaVc3EE2x1iS3yd1QDoyWeoGbbABY5l2jD1+s
	 oXYPpSVo24fzoIkdlqSVUzXc58WM5cKX9P9RCBUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kent.russell@amd.com,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 151/198] drm/amd: Clean up kfd node on surprise disconnect
Date: Wed, 21 Jan 2026 19:16:19 +0100
Message-ID: <20260121181423.990331874@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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
@@ -4985,6 +4985,14 @@ void amdgpu_device_fini_hw(struct amdgpu
 
 	amdgpu_ttm_set_buffer_funcs_status(adev, false);
 
+	/*
+	 * device went through surprise hotplug; we need to destroy topology
+	 * before ip_fini_early to prevent kfd locking refcount issues by calling
+	 * amdgpu_amdkfd_suspend()
+	 */
+	if (drm_dev_is_unplugged(adev_to_drm(adev)))
+		amdgpu_amdkfd_device_fini_sw(adev);
+
 	amdgpu_device_ip_fini_early(adev);
 
 	amdgpu_irq_fini_hw(adev);


