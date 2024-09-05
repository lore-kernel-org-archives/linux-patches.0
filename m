Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676DD19755A;
	Thu,  5 Sep 2024 09:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529471; cv=none; b=kXQA3D+T0q0oht3giwBEQqCBsDSwUgQEaMT3PucoT7Yn06knbAG/r+2dahTfVmpPmr2XzKfN4QBFyFzOgdfxtd1la3b4gJt4biDtDcf/e/82g+BPCcRYQwsyh24KGgsUMOfboQqKDacWpmVCwsbw7d0C9Zuf/5BwkKkeugnyzK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529471; c=relaxed/simple;
	bh=Ol9lF4j9zpiB09yZjh1TODeX643lqFtz159JU0E8bAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XjNgAGz4pCeBXD3pJ7jZNl1OLQ5sijpxAQKnHQWDvwPbFDw+bKW5IJR9ib3sgMHy/LChNryEY4uEkafUljlEmqtsev4tO655PwAXfcTA/HbFP9sbCM/7seY9haDlZI5NYZwQnyRlFzotJ2ebDjrH6zAcHh9S8YY8znmjhETVFmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEaWs2hn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEaWs2hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1088C4CEC3;
	Thu,  5 Sep 2024 09:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529471;
	bh=Ol9lF4j9zpiB09yZjh1TODeX643lqFtz159JU0E8bAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEaWs2hnmDb/gPFWpwFIxxaMwnVALgVh205ozCRiQ4G9w8byg1O/Sn98FheTUevd8
	 05o/aV1jKCrkS0NF5xoRpQvnPxNeRWniPtk+/JGDaLV4N11etcI3teD3SgStl6f90B
	 VrgoDS6MyZ5CGOh7RiFCaNyuCD92+DxbMEXpymTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sohaib Nadeem <sohaib.nadeem@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 043/184] drm/amd/display: Assign linear_pitch_alignment even for VM
Date: Thu,  5 Sep 2024 11:39:16 +0200
Message-ID: <20240905093733.930279110@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alvin Lee <alvin.lee2@amd.com>

[ Upstream commit 984debc133efa05e62f5aa1a7a1dd8ca0ef041f4 ]

[Description]
Assign linear_pitch_alignment so we don't cause a divide by 0
error in VM environments

Reviewed-by: Sohaib Nadeem <sohaib.nadeem@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Alvin Lee <alvin.lee2@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 236876d95185..da237f718dbd 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1421,6 +1421,7 @@ struct dc *dc_create(const struct dc_init_data *init_params)
 		return NULL;
 
 	if (init_params->dce_environment == DCE_ENV_VIRTUAL_HW) {
+		dc->caps.linear_pitch_alignment = 64;
 		if (!dc_construct_ctx(dc, init_params))
 			goto destruct_dc;
 	} else {
-- 
2.43.0



