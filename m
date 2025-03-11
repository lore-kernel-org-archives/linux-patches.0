Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F199125DAFF;
	Tue, 11 Mar 2025 15:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705472; cv=none; b=RmO3M+jdalXB3/Ux0dMIzpWMlv0T5szI6/YyAqmkbmFYIsL9/EtIBbCu4yEfI5M8QDFpUHM1cmZ759Xl7wTPoVX2Hj4QWn7FW81P4fQQYOz5rI92o47rRVWa8NZj/iY5RF4WCSK7FmT9dBfAAB3sv1N84pAXpDzwHUpX7W+EPqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705472; c=relaxed/simple;
	bh=7eLP1PF0uu3uiUqfzC/VprYJKiq5bW2UDUMFmZ7rlcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dm8rGHce0MeE/07LdNxmg3qMALGgO7cxb4CsEj1cEh8GDUVuimrpsZfzhjUoq038+3a2PRhmx6cxVDAUZ76btuTk8gDuLTDmwSd0ewwY2xNcpuQAPp9/zx71GyOKJ/rcr1zlLiTXuFbDSg9voBAeVnhlfG2BIxilXnv/Ghm6kFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YcAcCEVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YcAcCEVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A94AC4CEE9;
	Tue, 11 Mar 2025 15:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705471;
	bh=7eLP1PF0uu3uiUqfzC/VprYJKiq5bW2UDUMFmZ7rlcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YcAcCEVuBKAw7UdAgB8qbL0hTlSdTDYeN6JwfVhzMvGpUO4Ih1YfWNxFVVHEAMgEG
	 /9WYI97flAuImvnoQvvjlCGMan7/5HvbboKXRSSXawxaZWguHFAJLajdfa2SDkTXxB
	 e/gzGO6e2n9+OJ/cigcgGaothLBrOcs00CujCSpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/328] fbdev: omapfb: Fix an OF node leak in dss_of_port_get_parent_device()
Date: Tue, 11 Mar 2025 15:56:57 +0100
Message-ID: <20250311145716.762119412@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



