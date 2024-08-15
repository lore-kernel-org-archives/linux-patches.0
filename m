Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB63C3214;
	Thu, 15 Aug 2024 14:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732574; cv=none; b=S0OQcl7Fw39bxMXUlWCTu9xOj4mBi7PgbUEBivKrdZ3mbAt6EUwBMfdWF/tsXTwYE/0JzbCSzcTUT5IwnOH9oUadiqULgZe7fnL5p9Vr/4NGUd5tOoarUR1taOoe6/me7bJ8DPfAUYJ5gD34woLpDVC3HfJji1sEZm7faQgDPyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732574; c=relaxed/simple;
	bh=tKBibiv2OzTRqYjpanX6PPGxqaviteWUpYidhcXMrIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSfmptkIDjUaNcM/qyAatisKSfZbgPPcdJpIy96w+QaXu4YGzTYOy4BmboDVQnB8xjOTMKKdxuMULvnAHloCgs28jT3N2GtrnyOxXMdRx9ATPwbL3/kksZh6iaxoULI3eQW7nXudYtIFg2VzvF/9YvXc/xOT049RVNw50cWFZPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6M+RB5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6M+RB5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16ED4C32786;
	Thu, 15 Aug 2024 14:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732574;
	bh=tKBibiv2OzTRqYjpanX6PPGxqaviteWUpYidhcXMrIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6M+RB5x2oA6Q8Nhrcn1OgmlTGDXHfM6BCNqhlMrZpx32spRxeTKUm44F4n88gmwd
	 E2aMlGzoxIHCFwPN1IAqEjghrrZ/Bq8Qt8vbD/WDymvl84Vr3phqNxgLjOh8nc7Tey
	 lyI4CkBvd+ZS67HUSjyd4POtALZ+atWgpFN+P6+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Furkan Kardame <f.kardame@manjaro.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 5.10 180/352] drm/panfrost: Mark simple_ondemand governor as softdep
Date: Thu, 15 Aug 2024 15:24:06 +0200
Message-ID: <20240815131926.234580851@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragan Simic <dsimic@manjaro.org>

commit 80f4e62730a91572b7fdc657f7bb747e107ae308 upstream.

Panfrost DRM driver uses devfreq to perform DVFS, while using simple_ondemand
devfreq governor by default.  This causes driver initialization to fail on
boot when simple_ondemand governor isn't built into the kernel statically,
as a result of the missing module dependency and, consequently, the required
governor module not being included in the initial ramdisk.  Thus, let's mark
simple_ondemand governor as a softdep for Panfrost, to have its kernel module
included in the initial ramdisk.

This is a rather longstanding issue that has forced distributions to build
devfreq governors statically into their kernels, [1][2] or has forced users
to introduce some unnecessary workarounds. [3]

For future reference, not having support for the simple_ondemand governor in
the initial ramdisk produces errors in the kernel log similar to these below,
which were taken from a Pine64 RockPro64:

  panfrost ff9a0000.gpu: [drm:panfrost_devfreq_init [panfrost]] *ERROR* Couldn't initialize GPU devfreq
  panfrost ff9a0000.gpu: Fatal error during GPU init
  panfrost: probe of ff9a0000.gpu failed with error -22

Having simple_ondemand marked as a softdep for Panfrost may not resolve this
issue for all Linux distributions.  In particular, it will remain unresolved
for the distributions whose utilities for the initial ramdisk generation do
not handle the available softdep information [4] properly yet.  However, some
Linux distributions already handle softdeps properly while generating their
initial ramdisks, [5] and this is a prerequisite step in the right direction
for the distributions that don't handle them properly yet.

[1] https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/blob/linux61/config?ref_type=heads#L8180
[2] https://salsa.debian.org/kernel-team/linux/-/merge_requests/1066
[3] https://forum.pine64.org/showthread.php?tid=15458
[4] https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git/commit/?id=49d8e0b59052999de577ab732b719cfbeb89504d
[5] https://github.com/archlinux/mkinitcpio/commit/97ac4d37aae084a050be512f6d8f4489054668ad

Cc: Diederik de Haas <didi.debian@cknow.org>
Cc: Furkan Kardame <f.kardame@manjaro.org>
Cc: stable@vger.kernel.org
Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/4e1e00422a14db4e2a80870afb704405da16fd1b.1718655077.git.dsimic@manjaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panfrost/panfrost_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -681,3 +681,4 @@ module_platform_driver(panfrost_driver);
 MODULE_AUTHOR("Panfrost Project Developers");
 MODULE_DESCRIPTION("Panfrost DRM Driver");
 MODULE_LICENSE("GPL v2");
+MODULE_SOFTDEP("pre: governor_simpleondemand");


