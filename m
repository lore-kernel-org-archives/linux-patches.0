Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14B83451DA;
	Wed,  3 Dec 2025 16:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777611; cv=none; b=jKYcDZ1m3ObkBvmBcW+EiSGLUUqQN+n3drTultoiZhaaEvXP0YqvlLUSmNhwPHeWs5JYTcKxaOhUhr6N+dya6XdBbE9UFreCMmFUCz3dz6SneDZbpRtcuULZgCsxVBWwpsxdHZjp9AgYclMZEOQwrI+uOwKdFtc+/FAStYUhntg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777611; c=relaxed/simple;
	bh=JBM5lpxdFWl//mNtql0DutlbgQgGjMyrBagWEN03vSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gVwUkNRx5075FvpmmyZuHnHuSCaxfC3bIIgOazGHW7EiOtdY5wg9OvNuGy3+gOvzQhBLZ8JUzOmHb9QVYdXNHxFPQ4cOdoz9OaTWhK9BCU7hlaRMNmHBS+he+xw6bhjaw1dBL5KeTuLvNCadm84advVgqLl+sLBg80NmaMvtmb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AOolqMl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AOolqMl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AC2C4CEF5;
	Wed,  3 Dec 2025 16:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777611;
	bh=JBM5lpxdFWl//mNtql0DutlbgQgGjMyrBagWEN03vSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOolqMl0BmYHmlrNp+hR5t4ZRCIuECrkONDVDHA7pUDx0gwK1k80hm4zeRTdUu+/C
	 968zS7SVWBrJdhkqEyVy7J7Gu5VTpGM1ErgH5grdYKRrNFQIvGWFXQpF/y5jAZlbu/
	 +eU3tEe745TP0FRkJkPIcZLN9/JHLhUQCN6dwN1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/392] drm/amd/pm: Use cached metrics data on aldebaran
Date: Wed,  3 Dec 2025 16:24:00 +0100
Message-ID: <20251203152417.416842203@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d3389fb374c9b..94dfbdc2ea910 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1696,7 +1696,7 @@ static ssize_t aldebaran_get_gpu_metrics(struct smu_context *smu,
 
 	ret = smu_cmn_get_metrics_table(smu,
 					&metrics,
-					true);
+					false);
 	if (ret)
 		return ret;
 
-- 
2.51.0



