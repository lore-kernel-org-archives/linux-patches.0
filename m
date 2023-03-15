Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A13A4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5432C433EF;
	Wed, 15 Mar 2023 12:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883494;
	bh=vsP5zue/IExoFhZ69eEvRir84B0LNiO1AYO1Gr4lC48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qaHLeKwc7+C5Wg+8eIHXGRMEj+jRQ0x94nTHn56a+Dsqvy4693zKH4xuzMmSUb6Or
	 dDOPzzcv6CjTd1IZ97yQgrN7vUFbdRYTxDrUIdH6u/h/hci8f5aUPf0wRAvuC7KKqT
	 LnFlXoWJFpXVBibNUr5KDdYa3kIeVSF04TqwyYBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 012/143] drm/amdgpu: fix error checking in amdgpu_read_mm_registers for nv
Date: Wed, 15 Mar 2023 13:11:38 +0100
Message-Id: <20230315115740.834117668@linuxfoundation.org>
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

commit b42fee5e0b44344cfe4c38e61341ee250362c83f upstream.

Properly skip non-existent registers as well.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2442
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/nv.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -393,9 +393,10 @@ static int nv_read_register(struct amdgp
 	*value = 0;
 	for (i = 0; i < ARRAY_SIZE(nv_allowed_read_registers); i++) {
 		en = &nv_allowed_read_registers[i];
-		if (adev->reg_offset[en->hwip][en->inst] &&
-		    reg_offset != (adev->reg_offset[en->hwip][en->inst][en->seg]
-				   + en->reg_offset))
+		if (!adev->reg_offset[en->hwip][en->inst])
+			continue;
+		else if (reg_offset != (adev->reg_offset[en->hwip][en->inst][en->seg]
+					+ en->reg_offset))
 			continue;
 
 		*value = nv_get_register_value(adev,


