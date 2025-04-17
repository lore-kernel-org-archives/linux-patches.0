Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4269254878;
	Thu, 17 Apr 2025 18:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915547; cv=none; b=aUtMxD4Tet2Xs4kHFimWZRc4jsdJJyg8vt18sMdDPyccDN8grLkVzxnbNbHt/mLtVZabCd+j692e+Kvqpom/0rMQGtuu2xnaT8feGO/tqFAZ39BuWLx3/kgXKw8tCjrEMy9qo5psjiNfH0y6mXN3fi6hEgTSEwAkesPP48XX86g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915547; c=relaxed/simple;
	bh=ueLWeyCsz/tEa1yTDo3D+/zlkz+OyQ+rtR2uDBhCS9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKB5kEXzY6HFCV1kQc2yYkWHd1fqpph4aHGESS+32MuFUCt+BI2mwWsDLGpXDfWEgb2pFG1up0FeaOlPyelUoE0Ns/Zde+bBtxPoe/lpPlwRY/LXJn57pUF0kbkfOZZp7oR5jeDWLFDNRKSQJ4SCT3LotiAPrOCXKx/nHKuyL4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7sED8tF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7sED8tF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1545CC4CEE4;
	Thu, 17 Apr 2025 18:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915546;
	bh=ueLWeyCsz/tEa1yTDo3D+/zlkz+OyQ+rtR2uDBhCS9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7sED8tFV/DVEcRT6QoRVb4qZaxYSYQJNbpsLjVSw5NcFBfIr8kJ/SAy36MIh3uPS
	 z7MkRjyrIZKaQh7aNoAAKffaZYuI/M0XuQW7eE9Mrq9I/9Z83Bk+UQzHCV5i82GQiW
	 jDkQWkmsDJFC5Ur8K64Cs9efBM8cG2fZtW/gWoHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonid Arapov <arapovl839@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 154/393] fbdev: omapfb: Add plane value check
Date: Thu, 17 Apr 2025 19:49:23 +0200
Message-ID: <20250417175113.781044605@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leonid Arapov <arapovl839@gmail.com>

[ Upstream commit 3e411827f31db7f938a30a3c7a7599839401ec30 ]

Function dispc_ovl_setup is not intended to work with the value OMAP_DSS_WB
of the enum parameter plane.

The value of this parameter is initialized in dss_init_overlays and in the
current state of the code it cannot take this value so it's not a real
problem.

For the purposes of defensive coding it wouldn't be superfluous to check
the parameter value, because some functions down the call stack process
this value correctly and some not.

For example, in dispc_ovl_setup_global_alpha it may lead to buffer
overflow.

Add check for this value.

Found by Linux Verification Center (linuxtesting.org) with SVACE static
analysis tool.

Signed-off-by: Leonid Arapov <arapovl839@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/omap2/omapfb/dss/dispc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dispc.c b/drivers/video/fbdev/omap2/omapfb/dss/dispc.c
index 5832485ab998c..c29b6236952b3 100644
--- a/drivers/video/fbdev/omap2/omapfb/dss/dispc.c
+++ b/drivers/video/fbdev/omap2/omapfb/dss/dispc.c
@@ -2749,9 +2749,13 @@ int dispc_ovl_setup(enum omap_plane plane, const struct omap_overlay_info *oi,
 		bool mem_to_mem)
 {
 	int r;
-	enum omap_overlay_caps caps = dss_feat_get_overlay_caps(plane);
+	enum omap_overlay_caps caps;
 	enum omap_channel channel;
 
+	if (plane == OMAP_DSS_WB)
+		return -EINVAL;
+
+	caps = dss_feat_get_overlay_caps(plane);
 	channel = dispc_ovl_get_channel_out(plane);
 
 	DSSDBG("dispc_ovl_setup %d, pa %pad, pa_uv %pad, sw %d, %d,%d, %dx%d ->"
-- 
2.39.5



