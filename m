Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF9418CC11;
	Tue, 10 Sep 2024 09:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961655; cv=none; b=ZAVPl3oWZYfzLaVswt5BWw9nsXivlBKG9s8wRnnACPXsvsutjGVQokqioMW6KCLJR/0UB01WOSn3TwYilHPOSFfKkOfuPgKRBgZvbcwxSw68uFcRQc7A32CCeIzDH4Xv+uocC30iVZFFdBIN3MCyk4/36jR44I9Wu1f9o2UC6tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961655; c=relaxed/simple;
	bh=GhMeRf/8KTrTYFqvd2Uh4S8AknV44Xla9aSR802YAfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqxn8NsHHtrhUde1cMDpm+OPpPiimSo4EoTXf7sSghA2EXS7qARI1UZ0ZOU9rYBlc3fgvMwFwUPXfkmaA7w9Kap2hSE9X9zhLXYnuWdHjwnd2dqViSnc+C/f6n/REkJmyFsbJYJMp0XhKK/hixTp1u0mPUQifcsjAKKxImtQtbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fRM4rWe7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fRM4rWe7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130E5C4CEC3;
	Tue, 10 Sep 2024 09:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961655;
	bh=GhMeRf/8KTrTYFqvd2Uh4S8AknV44Xla9aSR802YAfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fRM4rWe7tPlCgCLMDIkVzfBv5dS9wA0M6OBxdQQxiZC7CnPn0rh8QPyuVVwlvQXIO
	 +CZItsrKON3LDsUL9YbUPnkj4hdJUhBal4e89zNCLz/aqF/HD8RgdB8avjXLFMnNmc
	 OHW25BpcCr+hrepDE8mQJeH+qPy002dTkqp2Fn+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 144/375] drm/amdgpu: Correct register used to clear fault status
Date: Tue, 10 Sep 2024 11:29:01 +0200
Message-ID: <20240910092627.298905318@linuxfoundation.org>
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

From: Hawking Zhang <Hawking.Zhang@amd.com>

[ Upstream commit c2fad7317441be573175c4d98b28347ddec7fe77 ]

Driver should write to fault_cntl registers to do
one-shot address/status clear.

Signed-off-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c
index 8d7267a013d2..621761a17ac7 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c
@@ -569,7 +569,7 @@ static bool mmhub_v1_8_query_utcl2_poison_status(struct amdgpu_device *adev,
 	if (!amdgpu_sriov_vf(adev)) {
 		/* clear page fault status and address */
 		WREG32_P(SOC15_REG_OFFSET(MMHUB, hub_inst,
-			 regVM_L2_PROTECTION_FAULT_STATUS), 1, ~1);
+			 regVM_L2_PROTECTION_FAULT_CNTL), 1, ~1);
 	}
 
 	return fed;
-- 
2.43.0



