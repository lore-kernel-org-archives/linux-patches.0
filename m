Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D06D1547E3;
	Thu, 13 Feb 2025 14:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458658; cv=none; b=Z/6DiLGW2OBBo82YJITuEPcE6Haunha84S2FmQd1g2wCXt8ucPxlr499J7L0mf6uclpcFvxnxIHuMK3EPXTBQylP9iV7wJPNaCjAtFIe5YLbinR1/d4itVBy94OnhDW7M6hppaWjZRu22c4+7WRbC5jDABEtp0vPGT7YVJEC0K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458658; c=relaxed/simple;
	bh=MpOC8OLbFu7uymj8TlNngwZP8/XUynpx4x0FUWcZWio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9Qxmeh5suSzP0T5jKz91+A/5/DrbGDeqriOwtRfn701r+W35/A8mT8j2mMbMIevLmVaiP1MOnvTEj6VPh0M7tF3KUXnG6U2Q0QayUvEJ22Fg0rP5oIu1oYeSfpNzJzTZQ/2zh+7fWut8GpGol99WGXiT0J2fCbvhd5QwMWFHJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lj04RzPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lj04RzPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0A3C4CED1;
	Thu, 13 Feb 2025 14:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458657;
	bh=MpOC8OLbFu7uymj8TlNngwZP8/XUynpx4x0FUWcZWio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lj04RzPDzfzjLXiKwfg5/pUfOMacPlYOOeVztFhKxBwMyT835Sy91nGloPj3wZSer
	 tDnVoHWz31J9SKf2V80+qckybJ1H7oilCZrveQZhzVA2fNsWL1KStTF2oXRq5D1wNM
	 tww5jr/q4eXtpvGe0sO1UWTJB6qozzy21efJ93sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 042/443] drm/amdgpu: Dont enable sdma 4.4.5 CTXEMPTY interrupt
Date: Thu, 13 Feb 2025 15:23:27 +0100
Message-ID: <20250213142442.248148953@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit b4b7271e5ca95b581f2fcc4ae852c4079215e92d ]

The sdma context empty interrupt is dropped in amdgpu_irq_dispatch
as unregistered interrupt src_id 243, this interrupt accounts to 1/3 of
total interrupts and causes IH primary ring overflow when running
stressful benchmark application. Disable this interrupt has no side
effect found.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
index a38553f38fdc8..ed68d7971a93a 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
@@ -953,10 +953,12 @@ static int sdma_v4_4_2_inst_start(struct amdgpu_device *adev,
 		/* set utc l1 enable flag always to 1 */
 		temp = RREG32_SDMA(i, regSDMA_CNTL);
 		temp = REG_SET_FIELD(temp, SDMA_CNTL, UTC_L1_ENABLE, 1);
-		/* enable context empty interrupt during initialization */
-		temp = REG_SET_FIELD(temp, SDMA_CNTL, CTXEMPTY_INT_ENABLE, 1);
-		WREG32_SDMA(i, regSDMA_CNTL, temp);
 
+		if (amdgpu_ip_version(adev, SDMA0_HWIP, 0) < IP_VERSION(4, 4, 5)) {
+			/* enable context empty interrupt during initialization */
+			temp = REG_SET_FIELD(temp, SDMA_CNTL, CTXEMPTY_INT_ENABLE, 1);
+			WREG32_SDMA(i, regSDMA_CNTL, temp);
+		}
 		if (!amdgpu_sriov_vf(adev)) {
 			if (adev->firmware.load_type != AMDGPU_FW_LOAD_PSP) {
 				/* unhalt engine */
-- 
2.39.5



