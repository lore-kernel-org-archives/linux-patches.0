Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2639F2FA62C;
	Tue, 17 Jun 2025 16:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179034; cv=none; b=CrAJ2YulCRmB8ZpHxGcPti8Ls3MvohCL2kANIe/YWZy0Cro0yvnjgbxw/6iO+j2AvZE6pY2/6uK1B3uzEHcJC7VXxUL6+xS5dFJFRMrgHHxPxxR+uu4T52s0zvT3khZAscT6IjX5l9vXyIF8fslsjRYflTHfUlA/zHWu61gyHwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179034; c=relaxed/simple;
	bh=ktzfgHzkQ+7WPfj3rEjv5B6aBKNKfQbcyj4Alf/2q7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WnzZ2/BK60lKf08bV6cO/ZNW5KmgGoNwsNUYkrP8fTt10lxdEgVdvvzxDxQs/Cr7FPHKM65dSFmURXc4+rFxsB1Y1/k6PQACzO4S1WjdP5aqvZztghYhqTnNbpMOUX2kDCUSSyC1MqYlKLhW+XW76eCPGckA0tM1Dkgl/CaGpJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vD7/QN0o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vD7/QN0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBFEC4CEE3;
	Tue, 17 Jun 2025 16:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179033;
	bh=ktzfgHzkQ+7WPfj3rEjv5B6aBKNKfQbcyj4Alf/2q7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vD7/QN0o5tCtzT1F1Bds/I4/dX1/IP0xoVZnWuMOg7N739Hwfkp3dQo6y1di6OsAg
	 BlALYfnj9IRWAAjuMJdsh/4kEqM8IcoUGubomId5JmwIPEVzuGLstfV6q7Bt2dZF8Z
	 MLFAxJa2yXFPqxes9ubfLVm0aSyisv9PbTueznT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 627/780] drm/xe/vsec: fix CONFIG_INTEL_VSEC dependency
Date: Tue, 17 Jun 2025 17:25:35 +0200
Message-ID: <20250617152517.008315583@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 2182f358fb138f81a586ffdddd510f2a4fc61702 ]

The XE driver can be built with or without VSEC support, but fails to link as
built-in if vsec is in a loadable module:

x86_64-linux-ld: vmlinux.o: in function `xe_vsec_init':
(.text+0x1e83e16): undefined reference to `intel_vsec_register'

The normal fix for this is to add a 'depends on INTEL_VSEC || !INTEL_VSEC',
forcing XE to be a loadable module as well, but that causes a circular
dependency:

        symbol DRM_XE depends on INTEL_VSEC
        symbol INTEL_VSEC depends on X86_PLATFORM_DEVICES
        symbol X86_PLATFORM_DEVICES is selected by DRM_XE

The problem here is selecting a symbol from another subsystem, so change
that as well and rephrase the 'select' into the corresponding dependency.
Since X86_PLATFORM_DEVICES is 'default y', there is no change to
defconfig builds here.

Fixes: 0c45e76fcc62 ("drm/xe/vsec: Support BMG devices")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://lore.kernel.org/r/20250529172355.2395634-2-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit e4931f8be347ec5f19df4d6d33aea37145378c42)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/Kconfig b/drivers/gpu/drm/xe/Kconfig
index 5c2f459a2925a..9a46aafcb33ba 100644
--- a/drivers/gpu/drm/xe/Kconfig
+++ b/drivers/gpu/drm/xe/Kconfig
@@ -2,6 +2,8 @@
 config DRM_XE
 	tristate "Intel Xe Graphics"
 	depends on DRM && PCI && MMU && (m || (y && KUNIT=y))
+	depends on INTEL_VSEC || !INTEL_VSEC
+	depends on X86_PLATFORM_DEVICES || !(X86 && ACPI)
 	select INTERVAL_TREE
 	# we need shmfs for the swappable backing store, and in particular
 	# the shmem_readpage() which depends upon tmpfs
@@ -27,7 +29,6 @@ config DRM_XE
 	select BACKLIGHT_CLASS_DEVICE if ACPI
 	select INPUT if ACPI
 	select ACPI_VIDEO if X86 && ACPI
-	select X86_PLATFORM_DEVICES if X86 && ACPI
 	select ACPI_WMI if X86 && ACPI
 	select SYNC_FILE
 	select IOSF_MBI
-- 
2.39.5



