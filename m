Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FED7BA3F;
	Mon,  1 Apr 2024 16:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990433; cv=none; b=B1aczQ5TAkzqpUcjA7Y0cEejZhnJzlHW59gAECbJL1MQYma3n1Aljg4U5nE5/EcWkKVufx+l1uLKlNW44rjZqfiXQ2MRnpbTtlOcIkAzhEQJeMm4xfz95wL62Hilk1jCsfmy41Zmt2N1XIXUC0kWTrlVMc/MMdF2jba2XZ6GLBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990433; c=relaxed/simple;
	bh=3cfd3Os00xa3jf7cgroTULDXHbO2xeC8Ohssc1Hbaac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOtBNlN+Ng9lrUJlkEA4egu/QHTMNWbzO2OJovHmYtAZHX18N2gaAfImMp4ggBjA+F127Af7F02vPW5z5FIvW/TDGdrUUKrYk4oghonaAp2lHnK/qg/h18Um+sMfEkK1r5JSetDMaRRyFagngbZ6SyU8zZ1C5JQwZJgse14t65g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSDU05AB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSDU05AB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59C5C433C7;
	Mon,  1 Apr 2024 16:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990433;
	bh=3cfd3Os00xa3jf7cgroTULDXHbO2xeC8Ohssc1Hbaac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vSDU05ABHmyecJurM+xwYz4XyhhJ3srxSlSzsH7P10ytEvKQaT+DnGjIM3Nieha4D
	 YfWUz7t2xJg19WdUpQ59Pb1ylRZf6eqkrrVqK2a5nfM+t7IZsX42c6PnB7ddm+NG9l
	 ODqwIiqKHW3RimXnurrD+ZNN2mIsEvHxoC665AdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Ilya Bakoulin <ilya.bakoulin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 352/396] drm/amd/display: Fix hang/underflow when transitioning to ODM4:1
Date: Mon,  1 Apr 2024 17:46:41 +0200
Message-ID: <20240401152558.416806864@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Bakoulin <ilya.bakoulin@amd.com>

[ Upstream commit e7b2b108cdeab76a7e7324459e50b0c1214c0386 ]

[Why]
Under some circumstances, disabling an OPTC and attempting to reclaim
its OPP(s) for a different OPTC could cause a hang/underflow due to OPPs
not being properly disconnected from the disabled OPTC.

[How]
Ensure that all OPPs are unassigned from an OPTC when it gets disabled.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Ilya Bakoulin <ilya.bakoulin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: b4e05bb1dec5 ("drm/amd/display: Clear OPTC mem select on disable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
index 8abb94f60078f..b1fcc91b65a32 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
@@ -148,6 +148,13 @@ static bool optc32_disable_crtc(struct timing_generator *optc)
 	REG_UPDATE(OTG_CONTROL,
 			OTG_MASTER_EN, 0);
 
+	REG_UPDATE_5(OPTC_DATA_SOURCE_SELECT,
+			OPTC_SEG0_SRC_SEL, 0xf,
+			OPTC_SEG1_SRC_SEL, 0xf,
+			OPTC_SEG2_SRC_SEL, 0xf,
+			OPTC_SEG3_SRC_SEL, 0xf,
+			OPTC_NUM_OF_INPUT_SEGMENT, 0);
+
 	REG_UPDATE(CONTROL,
 			VTG0_ENABLE, 0);
 
-- 
2.43.0



