Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B6244C4F8;
	Thu, 30 Jul 2026 16:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427941; cv=none; b=UmeeZgwAk7/wJ6ceozDi7Ig9nhGD9CXn65PVLvbcJ1FZ9oUzr18rOi9TfommTMoNvDPhMDzoubyZ0mzNMlDMKvHmJlBK9bATinDndjUfmf2gRuviZS19P+LgsbFU1ywDca7DuYmSH642kHXt6uXfGAzxI3QLHmrAFQjctfnvgUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427941; c=relaxed/simple;
	bh=b91AEVANxXZZnVIbdx9wB6CXOhaB0frau2A2pbAG4So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9CclEQY29dWBUHGnIuL17od6oWyJN2GVpK671xOWUlMODYDBvrolluxk4dVJECUbaQlIN8C8E59EiZdVAPq1atldGg89PfV0D0oJMc8JfL9gPLl1NvwE7+h+iiopgSNXxkzi7RF2QbtoxPbnOONatOYTkPx/5wOU/LDYrU6u60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lnO0fM9n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lnO0fM9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E301F000E9;
	Thu, 30 Jul 2026 16:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427940;
	bh=9UdceSho0qlK3bXZlXJ9D/MCajT1IlWaK+SM7RVYIFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lnO0fM9nTxa3dbg/KefmRDZIt3oYoPAvLvW6VHr7QzmiBjWhSuxdWDop097Wi7O91
	 kMu4Tl5EuNPBzk0sM5LryN/sllgYPa0AtuGp1tCopl8ahPl2bYuYu2yJtmTL0zHWzb
	 L30m0rSAnPXml/2MYOstUn7GIaPQ6r0/7EOIdZtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ce Sun <cesun102@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 347/484] drm/amdgpu: invoke pm_genpd_remove() before freeing genpd
Date: Thu, 30 Jul 2026 16:14:04 +0200
Message-ID: <20260730141431.019849421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Ce Sun <cesun102@amd.com>

commit 28c9b3c5dc35cc790d11e26ca3fc6e068be63998 upstream.

Call pm_genpd_remove() to unregister from global list prior to releasing
acp_genpd memory, and clear the pointer after free.

Signed-off-by: Ce Sun <cesun102@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit cd8650d7a91ee8b768e202354672553faa5cc1f2)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
@@ -559,7 +559,9 @@ static int acp_hw_fini(void *handle)
 
 	mfd_remove_devices(adev->acp.parent);
 	kfree(adev->acp.acp_res);
+	pm_genpd_remove(&adev->acp.acp_genpd->gpd);
 	kfree(adev->acp.acp_genpd);
+	adev->acp.acp_genpd = NULL;
 	kfree(adev->acp.acp_cell);
 
 	return 0;


