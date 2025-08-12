Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD2726FA77;
	Tue, 12 Aug 2025 19:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025590; cv=none; b=Ge6gI9NgzgY9afxeAIoYeQBtPFZvFk1NFrTay1x+EOD8ZwDI9/MSe+oc5dPMfS297aCPpA3YAc25LxO90VWUZlfWFJr1sCfPsgbJ9a3FynE10+l6CQ1YvN6zgvztk82VPqZLjendCesRaifS9Ziam3AfZJ09JXBT53dY6Ls839s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025590; c=relaxed/simple;
	bh=T2wwt5ZupvEy1YkZnxEhXyI6uEU72MNLOBJnKTjq270=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbW+Mzosl1JRXiOiCgLQRVcJiuIgt5sOyiRbiyAxjbRmryO8732ONK/no5ZTCsAbdo3I5l7uYZCy+Ch1G0PsLj6XRjMsiqT+qQaro9LRp1OGRFmQGPUIBejJU1HjFZrG7wQNCoN1jOCt2gRpIlvnQwH45VLNb3Fsc1GdRmXXWx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smSex6ri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smSex6ri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429C6C4CEF0;
	Tue, 12 Aug 2025 19:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025590;
	bh=T2wwt5ZupvEy1YkZnxEhXyI6uEU72MNLOBJnKTjq270=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smSex6riakaRJPzi2tOkgmcrUqpFqesn6qTKMxU9Fb50H1kHRHCRtB8R40bRjwll3
	 TdrQ/kcedCnM/c55i2gNWBAyAtqz4u5cWGf84Zwbsq8k/qpL8LJ9nnnrz+ce3bmWkS
	 MKFhvlIZiGC0hBBp2GHBSaJBGpHv8fukz2Rwunb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 087/480] ASoC: SDCA: Allow read-only controls to be deferrable
Date: Tue, 12 Aug 2025 19:44:55 +0200
Message-ID: <20250812174401.037873752@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 4eb6ad5d2080681b531db2c1764246f9a868062f ]

The current SDCA Control parsing only checks the deferrable flag for
Read/Write and Dual Ranked controls. However, reads can defer as well as
writes so Read Only controls should also check for the deferrable flag.
Add the handling for this into find_sdca_entity_control().

Fixes: 42b144cb6a2d ("ASoC: SDCA: Add SDCA Control parsing")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20250707124155.2596744-2-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_functions.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sdca/sdca_functions.c b/sound/soc/sdca/sdca_functions.c
index 493f390f087a..15aa57a07c73 100644
--- a/sound/soc/sdca/sdca_functions.c
+++ b/sound/soc/sdca/sdca_functions.c
@@ -880,7 +880,8 @@ static int find_sdca_entity_control(struct device *dev, struct sdca_entity *enti
 			control->value = tmp;
 			control->has_fixed = true;
 		}
-
+		fallthrough;
+	case SDCA_ACCESS_MODE_RO:
 		control->deferrable = fwnode_property_read_bool(control_node,
 								"mipi-sdca-control-deferrable");
 		break;
-- 
2.39.5



