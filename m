Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBCB43C056;
	Mon, 17 Aug 2026 15:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979712; cv=none; b=QIf8iA8kF+ze8+7JsSnqAKMWaLTrq5/3oruTyuHJp0oJCYtMP6QHTI9jrFTbzTCPR70uv6kI6uTxA/XLYICQh1rsNu8pCJzQnSl5XU2asfQWCDsRGljhpr0VZov7pP/6eKxWUDn7n//Qk3wC0HkTbPIyw+9QCw2iFi7Uyr9uv/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979712; c=relaxed/simple;
	bh=GnyeW4MpvUzD7jsMQbjvV77+IIDmdvoiCnvJVc6PdKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JWOinGwzigxZwwqWTFrYQUkP3ZSZ1qCG7cBRPv7prDWqfUtPogoPao87LCKDoeouY+1+SEVoxSomSlEbloMZk/+o20UvHqziCQtAf+qG+BVDGTaewFL7NFrol11NYQ8FX0MFL0yL+MKDFgoQni97sZFRRnPEvsJOgesuISc1kfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ULP3gY4o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ULP3gY4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DCF1F000E9;
	Mon, 17 Aug 2026 15:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979711;
	bh=ELbRHxE9m8FyCso9yvWrrZsP3J/RY3aTNrobYTo+fRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ULP3gY4odv14mmpdRaAPiEBFUnA8aSVjbdnylWnBU4840MxLbssYQIWHAwqhzaQXn
	 2JhFpdJCpLjNZwP08HkT8KbpC4NUR4iiIWwSmzQBLlebWVcbVK5hKJKHi1PdK96hIn
	 SKk+kfv/7Mw/KORz7tSa0zrfGVQDEKnLCfse0HvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyuan Zhang <boyuan.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 283/609] drm/amdgpu/vce: fix integer overflow in image size
Date: Mon, 17 Aug 2026 15:29:39 +0200
Message-ID: <20260817132553.649615426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -856,9 +856,20 @@ int amdgpu_vce_ring_parse_cs(struct amdg
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


