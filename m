Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AF41487F4;
	Tue, 30 Sep 2025 15:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244800; cv=none; b=A7t19Nrp5qtNIyH5v6dLPJDZR5y/DWQ6uSpMQNtTkF0MGp4Bu+VNeDjdivD5Ry74KtkgkPrxZPZRSDmu4K44gp+BCaIukggrLP+UGTo4B1nu2JNkbr1+4SiktFDhqtCIKBlQd6wc0T41WO85qT4V5W4QG9bNzlh6+rrBuim046U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244800; c=relaxed/simple;
	bh=da6Atef4b+A7nbZOBGlGbpdtYp4HTgHMv/1tW7mGtko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdUjz/AccEEGpwmE2uLJ6JQ3RgqrwjJsHm6n/mvYsBCHWt5vuHD69A+skE74rsuINIOWKChrAZAN17qfWEzYkl3me0nSnQdx4N3KGT/7BycK6btlUqfT1hx90SDXJ/Vu1zeqDVHRFQ2+XhydtYslb1e9EvMEFBDQ+Qm+8uaY7dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ujq8KCap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ujq8KCap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62077C4CEF0;
	Tue, 30 Sep 2025 15:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244799;
	bh=da6Atef4b+A7nbZOBGlGbpdtYp4HTgHMv/1tW7mGtko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ujq8KCapXDB4HfMKz7Mc7hDgVojkbsnnWBUgbQQTs2wl6VFDg92HdCANvdgtHBNKL
	 wui0nBJNTQopeWWbv1r+9GtVBdZRamSUm6SOc/N+DrRh1NwEyxv72r29WFDAnDUxC5
	 HBIEc3+RX8HFYCR6csZSBw6Q2tUW3kmFNV4Exclg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Riana Tauro <riana.tauro@intel.com>,
	kernel test robot <lkp@intel.com>,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 090/143] drm/xe: Fix build with CONFIG_MODULES=n
Date: Tue, 30 Sep 2025 16:46:54 +0200
Message-ID: <20250930143834.816833542@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit b67e7422d229dead0dddaad7e7c05558f24d552f ]

When building with CONFIG_MODULES=n, the __exit functions are dropped.
However our init functions may call them for error handling, so they are
not good candidates for the exit sections.

Fix this error reported by 0day:

	ld.lld: error: relocation refers to a symbol in a discarded section: xe_configfs_exit
	>>> defined in vmlinux.a(drivers/gpu/drm/xe/xe_configfs.o)
	>>> referenced by xe_module.c
	>>>               drivers/gpu/drm/xe/xe_module.o:(init_funcs) in archive vmlinux.a

This is the only exit function using __exit. Drop it to fix the build.

Cc: Riana Tauro <riana.tauro@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506092221.1FmUQmI8-lkp@intel.com/
Fixes: 16280ded45fb ("drm/xe: Add configfs to enable survivability mode")
Reviewed-by: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Link: https://lore.kernel.org/r/20250912-fix-nomodule-build-v1-1-d11b70a92516@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit d9b2623319fa20c2206754284291817488329648)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_configfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_configfs.c b/drivers/gpu/drm/xe/xe_configfs.c
index 9a2b96b111ef5..2b591ed055612 100644
--- a/drivers/gpu/drm/xe/xe_configfs.c
+++ b/drivers/gpu/drm/xe/xe_configfs.c
@@ -244,7 +244,7 @@ int __init xe_configfs_init(void)
 	return 0;
 }
 
-void __exit xe_configfs_exit(void)
+void xe_configfs_exit(void)
 {
 	configfs_unregister_subsystem(&xe_configfs);
 }
-- 
2.51.0



