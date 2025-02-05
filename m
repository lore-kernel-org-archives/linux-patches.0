Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983371632D3;
	Wed,  5 Feb 2025 14:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767000; cv=none; b=WVEYMImXrVrMUX51ap/otewiithAWRRamrnzVpUgeKJk4lZatSi4szvnHTWE350lpnkxRwfADDlFiY90kj8IiDIPdY64ctEBYQp4c2peg7Uls277aaVLGk/Meqry0ORW25V9zKmufgK1vsrHAC4a1b99qnJYoTxxNJqi/KN5Vnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767000; c=relaxed/simple;
	bh=SDq/Sfldx/MjQFZnT8eNH6mrqu3bEwVw/WhQPSDrios=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rd4lmx5Hmv1OGqsT98/8CTgNKQOfDL+E4jh4MQlfO68RVNiILuLXM73k1WyQAmT2ICuCJUaKOyKfD59XTiM4QBdOOpbBFcE3OmtwEzJ+4xriCQTybTAdW8+IUASUOYD9JMlf875NfkhNBaef+vjWNheOrgPVHYkxPWljOigX//o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXm6QeOi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXm6QeOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28D3C4CED1;
	Wed,  5 Feb 2025 14:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767000;
	bh=SDq/Sfldx/MjQFZnT8eNH6mrqu3bEwVw/WhQPSDrios=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXm6QeOi0TTssxOFRo6SP8O2gAvGSE2OYbaY/QSHzHMtqTeSwi3lfhVpM0jDAoDXC
	 e3QWMzmxVE/KKoI8jrs5T1J2RlS7KzEr3RUC4S/yuPE+Y8IjbH5q/MKwPOCYawCkkK
	 8qZMuwKuGb2EtOHxWdtdLwPAx9SPuTBkHtwbDwiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 391/590] fbdev: omapfb: Fix an OF node leak in dss_of_port_get_parent_device()
Date: Wed,  5 Feb 2025 14:42:26 +0100
Message-ID: <20250205134510.227223509@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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
index d5a43b3bf45ec..c46108a16a9dd 100644
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



