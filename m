Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3B81EDA29;
	Wed, 19 Feb 2025 08:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954826; cv=none; b=pUZJypCrTWiUAH8Nb5sBBNWGPN08VZr7FyYieJvwAz2vflHLO4g4dq6U6sP58zj084MCvm2k9k7ZI0m3qz2ym2b090hn7/VTMAPqjahHwFawzzA+2bKaMQ60oZ/YLFa2PZ7p/HaBifwvzi4f7Yd74XCqXxrhgE6GaTCccHezYBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954826; c=relaxed/simple;
	bh=EcJu6Hj7XmSMrwuQ02rYVBppotBdQ4S8XYHnIvHn09E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTGY7OrfamDk/3T4ZTUd9mmD3kkW33gUlAzDxuVrpXJvZ8quu0Fk/SR7U67xcm938tIWOo93KmeDVq8YdVEn12igsUk0dFVvO2I3F8l3TpJTGMVRZ9fPpnFZFlbGLT29vvYgz0Fw2XrRAVANvZMQ7/fok+63x5FlbEDiSsRrcVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JciLtDHN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JciLtDHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465F6C4CEE6;
	Wed, 19 Feb 2025 08:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954825;
	bh=EcJu6Hj7XmSMrwuQ02rYVBppotBdQ4S8XYHnIvHn09E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JciLtDHNU/0jnqEBzW2aBUkh6GNbwovzJRewnnNvN814T0N7Pxg6exp2LCiM1Fg8M
	 JROSntb+MgNmGEQ+/Zj/dyWnnzSm5E2tDGR4UQ5URoXT9hlfBegVZhPhc7X5v2FgEL
	 a18Pe5qUhB7XjfQL7qtDlH0Be4NO8/2WH6E3kRzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Jiang Liu <gerry@linux.alibaba.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/230] drm/amdgpu: bail out when failed to load fw in psp_init_cap_microcode()
Date: Wed, 19 Feb 2025 09:26:05 +0100
Message-ID: <20250219082603.589896095@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jiang Liu <gerry@linux.alibaba.com>

[ Upstream commit a0a455b4bc7483ad60e8b8a50330c1e05bb7bfcf ]

In function psp_init_cap_microcode(), it should bail out when failed to
load firmware, otherwise it may cause invalid memory access.

Fixes: 07dbfc6b102e ("drm/amd: Use `amdgpu_ucode_*` helpers for PSP")
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Jiang Liu <gerry@linux.alibaba.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 0b28b2cf1517d..d70855d7c61c1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -3713,9 +3713,10 @@ int psp_init_cap_microcode(struct psp_context *psp, const char *chip_name)
 		if (err == -ENODEV) {
 			dev_warn(adev->dev, "cap microcode does not exist, skip\n");
 			err = 0;
-			goto out;
+		} else {
+			dev_err(adev->dev, "fail to initialize cap microcode\n");
 		}
-		dev_err(adev->dev, "fail to initialize cap microcode\n");
+		goto out;
 	}
 
 	info = &adev->firmware.ucode[AMDGPU_UCODE_ID_CAP];
-- 
2.39.5



