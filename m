Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE56D1922D0;
	Tue, 10 Sep 2024 10:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963782; cv=none; b=WLhbSzrKYwyFuhh1r4NRod3jHxZur52wFNTFcd3RRaIVJRgHuJ9X1W7DQ27i4HWQ8+7ymLIJlDDBLjaLKbefGeHCh84jhvvu3pUzHOitQjCvas0IitE4ksYJjg//3lgEWarmGZzLrafq8QlTJB+6I8lYzqTqXzbKGGnUtEPW+WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963782; c=relaxed/simple;
	bh=/isopcc05Q0tTnSGm7DqizdDQMN0qxL10KNTtCDxwQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JatpJohIowkWMwSh/m3iAGjJpg+ZEYTI4rZ3oZftJR32m33rieXpgn8AS4+Wompx4KfaNhYmEVY9//gN2YJlst13CA2V+BBRksQFIySR/xtJqDfvGMjqHoCUxczW/9nNFEwZosgx8Tnlgkju8l1XrFoKsE0bYy5aOnXM7uaRh7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ggzW0S6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ggzW0S6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBB3C4CEC3;
	Tue, 10 Sep 2024 10:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963781;
	bh=/isopcc05Q0tTnSGm7DqizdDQMN0qxL10KNTtCDxwQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ggzW0S6Bn58Xbd+pJLgBZSZOrC/Gnlil1YZq2T/DnxClu643e9XDtfvVJn42/xtsp
	 wTnzLzYcVpB11cpLfrtmSVS+bv11sJHJUtcdAlPlffppQsYMjefbTk5wwmNYsHXX+r
	 s1D8xz76V3PNqCv60WWo5bJzKfUs8V3FlIFFUzB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zha <Yifan.Zha@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 147/214] drm/amdgpu: Set no_hw_access when VF request full GPU fails
Date: Tue, 10 Sep 2024 11:32:49 +0200
Message-ID: <20240910092604.756296336@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 76fc0e8dcf9c..59007024aafe 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -122,8 +122,10 @@ int amdgpu_virt_request_full_gpu(struct amdgpu_device *adev, bool init)
 
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



