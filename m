Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0512E6CA4;
	Tue, 11 Nov 2025 01:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824704; cv=none; b=jyaHh+LAIYB5OPbRj6FQvJeq+hai+Te+UoFhb2vgTwTKJXhta7+kETia9t6GXZ8RWMzwtnt982zgZcgWWu9RvLQBvtRo0M1TXmkPOaL2Dz5pXwoRAxxvIVvaTtQ70iF4jehyc+QkATxdwk25h0y+uGaSRe7VEo7GLGJMDya1VSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824704; c=relaxed/simple;
	bh=mPNRHLMw1NUjAflDT9gul4zv5Cz9MnOQIL6InIp3SR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s8A1pXpDaJhrFiPOi2dAVfLxy0Exq39eAy4c3rNFFmmS7pk02IbPt4dWWsVrlPbNiRCWP67MnOeAAFXW9xO6YshzPRzBhNcXq/bLteKhTwXKvNaqqLlGAwYlqb7KsLa6hwCThaTrSjSk7JaE7HR0wBXTfHqPEWyU/HzmbgdaMqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O01TN+7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O01TN+7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE90C4AF0B;
	Tue, 11 Nov 2025 01:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824704;
	bh=mPNRHLMw1NUjAflDT9gul4zv5Cz9MnOQIL6InIp3SR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O01TN+7GAovCFnoinlMoFgoQjs66PCAuoO/wmcA3LPkccpm1N/45Jlfafd9fzNuaV
	 kVcFrTvf4geR8AJi4CO5u3UxnNk+RU/l6CK5fK/5wbWeDp4KC3aOHwu7w8OnPkoI18
	 603P9qwRl0LsZXkaopQb64g3D/qLqMGe1h67Dji8=
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
Subject: [PATCH 6.17 554/849] drm/amd: Avoid evicting resources at S5
Date: Tue, 11 Nov 2025 09:42:04 +0900
Message-ID: <20251111004549.802337279@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 56a737df87cc7..1115af343e013 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5016,6 +5016,10 @@ static int amdgpu_device_evict_resources(struct amdgpu_device *adev)
 	if (!adev->in_s4 && (adev->flags & AMD_IS_APU))
 		return 0;
 
+	/* No need to evict when going to S5 through S4 callbacks */
+	if (system_state == SYSTEM_POWER_OFF)
+		return 0;
+
 	ret = amdgpu_ttm_evict_resources(adev, TTM_PL_VRAM);
 	if (ret) {
 		dev_warn(adev->dev, "evicting device resources failed\n");
-- 
2.51.0



