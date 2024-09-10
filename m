Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE1618C90B;
	Tue, 10 Sep 2024 10:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963006; cv=none; b=Gund77rZ/FFiu9FRj2qzKru6f6jcK/eTWPyQXlmve9bt1WB1p1hT2IUhzwIt7P8Ffxs9muTPSSwi6o4YYW0LpPKd+LfuD3y7ki7uoBqeL6OGPHq130a6Russ6N5WDC3reZwGrPJyJysvx5Y0WwnXYZnZN+2wDYoCtDGxCJeCvM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963006; c=relaxed/simple;
	bh=4wBjWdfpmMQUeJXWEWj9bAihF++Bi4vK7LrYqdICbvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BD6eBNMhGD63EHvJbZX2gKa6StRl17U6LIqILSgpkAtCr8RlzrpcoHdtAOL8VOrg5FxX5U01CXfi1e9nsUiH+zRI8w/JQlCXcVAUVtEE/HR7ACCAlVTsSzDqI962NKtw8S/hKt8nJrpm28qT2eMMBOj0nsIF2TkWDBlFMteTlYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vy6P82zg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vy6P82zg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132D7C4CEC3;
	Tue, 10 Sep 2024 10:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963006;
	bh=4wBjWdfpmMQUeJXWEWj9bAihF++Bi4vK7LrYqdICbvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vy6P82zg3bP6kcyktspyS2pKvdfbFuJopDKOPIX3XBTYCnHAolK8fkAhxH1NkdhGK
	 ri8RbisH5jOEnUzf7wI2B+IBm17g09sP9ELjrcCLgD6QjsU6+DMu7WMScRBoAtYbEK
	 +QI00AdUiPi14uMSJm8TcIwwsZyUw8TF1BJDlpnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zha <Yifan.Zha@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/192] drm/amdgpu: Set no_hw_access when VF request full GPU fails
Date: Tue, 10 Sep 2024 11:32:07 +0200
Message-ID: <20240910092602.245523374@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index af50e6ce39e1..d7b76a3d2d55 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -132,8 +132,10 @@ int amdgpu_virt_request_full_gpu(struct amdgpu_device *adev, bool init)
 
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



