Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E23B3AE198;
	Wed, 23 Sep 2026 14:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174119; cv=none; b=DqjMplO09DdDvBn+7id9FyXO2oCgiv/O01g95EUxAStW2Om978xE6yUj+1OyU1cZrpyyH0vk4WY0KKG3TFnZAQDeWkRGcSt2VblPG2vj0M4mvRMAYqPxm05f/bhz0zm8clvrg+p4kYwWSkgqIgUOLlA6fjhvgCKKLv89sdCfqR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174119; c=relaxed/simple;
	bh=BsLn56d3jI98MIrrtFYZi64cfHowadmRL4ibUhqqNaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZwfkIvoQpyoLiqIpx6W2Z8sc7MwvZ+xM0AtlWZSQ6QSgcaMhs7dSZSES4R98McZmxohykV/a837HhFiHzJ0biYDiCe7ZiDvZRvAQnQD2ZvYVulSZtNZVZaKPoRDKmIj+LTF8IG1QX5FSRCPVP6miCgWWY8Ly/OvPA/qo1Bk1Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkKwsA65; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkKwsA65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A0F1F000FF;
	Wed, 23 Sep 2026 14:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174118;
	bh=srnhmeNLdN9ih8cUBN4hkiQQE49B2CWiNmtSnCQTepw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rkKwsA65E12xYtc8S7aEjG8xG0nb+SheJE495o9Q+a7tGz7ZwsnI0wFym329wHEEl
	 IO0lDP/YNXFf/VhjHCwOz5lICq4yCFtCpLO1L01rAQIC2u3hwVqslxCUGL8U1dg2+P
	 ZYvio7g+rPs/ocOTVjVp08pGjI/APIiV1KZIXW0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 7.2 409/438] drm/amdgpu: Skip KFD mapping clear before initialization
Date: Wed, 23 Sep 2026 16:07:10 +0200
Message-ID: <20260923140655.506657978@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 7f9caa70aef0950e06d395ca0035831214d88187 upstream.

amdgpu_amdkfd_clear_kfd_mapping() assumes that a non-NULL kfd_dev
has a fully populated node array. This is not true when KFD device
initialization fails after probe.

For example, kgd2kfd_device_init() sets num_nodes before checking
PCIe atomics support. On Polaris systems without the required atomics,
it returns before allocating nodes[0], but the kfd_dev remains attached
to the amdgpu device. A later GPU reset then dereferences nodes[0]->id.

Require the authoritative KFD initialization flag before walking the
node array, matching the existing KFD reset and teardown paths.

Fixes: 70cadefcc616 ("drm/amdgpu: unmap all user mappings of framebuffer and doorbell before mode1 reset")
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5833
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4ac1835823c47903fbb278bbf474773c46f59edc)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -329,7 +329,7 @@ void amdgpu_amdkfd_clear_kfd_mapping(str
 	struct kfd_dev *kfd = adev->kfd.dev;
 	unsigned int i;
 
-	if (!kfd)
+	if (!kfd || !kfd->init_complete)
 		return;
 
 	for (i = 0; i < kfd->num_nodes; i++) {


