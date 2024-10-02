Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7165329CE7;
	Wed,  2 Oct 2024 13:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876901; cv=none; b=hfaQLDEqE4ykWPpd4dIxOvb5z6qB06/tkmlMfSiQOK+NR7aRgJUOmqXAoC66OIu1l/eWWDJL70SxJP3KG5muNiq6OA1soZSMsC/uH2lnsV6BWuHmCc5FYu7Af9WoI4Cdcicv1N7fe0hKLzDSEaIJvimH4RotERcsfUQnWKjdOUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876901; c=relaxed/simple;
	bh=UW/t4njZXXdYKj4fcAE/2MFfeehRzk7QQsuK3EA3iWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciSEQSwHVVkK5DrfWLd7QYWvOwM8JN716Dni70Q/IigImzyfsCH67faH81FmBkO0MRlGaXb/o6ecG0mT2VAFfDsqjVZznKE94eKmy0wRP58QbIUO2aXVL788CvDyZGM291TQ3/mv1o52lJxgiqu9mLOpQagMod//mG4KTKwK3GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aoIhvjPP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aoIhvjPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95F6C4CEC5;
	Wed,  2 Oct 2024 13:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876901;
	bh=UW/t4njZXXdYKj4fcAE/2MFfeehRzk7QQsuK3EA3iWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aoIhvjPPQZPJ5EBh82PR6CCYD4o/mI3YVn4HKQb6lk3wmVOBFv4zVMuS2wfeKuXtt
	 QUqNXS33Nvn84B0rxDubbfeLrlikBZi7IHgISK53xFdK4ltvdBSePhx/RR6rdGu4kD
	 yyRre2D4uhtlmvLQ2VLAIIid3x9cvLOOGOhwDXKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.11 557/695] drm/amd/display: Block dynamic IPS2 on DCN35 for incompatible FW versions
Date: Wed,  2 Oct 2024 14:59:15 +0200
Message-ID: <20241002125844.735758071@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit 401c90c4d64f2227fc2f4c02d2ad23296bf5ca6f upstream.

[WHY]
Hangs with Z8 can occur if running an older unfixed PMFW version.

[HOW]
Fallback to RCG only for dynamic IPS2 states if it's not newer than
93.12. Limit to DCN35.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
@@ -1204,6 +1204,12 @@ void dcn35_clk_mgr_construct(
 			ctx->dc->debug.disable_dpp_power_gate = false;
 			ctx->dc->debug.disable_hubp_power_gate = false;
 			ctx->dc->debug.disable_dsc_power_gate = false;
+
+			/* Disable dynamic IPS2 in older PMFW (93.12) for Z8 interop. */
+			if (ctx->dc->config.disable_ips == DMUB_IPS_ENABLE &&
+			    ctx->dce_version == DCN_VERSION_3_5 &&
+			    ((clk_mgr->base.smu_ver & 0x00FFFFFF) <= 0x005d0c00))
+				ctx->dc->config.disable_ips = DMUB_IPS_RCG_IN_ACTIVE_IPS2_IN_OFF;
 		} else {
 			/*let's reset the config control flag*/
 			ctx->dc->config.disable_ips = DMUB_IPS_DISABLE_ALL; /*pmfw not support it, disable it all*/


