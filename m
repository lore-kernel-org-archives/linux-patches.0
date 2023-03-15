Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86174431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED8FC433D2;
	Wed, 15 Mar 2023 12:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883852;
	bh=YRY0BOJIitJ/1cMD07jDmirv6Amd6iW1b7S0WpJeFGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DcYzi5CYDG9196gXP8Xb827KIRD836ZKryCBi6BBWB9c/1eKNAeK09HP7Un6L6JBR
	 uu29GFHIq17EQbH3OBBkpzpwIR6L9doiDTxW6zcReqZgOStFhFJ4GR9ybrV3JO27bK
	 Kk/wujq6s4TgqoQ90Zzt2TP7ccxoxPzYVQb5baWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.2 013/141] drm/amdgpu: fix error checking in amdgpu_read_mm_registers for soc21
Date: Wed, 15 Mar 2023 13:11:56 +0100
Message-Id: <20230315115740.384317022@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

commit 2915e43a033a778816fa4bc621f033576796521e upstream.

Properly skip non-existent registers as well.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2442
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/soc21.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -255,9 +255,10 @@ static int soc21_read_register(struct am
 	*value = 0;
 	for (i = 0; i < ARRAY_SIZE(soc21_allowed_read_registers); i++) {
 		en = &soc21_allowed_read_registers[i];
-		if (adev->reg_offset[en->hwip][en->inst] &&
-		    reg_offset != (adev->reg_offset[en->hwip][en->inst][en->seg]
-				   + en->reg_offset))
+		if (!adev->reg_offset[en->hwip][en->inst])
+			continue;
+		else if (reg_offset != (adev->reg_offset[en->hwip][en->inst][en->seg]
+					+ en->reg_offset))
 			continue;
 
 		*value = soc21_get_register_value(adev,


