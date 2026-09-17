Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08AD51815D;
	Thu, 17 Sep 2026 17:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667025; cv=none; b=oACQcbvAHO5xaUB7ijuOe9stC8tb65U/PAtOdq9uSG3cznOC4jHCpiMbYcPEDlEae2w2rhnHXytArn1ti4WZFMk0cnbHPfhNEXXsUNEVRp5l3VHQgFEZSZ3l9GgEOqpfQGkl4cQ3ziQAkE3TZqdIjJUVz6u2cJJDDQB2Rgmh7oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667025; c=relaxed/simple;
	bh=YcHQms2ZhDit6UerhPu5ELWjz/anI8/Z4tZfv+vFBTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9lwp7p+CMUaK+l+Sfl0X3oUxRser6hpgJuV4oV6jOiqwsEoaN7zUUkCmXsJ8uHU/sk/U0aquOTs3ZmRikyQEPd7LYzYggHlVdE3I+IK8hpXTliEvr51HMa5oY6mqt/vPpsWrykK/Qkcvmhek5t8oQPA+HSUzwGWOt6oDtil6ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKJo+EFH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKJo+EFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2707D1F000FF;
	Thu, 17 Sep 2026 17:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667023;
	bh=Yu2HSZs1b/b4jqb6cSxKn/DAZhtHIt9yidz3DT4Ipa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xKJo+EFH1OyO9xrYhIv3iEEXGqC95aU7i6cOXfN3mkr9t4ADV7bH4QhzC/J8ib5U8
	 wxaCyTXaxfTIUZmQlgtG5DaqKFoEdeu+9KnJTJBY6u+F9iDY+MARiAKnHVJ2JDWoAj
	 OlVGUT7C67nwv/c+AVxChmLTS9WTv8aLS9+EgNZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esben Haabendal <esben@geanix.com>,
	Herve Codina <herve.codina@bootlin.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.18 1204/1250] drm/bridge: ti-sn65dsi83: Fix error handling in sn65dsi83_reset_work()
Date: Thu, 17 Sep 2026 16:16:39 +0100
Message-ID: <20260917151624.915721027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Esben Haabendal <esben@geanix.com>

commit 4600b4d1a9ee730d03ddac5ce409cd2730ce8c0c upstream.

The error handling of sn65dsi83_reset_pipe() in sn65dsi83_reset_work() has
seen a couple of changes that seems to cause a bit of confusion.

While sn65dsi83_reset_work() has implemented an early exit if
sn65dsi83_reset_pipe() fails since it was added, when a commit from Maxime
Ripard switched to use drm_bridge_helper_reset_crtc() [1] the
sn65dsi83_reset_pipe() function would no longer return an error code, so
the early exit was then a no-op, and even on sn65dsi83_reset_pipe()
failure, enable_irq() has been called.

When drm_bridge_enter()/drm_bridge_exit() resource protection was added,
the drm_bridge_exit() incidentally was always called, which is the correct
approach. But only because the early exit in sn65dsi83_reset_pipe() was
never hit because sn65dsi83_reset_pipe() always returns 0.

In order get back to a situation where enable_irq() is not called on
sn65dsi83_reset_pipe() failure, which should help protect against irq
storms, we need to reintroduce a non-zero return value from
sn65dsi83_reset_pipe() on error, and fix sn65dsi83_reset_work() so that we
always exit the DRM bridge critical section with drm_bridge_exit().

[1] commit e17fadff7ab9 ("drm/bridge: ti-sn65dsi83: Switch to drm_bridge_helper_reset_crtc")
[2] commit d2e8d1bc840b ("drm/bridge: ti-sn65dsi83: protect device resources on unplug")

Fixes: e17fadff7ab9 ("drm/bridge: ti-sn65dsi83: Switch to drm_bridge_helper_reset_crtc")
Cc: stable@vger.kernel.org
Signed-off-by: Esben Haabendal <esben@geanix.com>
Reviewed-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260831-ti-sn65dsi83-fixes-v5-1-e712765d6c4f@geanix.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Esben Haabendal <esben@geanix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi83.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/bridge/ti-sn65dsi83.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
@@ -399,7 +399,7 @@ retry:
 	drm_modeset_drop_locks(&ctx);
 	drm_modeset_acquire_fini(&ctx);
 
-	return 0;
+	return err;
 }
 
 static void sn65dsi83_reset_work(struct work_struct *ws)
@@ -413,6 +413,7 @@ static void sn65dsi83_reset_work(struct
 		dev_err(ctx->dev, "reset pipe failed %pe\n", ERR_PTR(ret));
 		return;
 	}
+
 	if (ctx->irq)
 		enable_irq(ctx->irq);
 }


