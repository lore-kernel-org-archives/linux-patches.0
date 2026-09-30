Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C20E51D528;
	Wed, 30 Sep 2026 18:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793877; cv=none; b=SbhT+kPRYl6U4EiRGABTQxiA77i04RROugIOyFkf6qpLinqcM7Bxgh7vDLu3Zu71uP6w5Im7Tx3F+xQrR7/D0C5K1G4O38kQQ+SeQQlAf97sr7I38hIESJKqkBLu+5PB1ZlyVorknsYuvl0HIMeOLJNz9c2iovVEU79DSi20uW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793877; c=relaxed/simple;
	bh=VV9q+yPOZVdEL3Xay6ebmL/CfsDp5b6RkrygEMEype0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVNqhKTGEMh/o98kvFFkladfirL5G/XVZPaGQE2p/s0vdsfqOD2iqbLwY/UZMKV473xwr+37A89W0MV3lBNNUkkON1/DThXe64SBDWWHAIQJcUO3ComXm6Gh9Lx06q+VmQbvGxPITqw+pfTEXw7g35iXo+GbalbBmeM4Q64gV9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSaZiu6l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSaZiu6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674861F000FF;
	Wed, 30 Sep 2026 18:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793875;
	bh=1F2Kr8Io41NBDMH23RZLZNWdCaA3B5poTXLBvvV+hQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSaZiu6lHb4LOTJqI3Oo1uWhGBt7phFURJKG5qqknUTFoekC+1fY7o/0FAuVInt+5
	 JCoBrE72kuYsnc2aYj96oajMsmT/aZJ6RGJ0D8I/EdM3nPQdxB7Xh2fw0It18oJxWv
	 zJ72LBTkm3RyGVJDtCiJ9tK/bmusrPzTNRCBtN/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0006/1193] drm/amd/pm: Check SMUv13.0.6/12 metrics integrity
Date: Wed, 30 Sep 2026 17:11:30 +0200
Message-ID: <20260930152434.450015027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 44c5f8585f1ee..4edb631461223 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
@@ -317,6 +317,10 @@ static int smu_v13_0_6_get_metrics_table(struct smu_context *smu,
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



