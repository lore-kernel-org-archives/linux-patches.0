Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FB622D7A6;
	Mon, 10 Mar 2025 17:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628957; cv=none; b=cd+JkoTKdyiYwUnhh/IArjmjxmXgAg+tC9Xz0GZtt/8MKgQ45x8M/zHA0Tf58ClOCYDa96yymMmvouR5+8+ztigUeSBX0w9IHT1oA5meHmo/odSXYC+CYUDDFpDvZ0UiAQPFXCH387011n4ym7LHxseUUrneuMwwYHnTUpL+zH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628957; c=relaxed/simple;
	bh=p9z4anMFck1oJvW3ThRbxaDchu2J+7xD+V3ckKa2S/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlCUoa28wXn4av9j36s31Mgz7hwQ/WVKSOktyGqs24kRyOr6NyFYcYc9pnhzgVI8snOiLp8r0rFvT3ypovzRFz+hRSy+rn6rw6eataVJ5gEKh9bvI//AzfAsqejV2W/qhiNh8UpWoiORDPt4KvlaPL9rp2Tf5/2kZ/1URZEnBmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oxhDa0K9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxhDa0K9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362C4C4CEE5;
	Mon, 10 Mar 2025 17:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628956;
	bh=p9z4anMFck1oJvW3ThRbxaDchu2J+7xD+V3ckKa2S/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxhDa0K9CH8GxVw1ro+dScA4NRLiJo8gSXwFjnSYu6E/oU9thFFwoTVvDrT8sK6bX
	 iU9YSrtgj8xNRhlTPJiBnTbyWFnvgbuU+DAVJ9+phkRd+3VKPd0HzaMX4Va1BiIQGn
	 iwyhVEBWic9XtTTyuk1pgZoEv/n8GrJb/sy1qzNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/620] fbdev: omapfb: Fix an OF node leak in dss_of_port_get_parent_device()
Date: Mon, 10 Mar 2025 17:59:34 +0100
Message-ID: <20250310170550.651885746@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit de124b61e179e690277116e6be512e4f422b5dd8 ]

dss_of_port_get_parent_device() leaks an OF node reference when i >= 2
and struct device_node *np is present. Since of_get_next_parent()
obtains a reference of the returned OF node, call of_node_put() before
returning NULL.

This was found by an experimental verifier that I am developing, and no
runtime test was able to be performed due to that lack of actual
devices.

Fixes: f76ee892a99e ("omapfb: copy omapdss & displays for omapfb")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/omap2/omapfb/dss/dss-of.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dss-of.c b/drivers/video/fbdev/omap2/omapfb/dss/dss-of.c
index 0282d4eef139d..3b16c3342cb77 100644
--- a/drivers/video/fbdev/omap2/omapfb/dss/dss-of.c
+++ b/drivers/video/fbdev/omap2/omapfb/dss/dss-of.c
@@ -102,6 +102,7 @@ struct device_node *dss_of_port_get_parent_device(struct device_node *port)
 		np = of_get_next_parent(np);
 	}
 
+	of_node_put(np);
 	return NULL;
 }
 
-- 
2.39.5



