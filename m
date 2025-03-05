Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBCB191493;
	Wed,  5 Mar 2025 18:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198210; cv=none; b=nm+QsO65Pz6V+ofJ/BMuMY9+HyD8MN3kCbzdgTqPi38z7COnWjAb9Kw4ORuEMhX7s3+r0yh2RTA3Zpuy3iHwX7oeqoTqtJCB3F7r6aGZD+HclN1MGsX75+PMfWZ6Q6UhXjRck6th+b2NAXKm1i5pzlGeN6YZAgmBL6WarYVsBUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198210; c=relaxed/simple;
	bh=SiHzlh97ycSW4y9BMN3L/sPyjdbUi+kxEj+SPPZHHKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIKsERVoiAwPdX9B99mbZP+RRUmF4Ce6jbwdTmoHm3aV+X5KNpUKdZbmfe+HMn8FWR1cYP8o+7c1+Rx+lOEHErelogz6stCZQYL34JLjibJzsX3mJqvbw3AYeIivLMWtPn4sHJNNcXGU24QAOriU6IY7qvgBf3xJyMYUphIZbKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c97rCHXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c97rCHXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF71C4CEE0;
	Wed,  5 Mar 2025 18:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198209;
	bh=SiHzlh97ycSW4y9BMN3L/sPyjdbUi+kxEj+SPPZHHKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c97rCHXzuHNu5HBp+HEaJEID2B+YJ42q7Tt7W/Bp/7HVtDz+t1WH45hLqjZQ4eXwa
	 mPSXz+/EJwDbPm9UtLLToDvTVXS0shgtpPF2kx+tbpXWx14Ly+RW8Pp2n0C83LlYBJ
	 W0058V3Dae0EdLYRAvS/ENzmm64mAL2sWrD5hHSU=
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
Subject: [PATCH 6.12 101/150] drm/amd/display: Fix HPD after gpu reset
Date: Wed,  5 Mar 2025 18:48:50 +0100
Message-ID: <20250305174507.871037274@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -894,6 +894,7 @@ void amdgpu_dm_hpd_init(struct amdgpu_de
 	struct drm_device *dev = adev_to_drm(adev);
 	struct drm_connector *connector;
 	struct drm_connector_list_iter iter;
+	int i;
 
 	drm_connector_list_iter_begin(dev, &iter);
 	drm_for_each_connector_iter(connector, &iter) {
@@ -920,6 +921,12 @@ void amdgpu_dm_hpd_init(struct amdgpu_de
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
@@ -935,6 +942,7 @@ void amdgpu_dm_hpd_fini(struct amdgpu_de
 	struct drm_device *dev = adev_to_drm(adev);
 	struct drm_connector *connector;
 	struct drm_connector_list_iter iter;
+	int i;
 
 	drm_connector_list_iter_begin(dev, &iter);
 	drm_for_each_connector_iter(connector, &iter) {
@@ -960,4 +968,10 @@ void amdgpu_dm_hpd_fini(struct amdgpu_de
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


