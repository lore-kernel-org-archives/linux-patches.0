Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B2427FD4F;
	Wed, 23 Apr 2025 15:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421335; cv=none; b=oF7CqDe9+XxmHg7n5J5+4c0OSn+DKfwMSRQK1/8d8SxRuVEb3yz+4UPK8HrURjUTa631sZKeaD1jqh0apdUI/GF0rL3WnBrGfPvPvQb1Ex5tvWrnWwOXEUZUcX6ABos2+kGSQwzX7gSZ1k6QAW8iPXCmK/xlUKsz8Q8kjUyIEBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421335; c=relaxed/simple;
	bh=TBOUkQ860d9y+MhKANkOEHtAXhiwPv+U8kMWAZJmcSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uaxu8TJGTjYdzArGqT6yuqWWmEkWhrqvx2JtfFWlfePT70p0QS2gxNzZcHA4uQn9o2CeWtmRhfR4EqHJRkX6o5HGRSWgCdjLLXDQnYnS2LC5moWGXwhpjB7P/Jh54cEKb5C9hblIUp9ovtMOqjw3cpx4JoV0aax7vESoQVSZeIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odwVNVVA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odwVNVVA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD296C4CEE2;
	Wed, 23 Apr 2025 15:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421335;
	bh=TBOUkQ860d9y+MhKANkOEHtAXhiwPv+U8kMWAZJmcSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odwVNVVA66DFXpmV7KTg871sIREYUduvG5dpNMRMhTNUI8XWoaLC46nRg54JSVlnE
	 v2MLl0a7c0uFlCG/mvkrjc5CjVXEts9E3/yU3bMC28El9CRJhNgXv5Bni30rbgD1na
	 cvxElSGtVqbUIoVAKrmH9W699kbama40nWAutI+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 176/241] drm/amdgpu: Prefer shadow rom when available
Date: Wed, 23 Apr 2025 16:44:00 +0200
Message-ID: <20250423142627.719314975@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

commit 27145f78f56a3178c4f9ffe51c4406d8dd0ca90c upstream.

Fetch VBIOS from shadow ROM when available before trying other methods
like EFI method.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Fixes: 9c081c11c621 ("drm/amdgpu: Reorder to read EFI exported ROM first")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4066
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c |   36 ++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -439,6 +439,13 @@ success:
 	return true;
 }
 
+static bool amdgpu_prefer_rom_resource(struct amdgpu_device *adev)
+{
+	struct resource *res = &adev->pdev->resource[PCI_ROM_RESOURCE];
+
+	return (res->flags & IORESOURCE_ROM_SHADOW);
+}
+
 static bool amdgpu_get_bios_dgpu(struct amdgpu_device *adev)
 {
 	if (amdgpu_atrm_get_bios(adev)) {
@@ -457,14 +464,27 @@ static bool amdgpu_get_bios_dgpu(struct
 		goto success;
 	}
 
-	if (amdgpu_read_platform_bios(adev)) {
-		dev_info(adev->dev, "Fetched VBIOS from platform\n");
-		goto success;
-	}
-
-	if (amdgpu_read_bios(adev)) {
-		dev_info(adev->dev, "Fetched VBIOS from ROM BAR\n");
-		goto success;
+	if (amdgpu_prefer_rom_resource(adev)) {
+		if (amdgpu_read_bios(adev)) {
+			dev_info(adev->dev, "Fetched VBIOS from ROM BAR\n");
+			goto success;
+		}
+
+		if (amdgpu_read_platform_bios(adev)) {
+			dev_info(adev->dev, "Fetched VBIOS from platform\n");
+			goto success;
+		}
+
+	} else {
+		if (amdgpu_read_platform_bios(adev)) {
+			dev_info(adev->dev, "Fetched VBIOS from platform\n");
+			goto success;
+		}
+
+		if (amdgpu_read_bios(adev)) {
+			dev_info(adev->dev, "Fetched VBIOS from ROM BAR\n");
+			goto success;
+		}
 	}
 
 	if (amdgpu_read_bios_from_rom(adev)) {


