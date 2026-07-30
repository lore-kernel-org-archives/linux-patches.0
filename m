Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11610358373;
	Thu, 30 Jul 2026 15:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426509; cv=none; b=vFhykTxi2NJkv7cKQMp5DSV7aKQL/GBku/TnzpOE2VMXxMfa08XhQCa4I9z8U1IZTdEuNvGH7gv5ED5H2PDe11pqmHBDkgwg2APpeiqzPLJWEqerS4ki4DHfIaCgxPf8dnL6nB8bzxnOgRYqOL9/DVac/zJO+93PuHC7ZondWr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426509; c=relaxed/simple;
	bh=yjBgHftIPYnYw+MNH/Hdk7UhqWzgw6IuVlkwkHhsm50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DHndxs5KocgC8OnHLXiJJezmHxWpkA3q8FcpMsr1moEXnPcpzSmfVBb4sVPEyyjC3tRs7BVJbtsAKH4a5Zoz5px+QNvpG1kaxu9TmAiGtHy5FYhYflYq3PyPA4i/S4Q9TzuvAxUb/FrxGDKPYu1OstyIC7TmHY8pq2XpBU89BUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXicJGTH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXicJGTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361791F000E9;
	Thu, 30 Jul 2026 15:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426507;
	bh=Bu23dD9fBMVf/ug2OZAVRFsLxysCjQNHHBxJlNXrLCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YXicJGTHpCWxCGgrw8vpri8qw5OBBvYl1LocoWJGVsfvXX1hSiAeZsPfX9AuiwbxL
	 ikd6db3jUoXyg96w9Q/nsfKfJFW7Xkr5duwCKnOoal2CfGe2Lnv6KL0lGAO/ttmSoB
	 z2kokC5fVZ+TzykehibXs9MktpkWZ2mSiOPnP3OE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyuan Zhang <boyuan.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 444/602] drm/amdgpu/vce: fix integer overflow in image size
Date: Thu, 30 Jul 2026 16:13:56 +0200
Message-ID: <20260730141445.292943368@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
@@ -852,9 +852,20 @@ int amdgpu_vce_ring_parse_cs(struct amdg
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


