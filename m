Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9740318B465;
	Tue, 30 Jul 2024 17:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359557; cv=none; b=k/59JWrszo2OUfF4JuAhfYEZpqfhzUWVO/Ennai+Vdql3R3aBasUl4DA50zRVZS/BpMzKHA05KWdXl2dwwa2/T2KJxA1XsuHlZPyfCVkC3gPQn6UbkiK9nxdc9bCklbIR6JoUSEU9SS7cHOQqI4VRZ1r1hG9V61uBgqIFPzpEJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359557; c=relaxed/simple;
	bh=wiPhJs73bBT6/LC31h7r3gKllB0vqrUBJBBbt635T4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRuVPforzHS/BwhKRjoURS9cVoCenEQT9nzPDiqWsskKGuIuN+aTlv9uGgL9i8ZWcz0e7s7qDJgxlpX2IFumR3SV+xQlyH98D4yi7nT2s7JpQoUEU6y9me1+7bfop1yssgGiGRTW7cUkioeL0owpL26if+pvUr/o4453kIbZle0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3H1l2/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3H1l2/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F6DC4AF0C;
	Tue, 30 Jul 2024 17:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359557;
	bh=wiPhJs73bBT6/LC31h7r3gKllB0vqrUBJBBbt635T4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3H1l2/13eWnvTUuQ+h6e2xZqM/oMdMVP2R13xaCusOHlvLkRLoS3fNtEbIFP9UWd
	 nQkGODZFBA0GecH7cSQIbZ/8zrgpKoTLz+wYvE4PKqkhswz85BVzuQh0boFzpy0vIi
	 cMTQcSKvTMs+8K5vGCXNmyc84tD3WYOIWJOu4W1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Furkan Kardame <f.kardame@manjaro.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 6.6 501/568] drm/panfrost: Mark simple_ondemand governor as softdep
Date: Tue, 30 Jul 2024 17:50:08 +0200
Message-ID: <20240730151659.609558502@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -731,3 +731,4 @@ module_platform_driver(panfrost_driver);
 MODULE_AUTHOR("Panfrost Project Developers");
 MODULE_DESCRIPTION("Panfrost DRM Driver");
 MODULE_LICENSE("GPL v2");
+MODULE_SOFTDEP("pre: governor_simpleondemand");


