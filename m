Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6A726FDBD;
	Tue, 11 Nov 2025 01:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823338; cv=none; b=g2MZQ9nMzpeI4nw+KGtVXMfiVk7wuuEaPf05zQtGWl6SYzIiM303CVppYDC8zW/id+qurIxm4l3wnlpM5tC/Yx1St2JXnp6YYiUSsvngrkrBSR9izQniMgm2r1Ts/5Lj9RorpuGOuVIJEszDAtkVLFQQQ/P2yX79wLg6WIARAmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823338; c=relaxed/simple;
	bh=XennKgp2m1j58Yz3lq5AMRws05mtr81NBlwMZbBGZyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nV+mGvuNvArlo++YgLO0ORAEsE5217+vaI2x9iaoi25nulIFJawHSa+b/kxEfGrrRlnmHGba46W/Hepa8lV6/++tkVCDsC8v+5JpinnkC22/aw1nx2icJTEsNPQPogwudfnfSZ0MHZVcfjteAV1LaiNY62OG9lKtyEH2MV4WH90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCySzkmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCySzkmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9C2C4CEF5;
	Tue, 11 Nov 2025 01:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823338;
	bh=XennKgp2m1j58Yz3lq5AMRws05mtr81NBlwMZbBGZyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JCySzkmGhSarQ/zsreTbADoU6NiL0cBm0JLFGQ4xbUJ5P+LX1GVfMgxECa/d7nKL+
	 zui9y76thY84wU9qd26gitqOylT2ICGrsWFcxbFWpmMN4/7m7xWffHfX7oh/r7GsZQ
	 Zw4cvtzkwHc+9b6NRZ7dl0wTG6ch6eE39GnPZWL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	TungYu Lu <tungyu.lu@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 191/565] drm/amd/display: Wait until OTG enable state is cleared
Date: Tue, 11 Nov 2025 09:40:47 +0900
Message-ID: <20251111004531.226883133@linuxfoundation.org>
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

From: TungYu Lu <tungyu.lu@amd.com>

[ Upstream commit e7496c15d830689cc4fc666b976c845ed2c5ed28 ]

[Why]
Customer reported an issue that OS starts and stops device multiple times
during driver installation. Frequently disabling and enabling OTG may
prevent OTG from being safely disabled and cause incorrect configuration
upon the next enablement.

[How]
Add a wait until OTG_CURRENT_MASTER_EN_STATE is cleared as a short term
solution.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: TungYu Lu <tungyu.lu@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/optc/dcn401/dcn401_optc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/optc/dcn401/dcn401_optc.c b/drivers/gpu/drm/amd/display/dc/optc/dcn401/dcn401_optc.c
index a5d6a7dca554c..27a9ec55d53ec 100644
--- a/drivers/gpu/drm/amd/display/dc/optc/dcn401/dcn401_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/optc/dcn401/dcn401_optc.c
@@ -226,6 +226,11 @@ static bool optc401_disable_crtc(struct timing_generator *optc)
 	REG_UPDATE(CONTROL,
 			VTG0_ENABLE, 0);
 
+	// wait until CRTC_CURRENT_MASTER_EN_STATE == 0
+	REG_WAIT(OTG_CONTROL,
+			 OTG_CURRENT_MASTER_EN_STATE,
+			 0, 10, 15000);
+
 	/* CRTC disabled, so disable  clock. */
 	REG_WAIT(OTG_CLOCK_CONTROL,
 			OTG_BUSY, 0,
-- 
2.51.0



