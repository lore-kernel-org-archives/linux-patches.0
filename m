Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCCF397E84;
	Mon, 23 Mar 2026 14:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274418; cv=none; b=BjzUrulds9Lajde55deehEJNwRUszDzPD3YAKVWXUMsi9kWCB3oe8aj4IKzTfX3qEi3Xt9pur01JolgWnIGn4hHav57SmEZnTFIzpzLRcNsHqrGJXxQwhneIfot7BCd7E4HkTH12RIMWNkdfpNfHz0k3iEvU2lh1POT0SMeUIJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274418; c=relaxed/simple;
	bh=BW2cF7hiBTzFNVmK74LlGyOsM0oFb8UDkGfUif9gGY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmVUDSaOimLCNuM0ofmK86PvV9p1ZzLlQa5evWamZ60t671c24+OnAt1LihBf7e+L7aAuzRWETDeoE9hoNk/Ls6r/y3ii+UVA6WM8h6F8eh8BreRhAbs+VC/ltUwCwEwXRIG3YQOFWk+7k69j7XjF2D0WeyK+oXiR/oVhrV1d1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hwZQ47Cn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hwZQ47Cn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904D2C4CEF7;
	Mon, 23 Mar 2026 14:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274418;
	bh=BW2cF7hiBTzFNVmK74LlGyOsM0oFb8UDkGfUif9gGY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hwZQ47CnLASFXEbcdEdKdQdDpCRBjiComHXYa2noyV1pg5bxCbwd6TgI2Q/qcs3Kj
	 NEhrKtav4OgLegsQyFF2Xh7/DbjZ6jK1PbvXUKKb6oalpxwII04dpPlOT9zvvG8AkH
	 Mdjed2DJcy/ZybV7QQxMtNDri9JchD1McXd2vcIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Sun peng Li <sunpeng.li@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 209/220] drm/amd/display: Fix DisplayID not-found handling in parse_edid_displayid_vrr()
Date: Mon, 23 Mar 2026 14:46:26 +0100
Message-ID: <20260323134511.153997876@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 2323b019651ad81c20a0f7f817c63392b3110652 ]

parse_edid_displayid_vrr() searches the EDID extension blocks for a
DisplayID extension before parsing the dynamic video timing range.

The code previously checked whether edid_ext was NULL after the search
loop. However, edid_ext is assigned during each iteration of the loop,
so it will never be NULL once the loop has executed. If no DisplayID
extension is found, edid_ext ends up pointing to the last extension
block, and the NULL check does not correctly detect the failure case.

Instead, check whether the loop completed without finding a matching
DisplayID block by testing "i == edid->extensions". This ensures the
function exits early when no DisplayID extension is present and avoids
parsing an unrelated EDID extension block.

Also simplify the EDID validation check using "!edid ||
!edid->extensions".

Fixes the below:
drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:13079 parse_edid_displayid_vrr() warn: variable dereferenced before check 'edid_ext' (see line 13075)

Fixes: a638b837d0e6 ("drm/amd/display: Fix refresh rate range for some panel")
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Jerry Zuo <jerry.zuo@amd.com>
Cc: Sun peng Li <sunpeng.li@amd.com>
Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 91c7e6342e98c846b259c57273436fdea4c043f2)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index e84ec4365ca6b..5a54d3f4a3de5 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -13101,7 +13101,7 @@ static void parse_edid_displayid_vrr(struct drm_connector *connector,
 	u16 min_vfreq;
 	u16 max_vfreq;
 
-	if (edid == NULL || edid->extensions == 0)
+	if (!edid || !edid->extensions)
 		return;
 
 	/* Find DisplayID extension */
@@ -13111,7 +13111,7 @@ static void parse_edid_displayid_vrr(struct drm_connector *connector,
 			break;
 	}
 
-	if (edid_ext == NULL)
+	if (i == edid->extensions)
 		return;
 
 	while (j < EDID_LENGTH) {
-- 
2.51.0



