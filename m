Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E75A1C6FFE;
	Wed,  5 Mar 2025 17:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197433; cv=none; b=UfKiTXQ62DXAroSBNMvCOpdlCli7eV+gb/x32nVeSrUQITbUwSy/mR4N3lV/j+VEPHjPxsJEn2/WXIox984XAIq4clnF7z34fESBvGj6W+OoDpYNG8mC59a998Cbv6+k0ndKO215RxJ7pUq/4+pjlb90dxYgslIEBjdvjTfOnQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197433; c=relaxed/simple;
	bh=V/MylTiRv+TOgeMx4bRtLB6myAabBArIWcD263Y3xG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jT9eFmrxo66iHauJpLWqst9ltIgs23hNhZbPCGcUZ3qJyTclBYZsnNmFZrNl1n5gepJiSK0SZp+mQjxun32vtc9ZtJjHGLdCNogz3ivC/HlqxCEglz0DxLeBRrQQkIUP8ByKMWIdRJQ5ApJC4SCAvZ446Sld0/2X64a9z+myuoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmViddh4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmViddh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5311C4CED1;
	Wed,  5 Mar 2025 17:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197433;
	bh=V/MylTiRv+TOgeMx4bRtLB6myAabBArIWcD263Y3xG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmViddh4FWa1yv6zC4p1E9t65MLTkmsLlEsUpQdYwUiYcXpVzzo35djR/OjMpQySj
	 XL1E6fMhMatybkAeelVP+YglzySXvKgg6lojoWmMnqrTE2O5fgX64s+e0INzN6xF0/
	 L2h667pUurjzqlTXQiLXW9b6toca2E1NPxKwwoUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.1 154/176] drm/amd/display: Fix HPD after gpu reset
Date: Wed,  5 Mar 2025 18:48:43 +0100
Message-ID: <20250305174511.622683068@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Roman Li <Roman.Li@amd.com>

commit 4de141b8b1b7991b607f77e5f4580e1c67c24717 upstream.

[Why]
DC is not using amdgpu_irq_get/put to manage the HPD interrupt refcounts.
So when amdgpu_irq_gpu_reset_resume_helper() reprograms all of the IRQs,
HPD gets disabled.

[How]
Use amdgpu_irq_get/put() for HPD init/fini in DM in order to sync refcounts

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f3dde2ff7fcaacd77884502e8f572f2328e9c745)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
@@ -885,6 +885,7 @@ void amdgpu_dm_hpd_init(struct amdgpu_de
 	struct drm_device *dev = adev_to_drm(adev);
 	struct drm_connector *connector;
 	struct drm_connector_list_iter iter;
+	int i;
 
 	drm_connector_list_iter_begin(dev, &iter);
 	drm_for_each_connector_iter(connector, &iter) {
@@ -906,6 +907,12 @@ void amdgpu_dm_hpd_init(struct amdgpu_de
 		}
 	}
 	drm_connector_list_iter_end(&iter);
+
+	/* Update reference counts for HPDs */
+	for (i = DC_IRQ_SOURCE_HPD1; i <= adev->mode_info.num_hpd; i++) {
+		if (amdgpu_irq_get(adev, &adev->hpd_irq, i - DC_IRQ_SOURCE_HPD1))
+			drm_err(dev, "DM_IRQ: Failed get HPD for source=%d)!\n", i);
+	}
 }
 
 /**
@@ -921,6 +928,7 @@ void amdgpu_dm_hpd_fini(struct amdgpu_de
 	struct drm_device *dev = adev_to_drm(adev);
 	struct drm_connector *connector;
 	struct drm_connector_list_iter iter;
+	int i;
 
 	drm_connector_list_iter_begin(dev, &iter);
 	drm_for_each_connector_iter(connector, &iter) {
@@ -941,4 +949,10 @@ void amdgpu_dm_hpd_fini(struct amdgpu_de
 		}
 	}
 	drm_connector_list_iter_end(&iter);
+
+	/* Update reference counts for HPDs */
+	for (i = DC_IRQ_SOURCE_HPD1; i <= adev->mode_info.num_hpd; i++) {
+		if (amdgpu_irq_put(adev, &adev->hpd_irq, i - DC_IRQ_SOURCE_HPD1))
+			drm_err(dev, "DM_IRQ: Failed put HPD for source=%d!\n", i);
+	}
 }


