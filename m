Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF454431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B9DC433EF;
	Wed, 15 Mar 2023 12:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883577;
	bh=y2AsN5+VDiHCzgEb9G1rabVojvPwme3eKp0gL2eWL2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glV0YJQl6ek4gBshptx+ft6X5JSZPIx4UUtUNN+mmKWoSu9VqPMzLx9u4gS8pDh6h
	 q5CY0GUlYXF9NnWK8LBV+uJL8ZH6ApR7Fr3BzwOgOwczGB1FkUafEW3KNFGP0gIUst
	 AYWTgjPlf0I+Kiu9yLyYQbjs0nMXMnbiGT/rvbKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 011/143] drm/amdgpu: fix error checking in amdgpu_read_mm_registers for soc21
Date: Wed, 15 Mar 2023 13:11:37 +0100
Message-Id: <20230315115740.805418415@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
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
@@ -254,9 +254,10 @@ static int soc21_read_register(struct am
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


