Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C54536B05B;
	Wed, 21 Jan 2026 18:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019868; cv=none; b=JGdr1A/zFoE1zLM//BohdmbGLsVw2L+Q2yilooujryAHHFdxxFjyhZqmdC4BAhou3G6GqDC0DIcBCNHbqfDcNYNglEe24UQ7MkunZadVFxo/d3WU01en+tbrX9+3CZVLvppjXknws31Mdu39hwjUdNzEIsgWjwk4abFqJ0R1v/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019868; c=relaxed/simple;
	bh=SpV4z/pDUY5dOoaLwXpvI55XQ1cfKhEzZ38sWzxJ15c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkEJtDUSqv2u9FRI5MMtRpViLtaUzLYIi2U03sjRbRfGyFQG6fMtazw+UK7NdFnCf+dRTs8C0AWvD6x1jxf6xPk/oTHHO4wv+Ct5CaTVUaZyY79KBh3yzKZIhvoLAuJYkgL8O8y9Sj99Q3QPxuLMLnxGGvccwFkLS+3TqsQ/Zms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQjQM+rb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQjQM+rb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35A4C4CEF1;
	Wed, 21 Jan 2026 18:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019868;
	bh=SpV4z/pDUY5dOoaLwXpvI55XQ1cfKhEzZ38sWzxJ15c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQjQM+rbz87LIT9ERCKVIc+LeOzHnCAbTG/0+eKqbtH8iyP4uOZtNMRLYQ2OEugNR
	 q+OxMw7Vm51Ckb/rVXLC1aNRkgdL1zERp/4Ybg+nFQ4m9O4oVMGShd3K9vlLa/Ww1r
	 JbLdyxhMhvYoCJhFfg1XSEOA24ec9qEhdSkKwgCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kent.russell@amd.com,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 099/139] drm/amd: Clean up kfd node on surprise disconnect
Date: Wed, 21 Jan 2026 19:15:47 +0100
Message-ID: <20260121181415.014971302@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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
@@ -4642,6 +4642,14 @@ void amdgpu_device_fini_hw(struct amdgpu
 
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


