Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B08D277C98;
	Tue, 21 Oct 2025 20:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077396; cv=none; b=N8MgD+CMdwNh8i4ebPo2W2S4A0BPKc48pmOOiiJBcY5kcY8Qlrf30vdp0eydZcZdhqILC4KNzGVmnaJyPtKx2ya/Fyh7OJwtwTKgbQw1IQQSMbutrXu34N8EwIHkuhMCOkOtZeNioIP1wFqICBLlbyLADpaaHEjW+8ScQSQqZwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077396; c=relaxed/simple;
	bh=hPxB43mV+c6hSKC36YemSQcVRl6Tp6VpFryBErSQUsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNu7bTAZrUhTlUHnzCICGy3ABCDNiVBns2Zu0qWWMOLj5dbS9fTD10Dv/LprSHN18u8H7hII+HJ/CnXvh/q8kFk4RfV9i/9Vgo5K+vaOivvVLdOT7Zw9gaq5JBlQMPFLNdcng1ZrWSXBYofCt4T3UqFGONIMZbin8thzOYjiVFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jbT+aTo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jbT+aTo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E840C4CEF1;
	Tue, 21 Oct 2025 20:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077395;
	bh=hPxB43mV+c6hSKC36YemSQcVRl6Tp6VpFryBErSQUsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbT+aTo1DYgX/U893FpCrKPRjBvTY6vItxh4Fa60GFvOI8+UzTTlZCR/nEKu1b3A5
	 gOfZbuJLjXdU/H5o1eanb0ZTP0czoC0Wpm274MHGBuo4l8yYNdgxazvUM2oUXgIOrG
	 8+gAwcAsoNcjiuvXKdfLH2eqrydjV73nEFvCry58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ionut Nechita <ionut_n2001@yahoo.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Kenneth Crudup <kenny@panix.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 049/159] drm/amd: Fix hybrid sleep
Date: Tue, 21 Oct 2025 21:50:26 +0200
Message-ID: <20251021195044.391865975@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

From: "Mario Limonciello (AMD)" <superm1@kernel.org>

[ Upstream commit 0a6e9e098fcc318fec0f45a05a5c4743a81a60d9 ]

[Why]
commit 530694f54dd5e ("drm/amdgpu: do not resume device in thaw for
normal hibernation") optimized the flow for systems that are going
into S4 where the power would be turned off.  Basically the thaw()
callback wouldn't resume the device if the hibernation image was
successfully created since the system would be powered off.

This however isn't the correct flow for a system entering into
s0i3 after the hibernation image is created.  Some of the amdgpu
callbacks have different behavior depending upon the intended
state of the suspend.

[How]
Use pm_hibernation_mode_is_suspend() as an input to decide whether
to run resume during thaw() callback.

Reported-by: Ionut Nechita <ionut_n2001@yahoo.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4573
Tested-by: Ionut Nechita <ionut_n2001@yahoo.com>
Fixes: 530694f54dd5e ("drm/amdgpu: do not resume device in thaw for normal hibernation")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Tested-by: Kenneth Crudup <kenny@panix.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Cc: 6.17+ <stable@vger.kernel.org> # 6.17+: 495c8d35035e: PM: hibernate: Add pm_hibernation_mode_is_suspend()
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2665,7 +2665,7 @@ static int amdgpu_pmops_thaw(struct devi
 	struct drm_device *drm_dev = dev_get_drvdata(dev);
 
 	/* do not resume device if it's normal hibernation */
-	if (!pm_hibernate_is_recovering())
+	if (!pm_hibernate_is_recovering() && !pm_hibernation_mode_is_suspend())
 		return 0;
 
 	return amdgpu_device_resume(drm_dev, true);


