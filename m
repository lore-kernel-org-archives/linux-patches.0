Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920DD2FFF94;
	Tue, 11 Nov 2025 01:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824783; cv=none; b=EDcQ628ia2sIXUxTIZlKgzMXS7ZfFgkC1OxzbS38U+Q9FdTndzdE2VmhZY69zABOQXJ7xGAvgq4a2benH5Yx4Ivi+Vl9tGPnJ5C7WlaVcewCHF3Yug0l5KaJiRyzbmP1qd5/JA/By3dDIaodjrcQaS5Ce+lDm+EQUUtikpdkpfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824783; c=relaxed/simple;
	bh=3lhFlEh/IovjRX+pHcIl7McbVqNFOzHAiQ1jeAwQqIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GyeE+LrR5iDU8pifB5UNP7+Ebtzkjzd7BothYyx22ZBwgDwWeE85W7b6UnDjKt4n0Zy/pAu162WxKaqZz0V4/BZj3pu1i89oG6nWvAevI2hWlP/oj5cgGvn1FiylqsI9bzYDcDGaG1fkYTXkf1E845BcIxmzFbEoXTNvxzgLjlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kloif5cb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kloif5cb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105ECC16AAE;
	Tue, 11 Nov 2025 01:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824783;
	bh=3lhFlEh/IovjRX+pHcIl7McbVqNFOzHAiQ1jeAwQqIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kloif5cbg02nrnunCTgF1K1puLxNLIqYO6TtklETf3xpAu/5mTZF9X5L96oG8rZfs
	 HPWThMeKBVjMQW8EIo+rtj5hBFwNW2TYNYZmi4rLifRkc1CS1YBUl7kIuUc2strW4D
	 E6sl2LCmnGhqiRYWoa7wIebkCcx9Kr2s2k7PdERc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 569/849] drm/amdgpu: reject gang submissions under SRIOV
Date: Tue, 11 Nov 2025 09:42:19 +0900
Message-ID: <20251111004550.168373662@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

[ Upstream commit d7ddcf921e7d0d8ebe82e89635bc9dc26ba9540d ]

Gang submission means that the kernel driver guarantees that multiple
submissions are executed on the HW at the same time on different engines.

Background is that those submissions then depend on each other and each
can't finish stand alone.

SRIOV now uses world switch to preempt submissions on the engines to allow
sharing the HW resources between multiple VFs.

The problem is now that the SRIOV world switch can't know about such inter
dependencies and will cause a timeout if it waits for a partially running
gang submission.

To conclude SRIOV and gang submissions are fundamentally incompatible at
the moment. For now just disable them.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index d541e214a18c8..1ce1fd0c87a57 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -286,7 +286,7 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
 		}
 	}
 
-	if (!p->gang_size) {
+	if (!p->gang_size || (amdgpu_sriov_vf(p->adev) && p->gang_size > 1)) {
 		ret = -EINVAL;
 		goto free_all_kdata;
 	}
-- 
2.51.0



