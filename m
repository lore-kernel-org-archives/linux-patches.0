Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DF6361651;
	Tue, 16 Jun 2026 15:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624642; cv=none; b=bOoS5zY+aFLUFBiAyPyZnlFDzHU8mDuQK91nSSW0v8KqVdzUfJDcTQQzyqTRmEL4uynRTV4EIv8YaJOKztn9IhNxtJGrz7BoVQKl/KYnJ8/eeyNrMkaVx1lAwOBYiqvkTxFzwQ3DofnC6BBsUTJGsMD5tr3OGfSIX51nur2EVXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624642; c=relaxed/simple;
	bh=BwwuXAwDRgqSTyEauyRJs+10iLbDsG+7O6S1ho1GNHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cV4n5Y2T9D+s3k1uT718YuzgY60UFRnaxQIkpK7ZRI6q/ljxk4lv4KQbG2qM8FLJAiuenofZvX/Iq8amPfEgc355lPUYbLYe2mV9owtS+MHHXjAP8pymvwc09GGuUA0zV7F8Tppvetx/TbRqtTTtRCBjA8wdGf1rcyB7FILEbzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0KfyHKfG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KfyHKfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AD41F000E9;
	Tue, 16 Jun 2026 15:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624641;
	bh=iSo5kW0mxBbheIqI4QHY5TACJa4bXaYMRNUNxkbu9gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0KfyHKfGNsH5BlUMSBYe0qCGg/40mJNOVfePJqRofAvC8AfwZTe0cLdcxKL8Lh0vF
	 UIHU71jLuJTDdVAqjYStu8O0Uzmrc4xDeOdyDUkQzgOp2LNec5QWa8FWTpbHwmGfiK
	 dPBB/HfuVTLMgkRHoFlan5+UwFdXOKKC1lCLvIBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>
Subject: [PATCH 7.0 340/378] drm/v3d: Wait for pending L2T flush before cleaning caches
Date: Tue, 16 Jun 2026 20:29:31 +0530
Message-ID: <20260616145128.085893582@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

commit abf888b03a9805a3bc37948a0df443553b1c0910 upstream.

v3d_clean_caches() starts the cache-clean sequence by writing
V3D_L2TCACTL_TMUWCF to V3D_CTL_L2TCACTL and then polling for that bit to
clear. It does not, however, check for an L2T flush (L2TFLS) that may
still be in flight from a previous operation.

On pre-V3D 7.1 hardware, kicking off the TMU write-combiner flush while an
L2T flush is still pending can clobber bits in L2TCACTL and cause cache
inconsistencies.

Poll for L2TFLS to clear before writing L2TCACTL on V3D < 7.1, ensuring
any pending flush has completed before a new clean is issued.

Cc: stable@vger.kernel.org
Fixes: d223f98f0209 ("drm/v3d: Add support for compute shader dispatch.")
Link: https://patch.msgid.link/20260530-v3d-fix-rpi4-freezes-v1-1-c2c8307da6ce@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/v3d/v3d_gem.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/v3d/v3d_gem.c
+++ b/drivers/gpu/drm/v3d/v3d_gem.c
@@ -213,6 +213,14 @@ v3d_clean_caches(struct v3d_dev *v3d)
 
 	trace_v3d_cache_clean_begin(dev);
 
+	/* GFXH-1897: Ensure pending flushes complete before writing L2TCACTL */
+	if (v3d->ver < V3D_GEN_71) {
+		if (wait_for(!(V3D_CORE_READ(core, V3D_CTL_L2TCACTL) &
+			       V3D_L2TCACTL_L2TFLS), 100)) {
+			drm_err(dev, "Timeout waiting for L2T clean\n");
+		}
+	}
+
 	V3D_CORE_WRITE(core, V3D_CTL_L2TCACTL, V3D_L2TCACTL_TMUWCF);
 	if (wait_for(!(V3D_CORE_READ(core, V3D_CTL_L2TCACTL) &
 		       V3D_L2TCACTL_TMUWCF), 100)) {


