Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9242C1C68C;
	Sun,  1 Sep 2024 16:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209445; cv=none; b=c6BH9SAYxWdSau8wd2HksDUif9Mfnyx6+j7IN/ICL0xYejxWEIflDzDbYMPMtZmPp6x3Xy/rajSgK5LRBC0PvKECWw9LIMllXA4Dm1LycLzQG8a5yieNNLsYgjEOo580wgSxB7xpI57ydhvXiAF4uiEwmLgpXjisyza+DiB/jhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209445; c=relaxed/simple;
	bh=Fa8T29YTlp3O/GEp5gQl+6jdjqkcFFMcNunp8pq/HqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcgiZlbDJiQx+8bEDpe0BplLP5VDpxlGoHmXcvwS22CltQV2HpW9YwAZMOWiO8YwMTBvyZui8MNVXPcnxarziA+e6OGCxeiS1gj2K+KpsNUFXoyCL9MirKSAHofsoBDPIwTcqEStyFI3q+nh0gPMgG+Ijqc+FWo4xMmcUYlTM+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrKQEAVy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrKQEAVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9F7C4CEC3;
	Sun,  1 Sep 2024 16:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209445;
	bh=Fa8T29YTlp3O/GEp5gQl+6jdjqkcFFMcNunp8pq/HqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WrKQEAVymWjA+r+rMDO3rTTEkh3yVdNkgn+vJCb+MiexC/ygkeDnlBqBxySC3vFQX
	 yNLXmAO3pdUWf0PMWvSKT3ir7PxKxpEWEV+CLC4VInGGiELIUWiBGguJczmFM37Y0Q
	 /KY15NhmWGQmFYgdkx6QQ3sUxmRFy0Kratq6hAA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/151] drm/amd/display: Validate hw_points_num before using it
Date: Sun,  1 Sep 2024 18:16:39 +0200
Message-ID: <20240901160815.571825861@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 58c3b3341cea4f75dc8c003b89f8a6dd8ec55e50 ]

[WHAT]
hw_points_num is 0 before ogam LUT is programmed; however, function
"dwb3_program_ogam_pwl" assumes hw_points_num is always greater than 0,
i.e. substracting it by 1 as an array index.

[HOW]
Check hw_points_num is not equal to 0 before using it.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c
index 6d621f07be489..1c170fbb634da 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c
@@ -243,6 +243,9 @@ static bool dwb3_program_ogam_lut(
 		return false;
 	}
 
+	if (params->hw_points_num == 0)
+		return false;
+
 	REG_SET(DWB_OGAM_CONTROL, 0, DWB_OGAM_MODE, 2);
 
 	current_mode = dwb3_get_ogam_current(dwbc30);
-- 
2.43.0



