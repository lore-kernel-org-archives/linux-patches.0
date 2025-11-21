Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D7D34D4CE;
	Fri, 21 Nov 2025 13:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732433; cv=none; b=sAyE+cQfa+p6UdhmcR8U83McrtOfWu4xS3PJtvDD5NCMEZwdHedD4vigLAuDHlF+tZqdElg64Vl770adGSwRhRLHFaPCsfRtDpnnNagTL5LbzgUxFt7ZxJjwSjKSK8/GoZD0+ltxT/lWKJ4YJLjDRBTy5Yhf+FPr1CebZ5F0eeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732433; c=relaxed/simple;
	bh=bEGqkT2L22zBmCyI5NN/iCZKhD+lmsaLkq8c59hb9rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drc9KLm1HN5H4ncUzhN086O/xk6NKr4LYmLq1D+9gppQ78Nc2YEUM6a1PVpp35r1FSarev25fUykcckq7RzjzIqlQWPuossFaHzAPu8EprTHHFXhif6tf9gs+8HxckL885t856gR25SwBVuyXuM5uTrAiO9g7qGMWxAdx0PxTrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZolSkKI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZolSkKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5AFC4CEF1;
	Fri, 21 Nov 2025 13:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732433;
	bh=bEGqkT2L22zBmCyI5NN/iCZKhD+lmsaLkq8c59hb9rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZolSkKIrZEU8mGSaWDWLBmMaHKCFHr9Z9m/KSv1SjxjEMlgw9m+gKT/46JmA2x5c
	 Ehqjuha3tBPm3vDzujuul4CBsDR3ExIVDjlQZV6Xgabp+UxT3S8oNskvCKju6ZRNJX
	 /VwvoMa3nH8YOWLxr829w2k7FOmUt++umKwSisX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/529] drm/amd/pm: Use cached metrics data on aldebaran
Date: Fri, 21 Nov 2025 14:06:58 +0100
Message-ID: <20251121130235.257252049@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b225617801499..d1fd643e7a48c 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1737,7 +1737,7 @@ static ssize_t aldebaran_get_gpu_metrics(struct smu_context *smu,
 
 	ret = smu_cmn_get_metrics_table(smu,
 					&metrics,
-					true);
+					false);
 	if (ret)
 		return ret;
 
-- 
2.51.0



