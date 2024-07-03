Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07920180A64;
	Wed,  3 Jul 2024 10:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003406; cv=none; b=jIEvryTkNIWiEzCsh19WpkWZZ5kJXkyVA/RZ5VKeLWbrisgjfRlLTbEeUNz3GcpuIjRHAgnPqTk2y/ivVWyhbm6wDjAGAUZUTj6eRdlY2jmRL+E4XK7D9SqiTrTX4KtBJfy3UlmRKogjUkMwy4J83mGhGzgjTZBC8xgWg2Ta7hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003406; c=relaxed/simple;
	bh=9/OAxhQhvzm/02wtr5grrOuLvHzwjkzD69BUF5prtA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bO62all0fimz6ucIrMAMj6Zhrwzk7LhtI5hRz7qCVHNIZEoWrUPHNJAeNC35IXrEtuDTEyU2CM9M4npFYav0JikvyeyZiNd2dk021dxz8LKdvvAqD2PAZv3aV0tlzymtJFJz+MmZsSjUyiowZnQSXcPxxnnYiqIAQaicPAqUjUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oegmIWHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oegmIWHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BADC4AF0D;
	Wed,  3 Jul 2024 10:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003405;
	bh=9/OAxhQhvzm/02wtr5grrOuLvHzwjkzD69BUF5prtA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oegmIWHS8j05KrpSB9mhuLEfZPfXbVp8mKE8iOvaFfAKNSj949IbeGIrJqZyYctak
	 KXdvful+EDueU+MJ/t4dWfifjl3E3erQ/b/fmI5J4oTrNfuzsW80KqdHvxhsTGSLF5
	 Vivkci2JQKPmEE1HOTqAzgznDQuX+HaTxE5L1tfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Miotk <adam.miotk@arm.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 039/139] drm/bridge/panel: Fix runtime warning on panel bridge release
Date: Wed,  3 Jul 2024 12:38:56 +0200
Message-ID: <20240703102831.915091826@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 7cbaba213ef69..2d6f8280fc712 100644
--- a/drivers/gpu/drm/bridge/panel.c
+++ b/drivers/gpu/drm/bridge/panel.c
@@ -205,9 +205,12 @@ EXPORT_SYMBOL(drm_panel_bridge_remove);
 
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
 
 struct drm_bridge *devm_drm_panel_bridge_add(struct device *dev,
-- 
2.43.0



