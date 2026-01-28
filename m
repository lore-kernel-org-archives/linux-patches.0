Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBD123EAB7;
	Wed, 28 Jan 2026 15:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614337; cv=none; b=qLofsnDUZPHzAIlYIQSOdmcs91HiAlAxm0VkIkb8khnDH+4CxYZLyLiODIZQiVQnxf6q+yuHx/Svt9SoGGUulx4Fux4JfGyc+8S8PxSBpdOVjHNyycmoJIsJfCX/L2vzhFvXM1rp5ruJ+3yAL8yhWa066HnLLUdezFnmOdHFVsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614337; c=relaxed/simple;
	bh=K+eT9P4bnp/Kor1wZvz65TJKuafK1iAZX7Yr5svUE7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiwf6rmDHj6hCeFZFT5Jx6FKVZLAjEFNyp62yhR2yIGPV56hvIIBCS7TJ1ot2I3ucFnvPNX82V4epjjRpsvksQPwsgKFzZK8G5uNvJahzwurOrBbPi2u0G0x8DcfSUdd332WArr1mVcyUnBiBT0B6TK6zkS8U9zGTt0Hqufob7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/su6UTn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/su6UTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DB7C4CEF1;
	Wed, 28 Jan 2026 15:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614337;
	bh=K+eT9P4bnp/Kor1wZvz65TJKuafK1iAZX7Yr5svUE7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/su6UTnGXn/YbRdb0dkyj6K+CTQ/fqAuTvMHbFWpL5iKJrpvMPGE9Ghz2XKWzwTO
	 GJ1KRol2/Ws3a5K8ZcU+LfvnWAJTE+DysPLJ5ZXbkNgVH7qwe7rpsnE/wPHxuZWKa3
	 wgBWYwDgiJ9mb2aFpEkBGq0lcwAfxxJOROFRdREI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kent.russell@amd.com,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 073/254] drm/amd: Clean up kfd node on surprise disconnect
Date: Wed, 28 Jan 2026 16:20:49 +0100
Message-ID: <20260128145347.322641430@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4029,6 +4029,14 @@ void amdgpu_device_fini_hw(struct amdgpu
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


