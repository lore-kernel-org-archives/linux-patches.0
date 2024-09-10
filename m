Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3661917E1;
	Tue, 10 Sep 2024 10:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964364; cv=none; b=iaqi9ONP/d3hlibs2f+ErT2hNekUu5sgnR3ro1wPTbmeviqZVt63ZhBifgafzFVss3ZMS+Xog/FE3T+REOQ1fYTise6HVbxiKe26EcO4NngiAPeSIlRZLfV0aVmZnCtx0yYI5uFQIEHOKAzgojqmXhOQj0pjvG3Cfdt6cM0RrAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964364; c=relaxed/simple;
	bh=ZhR/fPbCBhUu4nZYaGxLPaTfk7ZJGWUbvjYpBGJJiNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHyU3NsaBbCogL2rb/ncOecrFdzlqxOLbjPjs6ZLqF1+uy/141mCSMb75FH/zDdV7HjyFMZvdIG498qPHdZih9686/EjrxcaHcdRaWMQAMmAaUpp7vu2V7QC8Hu07m4ZMbBXtB7GDUzZkkRUN3WfkuREUorg6bb9DyxMTuJoB4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zza710/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zza710/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158B6C4CEC3;
	Tue, 10 Sep 2024 10:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964364;
	bh=ZhR/fPbCBhUu4nZYaGxLPaTfk7ZJGWUbvjYpBGJJiNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zza710/VtKEJ/eUy8V6M8ItXJivmHPWZ5SQQ1kfwDb3hTEaE6OeOxdOt0Pk9fXy/+
	 kym8Zq9ZeU7RYyuyGAm1ipEwdiWJnhDuz2lmvhsG4vD/pWjKKASDm0k4fa4Ub7W3Ra
	 TXryAsMBhMhdeRmCaSk/KMnxVuVhnZkQQqtbVYdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zha <Yifan.Zha@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/269] drm/amdgpu: Set no_hw_access when VF request full GPU fails
Date: Tue, 10 Sep 2024 11:32:25 +0200
Message-ID: <20240910092613.822311539@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d9dc675b46ae..22575422ca7e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -137,8 +137,10 @@ int amdgpu_virt_request_full_gpu(struct amdgpu_device *adev, bool init)
 
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



