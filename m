Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C2646444;
	Tue, 10 Sep 2024 09:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961973; cv=none; b=pZYX0p2N+WD2jj/+TxyfqqefsbiS1Sp0ca1LOSEUWtY6K+JBjAnd90L+7Ua6e1L6hE+No/bY6vCWz7EBZhbKrFAwzm/3Ar+y7TEhKyW5lZFs/wBL7a4zHrn1R6XovpBfWcS3shiWVWxA8qha0uv5RBi1Vj50CaPyZgEnS1IqTE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961973; c=relaxed/simple;
	bh=wYjIpljZcuWuWbjelac492Ozs4ube78pczWBr+lnarA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9BOUYFyp1HeGuSsu94Nnv8Y1AX/Tj4YB52YFBZjj0znDFKhhQzvOScQL12SzF/ae/9UNhe3xXFG2k2qm0xAZ55kWnIj+rNY+qEaSwzh2NudkJ8TMXyi6qr5oR3p2EZ9yPPxBc+x28JHGtB7r6Yk+CJyr0hM8FUaI7oQrEivqMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=astx0GhL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="astx0GhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F85FC4CEC6;
	Tue, 10 Sep 2024 09:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961973;
	bh=wYjIpljZcuWuWbjelac492Ozs4ube78pczWBr+lnarA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=astx0GhL2f9sxvKJc/O9bxKKQOZZ2MsWI014Yh3vWY6nBSauDnW25bAvGIsIu+SRT
	 tn+GbvgMkeOi/s4KERRFz0HX2EGLfoyL7LvCg8cC7ePA4c43sUuevY1MMGgpdeP3de
	 cqvGG2m+IpB7DaRjfLWIBHCgBdt0KKee0JLxSCoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zha <Yifan.Zha@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 225/375] drm/amdgpu: Set no_hw_access when VF request full GPU fails
Date: Tue, 10 Sep 2024 11:30:22 +0200
Message-ID: <20240910092630.103514950@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifan Zha <Yifan.Zha@amd.com>

[ Upstream commit 33f23fc3155b13c4a96d94a0a22dc26db767440b ]

[Why]
If VF request full GPU access and the request failed,
the VF driver can get stuck accessing registers for an extended period during
the unload of KMS.

[How]
Set no_hw_access flag when VF request for full GPU access fails
This prevents further hardware access attempts, avoiding the prolonged
stuck state.

Signed-off-by: Yifan Zha <Yifan.Zha@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index 2359d1d60275..26cea0076c9b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -86,8 +86,10 @@ int amdgpu_virt_request_full_gpu(struct amdgpu_device *adev, bool init)
 
 	if (virt->ops && virt->ops->req_full_gpu) {
 		r = virt->ops->req_full_gpu(adev, init);
-		if (r)
+		if (r) {
+			adev->no_hw_access = true;
 			return r;
+		}
 
 		adev->virt.caps &= ~AMDGPU_SRIOV_CAPS_RUNTIME;
 	}
-- 
2.43.0



