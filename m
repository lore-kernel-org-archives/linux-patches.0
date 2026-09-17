Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9756D4FDA7F;
	Thu, 17 Sep 2026 17:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667293; cv=none; b=UVr+3JYNM4WsPqCjrIgDvSkBOROyLp0945tvWVTUGzIbmOzhef84DAAAkYerIF4m/aTKrAjxfTa0fyL7Nt3bEZMZt80gRyhOcCl4N17HCypRJJm7w0mbjhJI/aw1VHuBlk5ymoPZkSG+E3y5VQxt5V7yoN2PZfxLs6UISCA5VrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667293; c=relaxed/simple;
	bh=Z9EHJsUCJyKqabrcISk0nAbBU2upy4Y2Tx2XUycat3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCV3may+7htoZNPYdsZgx08gnYPt/fLScg+tQdn/ll+NU/vc7qcgVhjzrmr5pl2gT5ARTmaRWrm3IYpWqAVs0W5QtX3MFe3k+d0F+V0pcUUJIZtRyOPnTrLOjFS/JwmwcD+xMD96NgMIcHHbx3ejC0WyVD24Q0eII4aCL+hWPeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFP2FSV6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFP2FSV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECC91F000FF;
	Thu, 17 Sep 2026 17:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667292;
	bh=isafDg8HbF4bWgij2WNCYfqe7zl0VCcWCYcL+w/BHGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qFP2FSV6RqW8mZAZIVxomCQT3eLj1Yc8MA9PTTV/StCpm9FE+jYeNaGBjfebeNMrt
	 y7alZohErJS9urdOwMtpi8T9+rgZGRCrOCmNIoutNnNPmXFpfGXAlBT1M86azYVXon
	 TzalxvYvnpYz0RrHErLTgUjggRE+ABJScF61b0Rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0007/1102] drm/amd/pm: Check SMUv13.0.6/12 metrics integrity
Date: Thu, 17 Sep 2026 15:59:10 +0100
Message-ID: <20260917151539.606431173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b79a2b66d30d0..c0348f9ca47a6 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
@@ -537,6 +537,10 @@ static int smu_v13_0_6_get_metrics_table(struct smu_context *smu,
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



