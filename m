Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303BC36607D;
	Thu, 30 Jul 2026 15:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426483; cv=none; b=pYtP4GZE1AQ0XbDJClmqOYpP1wKChubpnhjlm3p5kT6//YRrPhAPRq4e1GshzRu0o05/Xpoui7efCih5PqqtNW6k8FjHArmv0IlKzeqs25vaBMrBUnny98nlEuiCyj53wuFUW4I8evitvgpXIk3s4dpnPuE5vxo3AwR6MQNck/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426483; c=relaxed/simple;
	bh=te+JtI1fCtM3dPrXCe475dsww3lF7da1lah9AucQQa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1xvwcOouB0Mov43gdhAK7rxQXrtpGPAN2te66YGKtMv1jN1CYnYAdNNYLC27wm1s+noaWn4EQXUs8P/O8cLdoNkMbxhROnmzUhZI+imfYRtxAEbWslTU7U+N9KFTB+FZQPPwc1D0KPbaZRa14DhMYRm08Em/A+aPNCl8FM0XzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JmfT7pp+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JmfT7pp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5441F000E9;
	Thu, 30 Jul 2026 15:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426482;
	bh=VAT+rhQov+X3BVOq06+uFNLRdrbqikdDzFSO2Ty2H/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JmfT7pp+zF6jmUMhOFpoqWlEezePR3EJ5vFMRdm+t5y9mGrLXMnCAIm4SUjP7GRuI
	 L3FXYjYAMWVw2qUDetnaTJfNwIcC5S5zQjJfIh+Zl2r5IiVGRXS2c1Itm1iDAyZpq+
	 MJq+SbgCycrhI9FGg6I8fAouZwlqcGnt9hM009j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 436/602] drm/amd/pm: make pp_features read-only when scpm is enabled
Date: Thu, 30 Jul 2026 16:13:48 +0200
Message-ID: <20260730141445.127562350@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

commit 53c78ab388bfc1a4d72e756815d0db0a842c812e upstream.

SCPM owns power feature control when enabled.

Make pp_features read-only during sysfs setup by clearing its write bits
and store callback.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6a5786e191fdce36c5db170e5209cf609e8f0087)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -2509,6 +2509,11 @@ static int default_attr_update(struct am
 		     gc_ver != IP_VERSION(9, 4, 3)) ||
 		    gc_ver < IP_VERSION(9, 0, 0))
 			*states = ATTR_STATE_UNSUPPORTED;
+
+		if (adev->scpm_enabled) {
+			dev_attr->attr.mode &= ~S_IWUGO;
+			dev_attr->store = NULL;
+		}
 	} else if (DEVICE_ATTR_IS(gpu_metrics)) {
 		if (gc_ver < IP_VERSION(9, 1, 0))
 			*states = ATTR_STATE_UNSUPPORTED;


