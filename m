Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B5D4218BB;
	Wed,  4 Feb 2026 15:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217592; cv=none; b=EWCYRpdFintNGO1rvdLKRn+04DHLOv1805q7cSpGiqlFjhRRu998mxUw5f07WOusLOB/ljYINIc892exKt2yVrycJSoQOzy7BSF9TW7d79CuEj1cTZD0Ikp6aPl6c9VhoU1EZRI6WGKZzvTpeRE/uYTwtAER1F3BrMdRUX5tgyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217592; c=relaxed/simple;
	bh=x7TOoUErqBmSKduDvgLK4Xwc9Vmk3fKT053BGx28rDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5gQewaiYPY2j7B3l2zON0G8fRbi9glN87hJk/1C/ZB1B9jzMIZk4e2RZrJLGy+Mn94RD8X6yKuHzZ92jFqh/yAOUEFiqHzJ4FtmW09GOB7ilJXMLuXnZmrnXyTENV61K5fVO3x+49eTo8tkVWQby1tgGdDtUvTCFwUhLvwamuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7cULtHT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7cULtHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FBB2C4CEF7;
	Wed,  4 Feb 2026 15:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217592;
	bh=x7TOoUErqBmSKduDvgLK4Xwc9Vmk3fKT053BGx28rDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7cULtHTUmmOqUqptjWZcdTbYH1sS6CL2jG6TpsuX1JYFk1zvGOv0tUHLx8i8N/Hi
	 iOMEyD+HcLCsPsMHlWCN8TptPnbXUCX5vY0WCKbKsYOLczvfsUhT3AuQSMZHcSR8e1
	 LU4LjdS41ulpxnXVY1YtbIAeQXaIC5CPeS7Mowpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kent.russell@amd.com,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 062/280] drm/amd: Clean up kfd node on surprise disconnect
Date: Wed,  4 Feb 2026 15:37:16 +0100
Message-ID: <20260204143911.886376244@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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
@@ -4102,6 +4102,14 @@ void amdgpu_device_fini_hw(struct amdgpu
 	/* disable ras feature must before hw fini */
 	amdgpu_ras_pre_fini(adev);
 
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


