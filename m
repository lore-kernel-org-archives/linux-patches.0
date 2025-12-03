Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D065E31329E;
	Wed,  3 Dec 2025 16:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779035; cv=none; b=QQN3H3lv3M2n2If3bpW23s3YR58f3vs0EPipVrQrEmJEZGxvyRPIzydm9Lw3fl8uCEv1mt9sdbxfQYGMQDErhy/MBQx+2xf0QHvk3PGpaT2fFosx8tZWLHrZ+EmDPsSYKpllvwqaYXk7Jk5h3iNZ9IymNcNly1Yt+pb+racHyxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779035; c=relaxed/simple;
	bh=ONOgZFPuNl2x9VkB26LAlxd4/KRMHMfn/NcLJvG9mlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsSEkuGZHC2vCk/71twNUKAm3hybm+d8ubRfrZDbrjzWh2kd6ER9J98YaORb6NK+qSziDURfmo5q/JXcTcriT6oWQ0AQJ4Be36PrXZAhuJYqpDD3dZlEj/sfsAjLrj12Yyw3LM3LNjUBe+Hlr4ttc8PKQMKjFwDBZ84mcLtiDEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1hcuHY2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1hcuHY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2241EC4CEF5;
	Wed,  3 Dec 2025 16:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779035;
	bh=ONOgZFPuNl2x9VkB26LAlxd4/KRMHMfn/NcLJvG9mlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V1hcuHY2DFyGz30lvh27HVszOWlH7SvVpl1GgD7WrqacFHKSslCv5WY9fik2blMc4
	 fSc6TGJc07ZZic+m9THEcyvanZVPDGPUl0440V946MTnO2pAEfOFU6ttY0BxhKbPGA
	 c4463fx2mmLq7hgHKg9ZmohXVm60BSN7MFDzWmVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 134/568] drm/amd/pm: Use cached metrics data on aldebaran
Date: Wed,  3 Dec 2025 16:22:16 +0100
Message-ID: <20251203152445.635193208@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1ba1bb4f5bd77..749031d1f4b3c 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1744,7 +1744,7 @@ static ssize_t aldebaran_get_gpu_metrics(struct smu_context *smu,
 
 	ret = smu_cmn_get_metrics_table(smu,
 					&metrics,
-					true);
+					false);
 	if (ret)
 		return ret;
 
-- 
2.51.0



