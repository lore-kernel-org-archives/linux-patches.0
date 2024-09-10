Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE66118C038;
	Tue, 10 Sep 2024 09:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962366; cv=none; b=Q0M5xmABd7Fvto8NSyUwme8gdUZ0nwy8ukC6D2ziOQPq/99fmgqxG/pFR7vKj/w5mZbRnNXVZ5nEVRITDP9giXGOPh38zSYjmMiYOCK7+rqBoCaDsQaEnlOXbO+V635pPuCfHZNcOwYHfgy4oM0yJ5Q9dRa4dBeGKngHCr4nNGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962366; c=relaxed/simple;
	bh=jC/qTTzhdmO1S/KRr9FoBm33yzZKXUz8cjzYSip5Qxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxXgvlSpUikgkwVoyjUNAUbfYcJiABltMlGH92d4ceD3FXj7DlWpiLFyprBdk6CstSAZAzvLcqceIjozlpJJOq2lYELchUewvbzOkDkBMLv0zCR3GIX0VjBToKAk+Fp/j9YMjnuN0ZA5fQsZILb2wsPMXXTJdAI/kOITcZRpMtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vs/nL9DC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vs/nL9DC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1A7C4CEC6;
	Tue, 10 Sep 2024 09:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962366;
	bh=jC/qTTzhdmO1S/KRr9FoBm33yzZKXUz8cjzYSip5Qxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vs/nL9DC6P3sHMa236wbpzrE9ycXkqlwJu7HE59EfSaoQfjP9ucAlIaighFRnO4fp
	 gHCNFKr83dwLoApKt4nyiZCaGBNy4vYI0OQseSGCWMbpZwaNHOOG4uHkMghn1WovmD
	 YQGuyYOitevYL/VnNdw/ADQtstIF5eJQaDjKeiT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 010/121] drm/amdgpu: fix ucode out-of-bounds read warning
Date: Tue, 10 Sep 2024 11:31:25 +0200
Message-ID: <20240910092546.236888823@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <Tim.Huang@amd.com>

[ Upstream commit 8944acd0f9db33e17f387fdc75d33bb473d7936f ]

Clear warning that read ucode[] may out-of-bounds.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cgs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cgs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cgs.c
index 031b094607bd..3ce4447052b9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cgs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cgs.c
@@ -213,6 +213,9 @@ static int amdgpu_cgs_get_firmware_info(struct cgs_device *cgs_device,
 		struct amdgpu_firmware_info *ucode;
 
 		id = fw_type_convert(cgs_device, type);
+		if (id >= AMDGPU_UCODE_ID_MAXIMUM)
+			return -EINVAL;
+
 		ucode = &adev->firmware.ucode[id];
 		if (ucode->fw == NULL)
 			return -EINVAL;
-- 
2.43.0



