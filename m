Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C3013C8E2;
	Wed,  5 Feb 2025 14:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767585; cv=none; b=qPaiZuEV7MB2lmipSMjVqxQzm+OIsuBegJYxgGZGeH7R/ui4TFrkUZOPEbF2Ni12HPPsJ9ZpuVvK0a5RAZyMp0pYa/qLDT3wIMFpTq9ywxjHikRlSKwB6ItB6Ci2DnQn8FYX/FHWWbuf0ZLrwPOnUIyStLy+5QFKbf1tbTECodM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767585; c=relaxed/simple;
	bh=y50EIaukuFV8n2z+V/VqvnY/2LEEQe0Qki/x3IFN8O8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXX+pdxsCMmbJHiVZoye5zBBwo0dSmicwf0ZWAvnRbE8O2Vk91sCUiUXFhXhI39E/1U0waAOFErzHcEFnxQUNOlRmEHgCtK3KM1BjawcC/PTFXjn9nU11NZs/l5mLFfYZXaGRVa/dLfZDK6RAKWM1GE8/5+sUbTCjF+s40TmCZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0YIcVTy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0YIcVTy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319F8C4CED1;
	Wed,  5 Feb 2025 14:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767585;
	bh=y50EIaukuFV8n2z+V/VqvnY/2LEEQe0Qki/x3IFN8O8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0YIcVTy8gELcMT/KmTjoPGKUlF503aXLam3GXYp9EtmZ/vghCNHA3T3LsomA+8WHN
	 QX10izac+zD3uEfPDqMKRHhaQ2MzZH7lh8V/V6HCrg1sUyFmznn4wWf/lXZNmIUq8a
	 mo1HFkoRfSXSVA/8kfmWi8wdpUF5mbwQeq5pgu2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 425/623] fbdev: omapfb: Fix an OF node leak in dss_of_port_get_parent_device()
Date: Wed,  5 Feb 2025 14:42:47 +0100
Message-ID: <20250205134512.483619567@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index c04cbe0ef173d..7c636db798825 100644
--- a/drivers/video/fbdev/omap2/omapfb/dss/dss-of.c
+++ b/drivers/video/fbdev/omap2/omapfb/dss/dss-of.c
@@ -36,6 +36,7 @@ struct device_node *dss_of_port_get_parent_device(struct device_node *port)
 		np = of_get_next_parent(np);
 	}
 
+	of_node_put(np);
 	return NULL;
 }
 
-- 
2.39.5



