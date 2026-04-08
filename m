Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A506733121F;
	Wed,  8 Apr 2026 18:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674172; cv=none; b=cyOfqZFhq+5b+a3YZdD+LMWMDTIIV5PxWoOOTDRP9uJqw1TMuK13sKrVvNhPor4a36LdI3vFBIrlQX+Qj7aokvI/RUMibZHHh6qJHhwiAFatfRzWP4MIvQM0vFDm+uz2FsPT7R9S6ODQgJQQXAmE+X+ZoLveQgSV8OcqMkdGfT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674172; c=relaxed/simple;
	bh=TGH1k/fYR+V9IEisBzJAf1HefklWZl/hs3l5kuMGA04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVp0h25NHqjNRVVnlArwdmsF6sVMALtSuY/uNdbDVu217x/KCUMmyrIcXGNH7dlFTgYKagTMNCLbnc8xMvs8zZIgt5bsBcwfs+4V9a+SkdtQBj+rMuHION4dq8MrlFw/sEHW1GtBRpAoy/oQl0M4yLrICZPOdQ/MjWGX85eDunE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ng8qmlwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ng8qmlwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C850C19421;
	Wed,  8 Apr 2026 18:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674172;
	bh=TGH1k/fYR+V9IEisBzJAf1HefklWZl/hs3l5kuMGA04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ng8qmlwB9eMpSfsJFMLJzl56W5HIgiTsna5HFw5/LdvIp2bq9Q94aZnZFDE892z6I
	 g3d7ztwIKso/bv6hO9+ey9NXcKOt/RKe7gt+C7meaPM4tjTD4X2DRgBJ/yhdY/OAFz
	 9Nws6HhdDRmUcsCveejuIAvrwAMsu4rR/ZRB8i2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <Mario.Limonciello@amd.com>,
	Ovidiu Bunea <ovidiu.bunea@amd.com>,
	Charlene Liu <Charlene.Liu@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Rosen Penev <rosenp@gmail.com>
Subject: [PATCH 6.12 236/242] drm/amd/display: Correct logic check error for fastboot
Date: Wed,  8 Apr 2026 20:04:36 +0200
Message-ID: <20260408175935.938231299@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit b6a65009e7ce3f0cc72da18f186adb60717b51a0 ]

[Why]
Fix fastboot broken in driver.
This is caused by an open source backport change 7495962c.

from the comment, the intended check is to disable fastboot
for pre-DCN10. but the logic check is reversed, and causes
fastboot to be disabled on all DCN10 and after.

fastboot is for driver trying to pick up bios used hw setting
and bypass reprogramming the hw if dc_validate_boot_timing()
condition meets.

Fixes: 7495962cbceb ("drm/amd/display: Disable fastboot on DCE 6 too")
Cc: stable@vger.kernel.org
Reviewed-by: Mario Limonciello <Mario.Limonciello@amd.com>
Reviewed-by: Ovidiu Bunea <ovidiu.bunea@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1910,8 +1910,8 @@ void dce110_enable_accelerated_mode(stru
 
 	get_edp_streams(context, edp_streams, &edp_stream_num);
 
-	/* Check fastboot support, disable on DCE 6-8 because of blank screens */
-	if (edp_num && edp_stream_num && dc->ctx->dce_version < DCE_VERSION_10_0) {
+	/* Check fastboot support, disable on DCE 6-8-10 because of blank screens */
+	if (edp_num && edp_stream_num && dc->ctx->dce_version > DCE_VERSION_10_0) {
 		for (i = 0; i < edp_num; i++) {
 			edp_link = edp_links[i];
 			if (edp_link != edp_streams[0]->link)


