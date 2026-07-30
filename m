Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F939446058;
	Thu, 30 Jul 2026 15:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424978; cv=none; b=mZ1i84C8WhLc5YDSgoN+klnUVDw+XHgQsQcqSkHOGZYBzoICXygT2gkvZm1vl5ux81wKQTUxMse5ju+lP817jzXi6Aemk5VYjM9KP7uK3xFTtspfl5C6YE/tw2w21A/jUBoVC1turrgYpxhfIDG6Nqzz2mNTTi15fYTkmvW+Z1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424978; c=relaxed/simple;
	bh=B51fEa0NrptA8RKW2g5mGj6JVLVovyRcVnanaPSwH10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YIXjkn1uoDJIBZeTVvChRiwFdg6rbnrFAT09zWTQnhataUai2dlfVHowx6UNE3RRDfc2oLAPXKpvCpl20wHjjm0SsZERcwc0Tp82WKj7LhGaTjCjqyr3fFnahkF/VVDDgevPieDbytdshZKAxXNl68h5dBeKQXeH2nQ3Vtuq/5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hb3WGG+K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hb3WGG+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAC11F000E9;
	Thu, 30 Jul 2026 15:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424977;
	bh=6K9YM6e+Htjg4f37+Xdwl6dIvliBnir4pH1sWnoGEno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hb3WGG+KHhumea/Ojeg9Mp7aU8ML/XNnn0430neIk4i3HyfdDcMdgyHPVQt6V7U61
	 YnDiCzw+9DWwgWrGGTSMz0BEd8pWOm5nXS57GXuOhurr28DLs8YmJF2tGQxurPjUsf
	 dz9AL6Y+BLqhH3NRw/oBnNPLWwrgxYE+KAN5M3jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyuan Zhang <boyuan.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 582/675] drm/amdgpu/vce: fix integer overflow in image size
Date: Thu, 30 Jul 2026 16:15:12 +0200
Message-ID: <20260730141457.494717598@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -853,9 +853,20 @@ int amdgpu_vce_ring_parse_cs(struct amdg
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


