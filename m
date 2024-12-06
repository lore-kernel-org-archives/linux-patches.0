Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E6E10E0;
	Fri,  6 Dec 2024 14:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496417; cv=none; b=Kq6Qv6DIY5NY9XqLGXHvtyKDv0h6V5ot5jjBEgRbWy54FG8ky7Z3kwwf3ivoDuEffE2Z5Zk47UJ7qKrbfaA3pPvW8SYOX4qc3k0d+myz5RDgnXOY95B6qkAUBSHiUzAM72RvZSFWzNIRUtc5XmbqRs0BQJGoLqBxv0Ehrckdt9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496417; c=relaxed/simple;
	bh=t7LhJ0wY42bVIttn4zcEL7C4yf6v75ZDhLxZMJiQ+BU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VS8dqb3Be6v6ebywWUC4f02AT+L8tuy04+X7zA3rE4k/KwcWWRIBLmGfKbq8jMgkRHUtIGHYb0iHQ/fxymn3kZK8kZcTqVa1wZOxVGdPOmUgDhAKZARKcnJ+d8Pz7IJpkQ2Kd5nHKlAHXZ8hj5qAdviSusISCpuWa5uiPMaqFic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/RD2we8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/RD2we8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061E4C4CED1;
	Fri,  6 Dec 2024 14:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496417;
	bh=t7LhJ0wY42bVIttn4zcEL7C4yf6v75ZDhLxZMJiQ+BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/RD2we8aN8NXD3Q4HiEK3d6F7QT6vLSL07MDAO9H9hbcYIVMDC32AYLeL8Y1FyCQ
	 BioRRIwcKD2neqOW/Y2bPsTF3IxSh8k+IRkbm5E96TF5G5CkeuWB/MGNUpXl0A7+Lx
	 ziCPYhh/fOGQ+rPKtI3s3CRpvNqFYmgGkU1eLR/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Ovidiu Bunea <Ovidiu.Bunea@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 145/146] drm/amd/display: Remove PIPE_DTO_SRC_SEL programming from set_dtbclk_dto
Date: Fri,  6 Dec 2024 15:37:56 +0100
Message-ID: <20241206143533.233232876@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Bunea <Ovidiu.Bunea@amd.com>

commit a3e6079bd93d5c66a43bf6a5f90e5b98465dc7b3 upstream.

There are cases where an OTG is remapped from driving a regular HDMI
display to a DP/eDP display. There are also cases where DTBCLK needs to
be enabled for HPO, but DTBCLK DTO programming may be done while OTG is
still enabled which is dangerous as the PIPE_DTO_SRC_SEL programming may
change the pixel clock generator source for a mapped and running OTG and
cause it to hang.

Remove the PIPE_DTO_SRC_SEL programming from this sequence since it is
already done in program_pixel_clk(). Additionally, make sure that
program_pixel_clk sets DTBCLK DTO as source for special HDMI cases.

Cc: stable@vger.kernel.org # 6.11+
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Ovidiu Bunea <Ovidiu.Bunea@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c    | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c b/drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c
index 838d72eaa87f..b363f5360818 100644
--- a/drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c
@@ -1392,10 +1392,10 @@ static void dccg35_set_dtbclk_dto(
 
 		/* The recommended programming sequence to enable DTBCLK DTO to generate
 		 * valid pixel HPO DPSTREAM ENCODER, specifies that DTO source select should
-		 * be set only after DTO is enabled
+		 * be set only after DTO is enabled.
+		 * PIPEx_DTO_SRC_SEL should not be programmed during DTBCLK update since OTG may still be on, and the
+		 * programming is handled in program_pix_clk() regardless, so it can be removed from here.
 		 */
-		REG_UPDATE(OTG_PIXEL_RATE_CNTL[params->otg_inst],
-				PIPE_DTO_SRC_SEL[params->otg_inst], 2);
 	} else {
 		switch (params->otg_inst) {
 		case 0:
@@ -1412,9 +1412,12 @@ static void dccg35_set_dtbclk_dto(
 			break;
 		}
 
-		REG_UPDATE_2(OTG_PIXEL_RATE_CNTL[params->otg_inst],
-				DTBCLK_DTO_ENABLE[params->otg_inst], 0,
-				PIPE_DTO_SRC_SEL[params->otg_inst], params->is_hdmi ? 0 : 1);
+		/**
+		 * PIPEx_DTO_SRC_SEL should not be programmed during DTBCLK update since OTG may still be on, and the
+		 * programming is handled in program_pix_clk() regardless, so it can be removed from here.
+		 */
+		REG_UPDATE(OTG_PIXEL_RATE_CNTL[params->otg_inst],
+				DTBCLK_DTO_ENABLE[params->otg_inst], 0);
 
 		REG_WRITE(DTBCLK_DTO_MODULO[params->otg_inst], 0);
 		REG_WRITE(DTBCLK_DTO_PHASE[params->otg_inst], 0);
-- 
2.47.1



