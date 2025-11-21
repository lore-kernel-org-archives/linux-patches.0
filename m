Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669535CDF1;
	Fri, 21 Nov 2025 13:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732765; cv=none; b=iw6VeZf3WsK2IBZ76Dnf2cYhjDDbaYruKp/UzdVrEx9K1/H9tjAdbRoVuIzhMx+L0t5W0WOIlWVaeItZM5hCuGb8/VPohuQTKaNwyxRTjjJ7LOQ6qzJM66V3tBcjzAQfPl2L0iOq+yNuS6fMlOdNUhP+Mh1dRt5DjhO5wpezyZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732765; c=relaxed/simple;
	bh=I1x3lqETfl2KgB0w0B0fUtgDTfNoiGkJ3Phmjoj4+9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R/mEeU8eRE3lln8y5wVmu/Vrb7tZq/zCaJH4T1cU4hyjJlLasZX0lJ6pwxjygrrqR+ZZRT5gbVw+ofu2lMtzI+2aGZeNOYhMj6iIA9feTxHrZqNx2ZlzQHdLvrOH52t4siAH4ohtsPDYUbYeCCKillNX/Y6XvMQa12ZmbHUjS84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0Xf0O8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0Xf0O8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F102C116C6;
	Fri, 21 Nov 2025 13:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732765;
	bh=I1x3lqETfl2KgB0w0B0fUtgDTfNoiGkJ3Phmjoj4+9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0Xf0O8l/lfVBp3cl8kV91Xpy4YggL8K2RCGz5jjzvvK/XkKZ0z2r6C0qEapYULxh
	 KMON2CFtZ52yZgTIYewNHnQ+PkreOBRF5nhqGBKzg4eCxPZ9bRXBvKuTz9sqsP4h92
	 C+X8EiJkLyqNwL6A7u+DnbBlFaXXr0FTn/pmbxHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AceLan Kao <acelan.kao@canonical.com>,
	Kai-Heng Feng <kaihengf@nvidia.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Denis Benato <benato.denis96@gmail.com>,
	=?UTF-8?q?Merthan=20Karaka=C5=9F?= <m3rthn.k@gmail.com>,
	Eric Naim <dnaim@cachyos.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 234/529] drm/amd: Avoid evicting resources at S5
Date: Fri, 21 Nov 2025 14:08:53 +0100
Message-ID: <20251121130239.345199187@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit 531df041f2a5296174abd8292d298eb62fe1ea97 ]

Normally resources are evicted on dGPUs at suspend or hibernate and
on APUs at hibernate.  These steps are unnecessary when using the S4
callbacks to put the system into S5.

Cc: AceLan Kao <acelan.kao@canonical.com>
Cc: Kai-Heng Feng <kaihengf@nvidia.com>
Cc: Mark Pearson <mpearson-lenovo@squebb.ca>
Cc: Denis Benato <benato.denis96@gmail.com>
Cc: Merthan Karakaş <m3rthn.k@gmail.com>
Tested-by: Eric Naim <dnaim@cachyos.org>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 475d93d4a40bf..b2a1dc193cb8f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4113,6 +4113,10 @@ static int amdgpu_device_evict_resources(struct amdgpu_device *adev)
 	if ((adev->in_s3 || adev->in_s0ix) && (adev->flags & AMD_IS_APU))
 		return 0;
 
+	/* No need to evict when going to S5 through S4 callbacks */
+	if (system_state == SYSTEM_POWER_OFF)
+		return 0;
+
 	ret = amdgpu_ttm_evict_resources(adev, TTM_PL_VRAM);
 	if (ret)
 		DRM_WARN("evicting device resources failed\n");
-- 
2.51.0



