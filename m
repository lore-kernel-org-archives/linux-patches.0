Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B19A4F55A0;
	Tue, 13 Oct 2026 12:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895915; cv=none; b=HlY5OFFl1b1EgHSn/s1rzM8E8s51md/RLOSEWifW33M76kMUz5IIN5drvEDH7B+Vmeu0/hfSvLhpXJXYuvnJ61nTXPmVtLYfyE7GKsyoD5bM22lNLX9TLGtTEf1AQHV34QkQjhJnY5S1kpIE417QOCl+0eW7QZyXsNpLg8acU/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895915; c=relaxed/simple;
	bh=eUBp4F7+MMYAgmIKzoZFcTXfakQF5PD8eoMZsXy5uE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qpp+TdjQF5D1v0JnnLTHwd3PeQH9W3VvkKs66FjwKIFMIuv06AxJlwrqMvBEbtnnjCgGV14v5NgKw8af0svhN4bw7D6nWJ7Ik5q9u7cZQhpvpHRxrqW4RN8e3L8FkXpCXfCqmjwDqZCD7u0d/nyDUqktm23aYE/+V4u0up/cWyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0C1SvyA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0C1SvyA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644681F000FF;
	Tue, 13 Oct 2026 12:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895913;
	bh=UI69wESVnc/8DYdZjMkVHviFS81GNXsLCfFVoj1GgYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S0C1SvyAtVgrwuvc6RcVYGMBh2voPvtmK+6+1g1tTS2yXNqtp+lz36LFy/Uffk6G0
	 CWPz2MW2Ch0mty1QfgodJgPNE+pP6/TdsxzlS7yezFDYe3bw/ItsruJVTm2qoNJ5Yo
	 pJ0zQU34qgS/3puySorwrA6rol4ZRBolEkxBSmVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ayhan=20=C3=87i=C3=A7ek?= <ayhancicek@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 435/497] drm/amdgpu: make Mac FB workaround generic
Date: Tue, 13 Oct 2026 13:40:02 +0200
Message-ID: <20261013112918.211580860@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit c7f44ec5c4ec760e74351f1843dcb8322f67cbf6 upstream.

Rather than adding a case of every chip where this is seen
just check if the FB is at 0 and the ssid is apple.  This
should cover all chips which fall into this case.

Tested-by: Ayhan Çiçek <ayhancicek@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c54e4d10507722398dc90cf3c532e50b86cf425a)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -977,20 +977,17 @@ void amdgpu_gmc_get_vbios_allocations(st
 	case CHIP_RENOIR:
 		adev->mman.keep_stolen_vga_memory = true;
 		break;
-	case CHIP_POLARIS10:
-	case CHIP_POLARIS11:
-	case CHIP_POLARIS12:
-		/* MacBookPros with switchable graphics put VRAM at 0 when
-		 * the iGPU is enabled which results in cursor issues if
-		 * the cursor ends up at 0.  Reserve vram at 0 in that case.
-		 */
-		if (adev->gmc.vram_start == 0)
-			adev->mman.keep_stolen_vga_memory = true;
-		break;
 	default:
 		adev->mman.keep_stolen_vga_memory = false;
 		break;
 	}
+	/* MacBookPros with switchable graphics put VRAM at 0 when
+	 * the iGPU is enabled which results in cursor issues if
+	 * the cursor ends up at 0.  Reserve vram at 0 in that case.
+	 */
+	if ((adev->pdev->subsystem_vendor == PCI_VENDOR_ID_APPLE) &&
+	    (adev->gmc.vram_start == 0))
+		adev->mman.keep_stolen_vga_memory = true;
 
 	if (amdgpu_sriov_vf(adev) ||
 	    !amdgpu_device_has_display_hardware(adev)) {


