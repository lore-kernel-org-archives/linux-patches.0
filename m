Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FED13DDC0;
	Wed, 19 Jun 2024 13:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803902; cv=none; b=RfrmnJ7XYABx6zQsLTFttuw2kDpbclXETZEyRmUOYe7IB6TcdErROF6Y86EatQlaqu1n7ATF3K6/oL4gBhdW1VCqtKHsL1hesIJ0FfBlkijm3Wl1W3tXlErSxzmHIn0+p946X2EGigYG/D32gmdmWYDdjJXByTsuEPwWqCpTb5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803902; c=relaxed/simple;
	bh=tVl/sZbMh3qQ83dfz5Rih11imMnYb+Z6rTj6vizGMcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1eB1RfyGWpFEpedq/osJ+lzo4tkgrmgcrEG4O2EbI1vEd7zKhMfgJprnsUi0G9JF754qp2Fb6sFgM7WZMhDgdGxSasKvE5CtoIvpjH7hYvaENmTqx8cyBVNaV+/QuJu0S0RcTi8GaSPBAZl8awiFaZ7MSYK1veZo5rbcqx1BW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HReWjS1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HReWjS1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4009C2BBFC;
	Wed, 19 Jun 2024 13:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803902;
	bh=tVl/sZbMh3qQ83dfz5Rih11imMnYb+Z6rTj6vizGMcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HReWjS1VJ0qPH5H8DfoeWp5qhUgc8o4Ts8ce5/p7H2/EGDJgQUs3OG+rxTfrZ2jGO
	 uYPZD87Nh2eeyHgKLfxyBTKwXXbSG2gsXgq+uOclUs7J9XuPy1+beHCZ5ualYXjkzH
	 8qQLY0V/np4raDUmpyPlqNC2btKpbvSiPYt4Y73U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Miotk <adam.miotk@arm.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/217] drm/bridge/panel: Fix runtime warning on panel bridge release
Date: Wed, 19 Jun 2024 14:56:26 +0200
Message-ID: <20240619125602.209795525@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Miotk <adam.miotk@arm.com>

[ Upstream commit ce62600c4dbee8d43b02277669dd91785a9b81d9 ]

Device managed panel bridge wrappers are created by calling to
drm_panel_bridge_add_typed() and registering a release handler for
clean-up when the device gets unbound.

Since the memory for this bridge is also managed and linked to the panel
device, the release function should not try to free that memory.
Moreover, the call to devm_kfree() inside drm_panel_bridge_remove() will
fail in this case and emit a warning because the panel bridge resource
is no longer on the device resources list (it has been removed from
there before the call to release handlers).

Fixes: 67022227ffb1 ("drm/bridge: Add a devm_ allocator for panel bridge.")
Signed-off-by: Adam Miotk <adam.miotk@arm.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240610102739.139852-1-adam.miotk@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/panel.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/panel.c b/drivers/gpu/drm/bridge/panel.c
index 216af76d00427..cdfcdbecd4c80 100644
--- a/drivers/gpu/drm/bridge/panel.c
+++ b/drivers/gpu/drm/bridge/panel.c
@@ -306,9 +306,12 @@ EXPORT_SYMBOL(drm_panel_bridge_set_orientation);
 
 static void devm_drm_panel_bridge_release(struct device *dev, void *res)
 {
-	struct drm_bridge **bridge = res;
+	struct drm_bridge *bridge = *(struct drm_bridge **)res;
 
-	drm_panel_bridge_remove(*bridge);
+	if (!bridge)
+		return;
+
+	drm_bridge_remove(bridge);
 }
 
 /**
-- 
2.43.0



