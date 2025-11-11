Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11500333443;
	Tue, 11 Nov 2025 01:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823381; cv=none; b=FQjbXNKjfFXrLWmc1mIDMBHpaOo3t6CCnIh5E9lmM6Giyrl1uYHeRp635MGNAobX5Suszg6wCP8JmaGc9C166I0okUcV+z+C9deUBRkMA0qtDEYqz2NgsV6nwXn1CW/sz4ug5wG44TUUAdL03PerEE0nZ99tu2cm8HbWi0/bzDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823381; c=relaxed/simple;
	bh=Werwz94Znl7xLYwhnmjzb8LBojsaf4IV+wZbvmmAa9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kv2TyhmZOOn2Cx52elPZT0jnVekLL6PooNK/CXW6IG/+jF8GQUDVV9R1oxBdXI3bZmoynm+Tcuc8E6p3Vqzo5Dy9YCQAm/uhgs1x6YhfbQh4kzMu2fGPM5e/ZY5fOHYFU5yoKQjPWheIiz0fs1ldIuWRnFNXMN9zUOv7HeihsaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zCb7m8M8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zCb7m8M8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630A6C116B1;
	Tue, 11 Nov 2025 01:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823380;
	bh=Werwz94Znl7xLYwhnmjzb8LBojsaf4IV+wZbvmmAa9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zCb7m8M87wPoCzA2aaOAmkkoqax+eQidZKBt26+7rW5zdkHiBnDi7g+THF4axsx9m
	 nN/S5wA6h52E5YlqXfhNPLM1Zruj8il3wfhA7hsQlQ1H+bYX/tR7dKseSt1WzpnqaE
	 OTDlcwJrCG8ymwqX9KHVQUXxClB3rZ00AlP3t3kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 186/565] drm/amd/pm: Use cached metrics data on arcturus
Date: Tue, 11 Nov 2025 09:40:42 +0900
Message-ID: <20251111004531.117801606@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

[ Upstream commit 2f3b1ccf83be83a3330e38194ddfd1a91fec69be ]

Cached metrics data validity is 1ms on arcturus. It's not reasonable for
any client to query gpu_metrics at a faster rate and constantly
interrupt PMFW.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
index d4b954b22441c..3e52668a98b4c 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -2326,7 +2326,7 @@ static ssize_t arcturus_get_gpu_metrics(struct smu_context *smu,
 
 	ret = smu_cmn_get_metrics_table(smu,
 					&metrics,
-					true);
+					false);
 	if (ret)
 		return ret;
 
-- 
2.51.0



