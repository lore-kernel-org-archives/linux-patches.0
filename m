Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F158218DB2A;
	Wed, 25 Feb 2026 01:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983128; cv=none; b=AIbZZ7CDQAPs41s7to3gZ/jqfSFXskfPJK/hYdADV0SDspglxnZr0AZ/20ua2x39qJUE47CGZovYA9kOSLWcByaieU+RS74Wv+gKAxdIEP+//ILfpdT7J3cudFAVb6XXh6fgf2JOUUc9UQuLokFwB9c4UtgzqDFC3gbqx8Al8xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983128; c=relaxed/simple;
	bh=qEjrdw40bY72BwK9Lmbt0u5JUUJ2RCjlrFBoMLZXV4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m64bVMV8oyWNZW1lbDSGPx0fdVAo1eGy2ExGHpYfaUJs4f+pgVlXTHsqVqfQj6xoiuvkJc8Tcs70PUMiqMgVyiKDykNF0yigsSLtUqzVP4Jbg3fwB+b/tv9LoN+pIgxQ0RImpbMmE8zKDgd5wz4gpE2Vz5c5H4NBlfNO/nAD9ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o73Ojg59; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o73Ojg59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0C2C116D0;
	Wed, 25 Feb 2026 01:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983127;
	bh=qEjrdw40bY72BwK9Lmbt0u5JUUJ2RCjlrFBoMLZXV4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o73Ojg59wGQpkvh58X3dtDt4Qaz1FUa/yzI25AKza5zvW47z+q7Rta/1p+iHNqtkR
	 OjLtsMpkD5HWosuQPrWHbckqT2n3wwbNNlqsQB4ofAqB/OXnLSVA/lh1RbJUwirWok
	 w6NB53iZnDgRKqnESVVlQlb+k2bubi0c1KWM0Ork=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 285/781] drm/amd/pm: Return -EOPNOTSUPP when cant read power limit
Date: Tue, 24 Feb 2026 17:16:34 -0800
Message-ID: <20260225012406.695496347@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit e53dcefe30df4f317161f36e8bc11926e7dd7a2e ]

So that hwmon_attributes_visible() will see that the power2_cap
attributes should not be visible on GPUs that don't support
the get_power_limit() function.

This fixes an error when running the "sensors" command on SI.

Fixes: 12c958d1db36 ("drm/amd/pm: Expose ppt1 limit for gc_v9_5_0")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
index 302af1fb6901e..9c9e96655c4be 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
@@ -1589,7 +1589,7 @@ int amdgpu_dpm_get_power_limit(struct amdgpu_device *adev,
 	int ret = 0;
 
 	if (!pp_funcs->get_power_limit)
-		return -ENODATA;
+		return -EOPNOTSUPP;
 
 	mutex_lock(&adev->pm.mutex);
 	ret = pp_funcs->get_power_limit(adev->powerplay.pp_handle,
-- 
2.51.0



