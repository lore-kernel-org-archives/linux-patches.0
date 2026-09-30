Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE9A5172E9;
	Wed, 30 Sep 2026 18:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793737; cv=none; b=pdXF7iH8MLt2zQN8iM7Zw1k0gOxs7bcDjqYZglmPm+O1+BnmmtQ1ELe2c1w0t+fLziE9olMAFr+YueoRJHQQsGEIx8kR9McxjnZLcpyjuxzsUeDtS6AP75+1pVZTsuGE0RjSLi+1Wl0E8a5PQmdm14o0NM8TkfrRd7MoyXmcZoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793737; c=relaxed/simple;
	bh=ymiJiNbN9GAI63SP5XO1bXO4PdVXge7f6TaY3AWV2go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nl42XE4+4CuuCFZ9IL2p/yf0Z+CTEY5rFr/xz+Y6IfmBnohHnnqkmuwA1KSwPNymj4Vd7d55wd6DyAEaAPIToiit57LeVCEFfa8E/RbYkmYsLU9KwxQN8rpPGfdGv3KY8pmE8BStqWf6he1WB8ZtddimOx45J7MGTiwDusL9vVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VFFbTN9i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VFFbTN9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C4C1F000FF;
	Wed, 30 Sep 2026 18:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793736;
	bh=nMrMJHJ+EanD3ibJnjA61l4nIPO6ie3wbUT68auGeOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VFFbTN9ijS0duFLBuodxH2RFxmk/FyIOqqEm4j1R8uPnrHrO1f/pNHBB5ObQu843X
	 OVIHRngnEN1yHrO+bn5knvPtV93wwP7Z8p38M0pVgqhIaQeR7F91f1KYC/8UtLORbb
	 X46psW/QPNHrkjqGe1IWiJu/7lxasEEMMjCuMh40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 358/395] drm/amdgpu: Fix acpi device leak in amdgpu_acpi_enumerate_xcc()
Date: Wed, 30 Sep 2026 17:30:20 +0200
Message-ID: <20260930152348.451762851@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit a997baa61179b450bd55c4810c7ccfed3b753a54 ]

amdgpu_acpi_enumerate_xcc() looks up each XCC ACPI device with
acpi_dev_get_first_match_dev(), which takes a reference to the device.
The reference is dropped with acpi_dev_put() after the XCC info is
initialized, but if the kzalloc_obj() allocation of the XCC info fails
the function returns -ENOMEM without releasing the reference, leaking
the last reference to the ACPI device.

Drop the ACPI device reference on the allocation failure path before
returning.

Fixes: 4d5275ab0b18 ("drm/amdgpu: Add parsing of acpi xcc objects")
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9211ef48b31ec66999cf55e04d0cbc60cd855fd5)
Cc: stable@vger.kernel.org
[ adapted the hunk to the existing kzalloc() failure block with braces and DRM_ERROR() logging. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -1118,6 +1118,7 @@ static int amdgpu_acpi_enumerate_xcc(voi
 				   GFP_KERNEL);
 		if (!xcc_info) {
 			DRM_ERROR("Failed to allocate memory for xcc info\n");
+			acpi_dev_put(acpi_dev);
 			return -ENOMEM;
 		}
 


