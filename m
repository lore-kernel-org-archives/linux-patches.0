Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68F444A739;
	Thu, 30 Jul 2026 16:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427929; cv=none; b=qrNbEyPooz7sdM5mpItMkM6vczezD1Ze0RSsTf5W0f1/zSMgwp3KAhRp3bPjRhLGbu6YCiVr9ejvnxUxrCGtn+vtFf18n5DT+kZpyo3fNFFrYy18jUir/cWM3Hz5XzyTfL0nwTMl5AtDHtX4W10xp81u1ShOTwZJJLA0f4rucCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427929; c=relaxed/simple;
	bh=ZMvOMoOwmqEkNAZ/1BoPfBXJZ5oMyieD6C/WQ3s973E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HqqfECpTPdG7bUh9ag4gowpTYHQWsEO8bCBtwFTGhrzI2fV5/+5i6IhwrtdWzfLcta1PIGC/cRyjSAmDtli5HEija6JyBkEoPJS34sXZaWzVR8Gf02OF2RP+9PA2//jfEq6x7fIVl0QE0nXY2nwTAn7GBbwKsGS19HBjbROmL4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4cd+MdO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4cd+MdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC6C1F000E9;
	Thu, 30 Jul 2026 16:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427928;
	bh=9WhbdbdDRN4c32YW+fbuQDQVXJ2hYFXAlrVhxU37z3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v4cd+MdOusKBysQ6PFheMsfCn6TWQ+eyTkAZQ3a6kXR2dvoQO580J9PNUGYlAzhNa
	 EbjLe35WrhSNFgt9tvAX1lEbfzoW/M58itbVD3sMdm6H94DW3tnkdQg5IkfELEcaUr
	 VEA0emyxB0t15GHq0g0d65FAsJhs/CUkJqGq9fI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyuan Zhang <boyuan.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 343/484] drm/amdgpu/vce: fix integer overflow in image size
Date: Thu, 30 Jul 2026 16:14:00 +0200
Message-ID: <20260730141430.932546189@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


