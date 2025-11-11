Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3536347BDB;
	Tue, 11 Nov 2025 01:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823227; cv=none; b=dePqOEk1qVx5+aWc7xCmah3OHqPN5E/in/Jmc+nBIgCyR5nypieGqDEp+Twzn0gtMJNCTLmj4aGyuwEXYlFpmwiC1qq+PiRH6UZ9Imgf+j5XBhzSW/+qWKqRap4yhEC3D9WMgefI1Il+FARlheFfjqMsNoGGDP8Ry3ICJNKtWvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823227; c=relaxed/simple;
	bh=O8/g7ZnNBPe+0UALuo4D9f2wsCcQ25qicnk79Ol0elI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sda5KHSht37mH1T/+dGwV8jq7igx86KtAhiypr4gWZm0ZGoclaPyiT0V+qCR6xqmU/ShorNyBYdQZsWrn8ozBn/kmWV6n1lDYSt12WaUMCTXXoZKx5oQxlrxxOLzfnLjBsVDSJgiKTtwNRwWWrIR3eqyX1Apm9LTG/Bcv2E1++A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YU81WgN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YU81WgN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977D6C4AF0B;
	Tue, 11 Nov 2025 01:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823226;
	bh=O8/g7ZnNBPe+0UALuo4D9f2wsCcQ25qicnk79Ol0elI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YU81WgN06KprIdVc1rW0dT/v6bd2ldbpp4Ohrz/kJvz36hytJGwl/gVf5NofyXscf
	 Y4Y+dnXcN+Ztm4KYRKxOxhAhkwS5kzW9xRlK0EsXBgXMBxhHw/qPKa1qCCszj0bOr3
	 vIzD8pv6dyQBtqAzyFUVIkcFmE5d0b0JDk/wuClM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 257/849] drm/amd/pm: Use cached metrics data on aldebaran
Date: Tue, 11 Nov 2025 09:37:07 +0900
Message-ID: <20251111004542.644846971@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit e87577ef6daa0cfb10ca139c720f0c57bd894174 ]

Cached metrics data validity is 1ms on aldebaran. It's not reasonable
for any client to query gpu_metrics at a faster rate and constantly
interrupt PMFW.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
index c63d2e28954d0..b067147b7c41f 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1781,7 +1781,7 @@ static ssize_t aldebaran_get_gpu_metrics(struct smu_context *smu,
 
 	ret = smu_cmn_get_metrics_table(smu,
 					&metrics,
-					true);
+					false);
 	if (ret)
 		return ret;
 
-- 
2.51.0



