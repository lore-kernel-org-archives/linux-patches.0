Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947F73A48E3;
	Thu, 17 Sep 2026 16:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660963; cv=none; b=m9r+ywHp8jSMleRnT4wVbO26x4DkdhYoLmd+ob02q3iLuChjt2WMAzbdrlF77KI/KNpDQWM13/A8q5ehmrjAUj8qa2IPdHoNy8esJrn1rpO1+qHjhISSbbRCF9y5l/uNwVcMhgGf+OJOEa83gswJziEs16TJeSPedtDAw1fJURg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660963; c=relaxed/simple;
	bh=yPvt09mTpX1im74MXAOx4KzHLRrjpkYrYQKNPoFPP8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LM1aM7iNakn08Z9AVtrajaQ7k+MZ38YoGCiisUw6N6ABOI7k21HUK+guHzVFXGcg5UJtiaSvaJepmgmNdhrm1ONpfkV/eXN00xXOoDF5TQg+TFXk4R6gkwRE6kYMwh9eD0BJcjtjEbKLAzYCUQOjgt9bEsro1raOXphZWPllXZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lfh0GEIL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lfh0GEIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6CB1F000FF;
	Thu, 17 Sep 2026 16:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660962;
	bh=0kC/Wz6TV6URb5MvUbbj2F1oPTh7mtwNLU/mzRTwu3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lfh0GEILBcWFNBJY+pdT5+O44RVs96VywDhApg1oX1keVwjKKcVwT3zIKorIKDny9
	 5b1TTCs/McKf+0cZRAtEhQwvPKBph635NLun4o7XMep4j8WpajtbYJhthLnoWY+HB0
	 iN/pVJMN29hR1ZnPpGV7oGxY4D21tA9cp8G+PM28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0011/1250] drm/amd/pm: Check SMUv13.0.6/12 metrics integrity
Date: Thu, 17 Sep 2026 15:56:46 +0100
Message-ID: <20260917151552.229896939@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 6fc63d80c01a480e3d2c98620f07d46e5bcfc85a ]

Check if data fetch is proper by matching the first few bytes against
0xFFs. If 0xFFs, that means data couldn't be read properly.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
index 43965b1135fe7..0d065e4073655 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
@@ -768,6 +768,10 @@ int smu_v13_0_6_get_metrics_table(struct smu_context *smu, void *metrics_table,
 		amdgpu_asic_invalidate_hdp(smu->adev, NULL);
 		memcpy(smu_table->metrics_table, table->cpu_addr, table_size);
 
+		if (!memchr_inv(smu_table->metrics_table, 0xff,
+				min(16, table_size)))
+			return -EHWPOISON;
+
 		smu_table->metrics_time = jiffies;
 	}
 
-- 
2.53.0



