Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAAC8634E;
	Wed,  5 Feb 2025 14:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765480; cv=none; b=aQ6GrDW+i4dzGH/oAa9WaZ+0hNwwPLM+fFeWpAxjWcQG69USZtZNOhOIcX4G6iqIKYCK0nWE59ju0YhJhULmV57qaM3gh25xefBovwnnFGj0cdyYroUt8PX9y/Ci7/uYyuxjbZEmAl76L6Ynk0p0Ue5MSrKUgj2AB5UhMMSWgdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765480; c=relaxed/simple;
	bh=jCGpPNl/Hd0+E8pjxj+SMCVpJeWBK84OYOXIB9w4KV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYAUzRTOrm4Ilxj2FcNVCmc7NIfRlss6tTJ+4cPNj0GoPNJnTYZ7YvkPDaklgTTeQMM43TxaCmRfbpizcJAslhQkutUX9dN19dsuXibSHIxU0sm4740dqsa5Z1/RP3P5VWAAxtx3cDqhywjRiUvpnXE2HB/N7bOlcH+r3Alzgrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBZJYOSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBZJYOSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BECC4CED1;
	Wed,  5 Feb 2025 14:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765480;
	bh=jCGpPNl/Hd0+E8pjxj+SMCVpJeWBK84OYOXIB9w4KV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lBZJYOSAs1XA49MRaxmC/tVBPxHNlWiSZ/PErknL8qWsKDAbdHAXydymlS/AB4sCX
	 ybYtBdxAC5X9PLTaVv2HVvXdxzRXqGO7GYri/q6riTLJESsCzH98gd5/l/U6Jz0Rnl
	 oQuvODVEarMoyaHUD1j6i5CoIYdRoK+yD0fGBawA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 271/393] fbdev: omapfb: Fix an OF node leak in dss_of_port_get_parent_device()
Date: Wed,  5 Feb 2025 14:43:10 +0100
Message-ID: <20250205134430.681390378@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



