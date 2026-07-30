Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7374E37883C;
	Thu, 30 Jul 2026 14:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423217; cv=none; b=VbBb4M1FEZiDaDInjTzYdl5897XB1yGvzpzqemWxUrP/7Y09sn3BopVVXSUYeuBsBHTjgouXoGpKDMvGHb/0dvHK/eEjogwzYrc6uOnUO4FJnDq5u7rvkitIQZW8D3sUorESJv+tI0ia0o8kPCa4CCN6XwxfJPubsvwbNYcoxJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423217; c=relaxed/simple;
	bh=wknPLVDqUf9PBc5tJYDGJUB8ToW6AXxnpT1ljIi1ITk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j+Nuv/AhSv1JK6mbJWA3M6GQtQET5NTj3+U1Zfj/L45fL031gkR9RG4fR3txxwEf+O5A291z7YBGRsGFE3r8NObAf7OxDEMO70q7MfydhJQgDAamB9szrrWFIzOn5sVVjb3tR4uwfr6LpCbQRv05w25XYd96kvx4Lz9uV/IMsc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPwrqAJM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPwrqAJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4C01F000E9;
	Thu, 30 Jul 2026 14:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423216;
	bh=GDDWONcZYcf0db4fmfsK2CMICOhDZIqjCSOc0ta4ZWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RPwrqAJM9nZkXlGymt0Ms8Fb9f9oQbQ/YB9SCiLDGpiIDENWx40wSvVJZnXyPcZK8
	 bSoSqlkEclOQxYaQCyZsq1yJ6vmWPVAPDk3YVG32YYFQhnmpW3Y3dzYnBc73D+X79g
	 mPpJ3Y7kluoaXOxfgdo2SZbeYAjLDftRDCBElSkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyuan Zhang <boyuan.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 708/744] drm/amdgpu/vce: fix integer overflow in image size
Date: Thu, 30 Jul 2026 16:16:21 +0200
Message-ID: <20260730141459.325873184@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boyuan Zhang <boyuan.zhang@amd.com>

commit 186bfdc4e26d019b2e7570cb121964a1d89b2e5b upstream.

Fix a security vulnerability where malicious VCE command streams
with oversized dimensions (e.g. 65536×65536) cause 32-bit integer
overflow, wrapping the calculated buffer size to 0. This bypasses
validation and allows GPU firmware to perform out-of-bound memory
access.

The fix uses 64-bit arithmetic to detect overflow and rejects
invalid dimensions before they reach the hardware.

V2: remove redundant check
V3: modify max height value
V4: remove size64

Signed-off-by: Boyuan Zhang <boyuan.zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit cbe408dba581755ad1279a487ec786d8927d778d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
@@ -877,9 +877,20 @@ int amdgpu_vce_ring_parse_cs(struct amdg
 				goto out;
 			}
 
-			*size = amdgpu_ib_get_value(ib, idx + 8) *
-				amdgpu_ib_get_value(ib, idx + 10) *
-				8 * 3 / 2;
+			uint32_t width, height;
+			width = amdgpu_ib_get_value(ib, idx + 8);
+			height = amdgpu_ib_get_value(ib, idx + 10);
+
+			if (width == 0 || height == 0 ||
+			    width > 4096 || height > 2304) {
+				DRM_ERROR("invalid VCE image size: %ux%u\n",
+					  width, height);
+				r = -EINVAL;
+				goto out;
+			}
+
+			*size = width * height * 8 * 3 / 2;
+
 			break;
 
 		case 0x04000001: /* config extension */


