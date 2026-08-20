Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DDB37C90E;
	Thu, 20 Aug 2026 15:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238340; cv=none; b=gTDQX3ge09Z00LwHkhuayeMjJHYsWQjqNAApdLrhVutKMO2i1evvkMrtVjK/AjC1WRZ5def/wJidPU5ADypQMHIxhp7Ln5ccRmasQxWvjv8JzD1uGv3dY/lTQTOr//6fnqL1YrbXhfyU1Yx0vFu4oT4vvaWQH2FTY/uQvBOqVpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238340; c=relaxed/simple;
	bh=9oKtdOameHKXbyRFQBEHGetc6pU6gJbZam8/iIAdK0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0HB+fqTRpcn0SMIq+9osdFHaSBVyv8anHNANi8bhOmU9tUDOXLLa+RQWTICZNpVeKKbiBqF5HC6lohGh5rPucvydEyBaHIJZ9Hl4jQ/sUSfwMNDmiuqIG+eDDWhG04vdMgL6IpDH1vVgaFjipZKGaxkGYaNTnRD5bWY4ybuxXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6CoT663; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6CoT663"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19AC1F000E9;
	Thu, 20 Aug 2026 15:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238339;
	bh=uKYJPt0w0hqUhZf85ss2jnbJNh2or2CMhDPMB7/bcqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U6CoT663IM6dypXfAq38ZFBvonzglwApytSCOK2abtPRrzqSteXCNp226YL+K/IIs
	 oXMQS0+qJgThAbnqvwQgJUGnkT9bHOgQ40gOif+e78mxG/n+kWQtgKJ1G/k1JFnOuN
	 Up9LOmzzvRliwWdZrXuAZ4EVT6+RW2aj7X/x4SUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 114/228] drm/amdgpu: Prefer default discovery offset
Date: Thu, 20 Aug 2026 16:54:16 +0200
Message-ID: <20260820145248.101236514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

commit ac828b94e027d29af82325fcc55556dc8173fd85 upstream.

If a valid signature is seen at the default offset, use the default
size/offset for discovery.

Fixes: 01bdc7e219c4 ("drm/amdgpu: New interface to get IP discovery binary v3")
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5447
Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 46a0df99a0b2fa2fa61d864b04b6a5d5fe748779)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -310,6 +310,19 @@ static int amdgpu_discovery_get_tmr_info
 			goto out;
 		}
 	} else {
+		if (adev->discovery.offset) {
+			u32 signature;
+
+			/* If VRAM holds a valid discovery signature at the default
+			 * discovery offset, use it as-is.
+			 */
+			amdgpu_device_vram_access(adev, adev->discovery.offset,
+						  &signature, sizeof(signature),
+						  false);
+			if (le32_to_cpu(signature) == BINARY_SIGNATURE)
+				goto out;
+		}
+
 		tmr_size = RREG32(mmDRIVER_SCRATCH_2);
 		if (tmr_size) {
 			/* It's preferred to transition to PSP mailbox reg interface


