Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C4C4DDB4F;
	Thu, 17 Sep 2026 15:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660270; cv=none; b=UvGAlTrAwDbkKMP36Yhq3GT0uHjYWE6LDqBbYq74L/+Md6j+4uDuBM7mefal9PCGJKenvmtvDbMXkIuwdFRcOzXRNMz7IluEaggFv/u7mFezp1hX2kWEvEqPF6acw6JSDsG5uVK+GH6GRZStprEu+XYdPEhqUEWOKEHIxZynP/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660270; c=relaxed/simple;
	bh=+7HjVSdvnPve2hb59xddnG0wv9fl6/d4NzwfEVi5wbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ht+Dv6LAdzAkzVx9mDb7+KL/HEeHf9yhmmBF8t/bVTKUAdcq5+Sv9KQDAz8uNFW7fvzRf33JyFCigfFdMGtKab+50zhQdzqhWDq2KKCDyrsvTAs/ieYxVeFsE7y1FgeyacdXaJz495xU1dzTk7Wayii4mL3aLjJaF+TAdDvOn50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDfmBcEG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDfmBcEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2341F000FF;
	Thu, 17 Sep 2026 15:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660265;
	bh=/0bXQPNexeV3YhxcgVFX2WNOK6NHNMN/oyLXeS3RqfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XDfmBcEGJ2DEMKphy8mSQtR3MF0yttoRrof7cZPU6rZAR/dwkHdv3wn3QblHZoRwY
	 21tdp2ScErJ13UIfy2aMTq6dBXgFgz9yGZCaF+csLVx/M5gpgc2X+Yn+qf5TIjFzWj
	 zoZ0jeaOh+OHC/DWpUVoMQ9Ul+OQFH+s66kRG7y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yudi Yang <2000jedi@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 7.2 532/733] drm/rockchip: analogix_dp: fix unchecked bound endpoint name length
Date: Thu, 17 Sep 2026 16:14:00 +0100
Message-ID: <20260917151405.455863528@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yudi Yang <2000jedi@gmail.com>

commit bc69439d983cc491cc86e01fafc1deb94e1bb85e upstream.

rockchip_dp_drm_encoder_enable() uses sprintf() to format a device tree
path into a 32-byte stack buffer. Device tree paths are not limited to
this size, so a sufficiently long path can overflow the buffer.

Use snprintf() with the destination size to truncate the generated name
and keep the writes within bounds.

Fixes: 729f8eefdcad ("drm/rockchip: analogix_dp: Add support for RK3588")
Cc: stable@vger.kernel.org
Signed-off-by: Yudi Yang <2000jedi@gmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260901195511.2761251-1-2000jedi@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
@@ -241,10 +241,11 @@ static void rockchip_dp_drm_encoder_enab
 				of_graph_get_remote_port(endpoint.local_node);
 
 			of_property_read_u32(remote_port, "reg", &port_id);
-			sprintf(name, "%s vp%d", remote_port_parent->full_name, port_id);
+			snprintf(name, sizeof(name), "%s vp%d",
+				 remote_port_parent->full_name, port_id);
 		} else {
-			sprintf(name, "%s %s",
-				remote_port_parent->full_name, endpoint.id ? "vopl" : "vopb");
+			snprintf(name, sizeof(name), "%s %s",
+				 remote_port_parent->full_name, endpoint.id ? "vopl" : "vopb");
 		}
 
 		DRM_DEV_DEBUG(dp->dev, "vop %s output to dp\n", (ret) ? "LIT" : "BIG");


