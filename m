Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680A7762D2;
	Thu, 15 Aug 2024 14:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730465; cv=none; b=Zf6G4yqWNr/jDtaY5wr/EoWzmAYGCot8ZJi72XLSMO/ulsAFFTSRdx9KDHz37MvMelt7fYeHX3SWNdTy7r3rfbmsD1P21tf6otONCGaa45hE4n9Q0HKQUEg/vqZRSMhlNaQ/bdeqyfpzSqmryIaQsUoJ8dqVJGu0JBCGhU++8qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730465; c=relaxed/simple;
	bh=C6nJVo0gtCIHqXQvu5P68lY+mBHdgWXUX/70ckB+Vlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPQqhAbwu6hUYdkyev2ilkY5LY6PdwRyCnu9F1oESksI2ycvB0s7GmtmwMDkTJ2/F5zFjmEsHcjczmA4HpBTckvue/Ne6/Vcp+BZLqMe5VLUJWsQ9spmOjnZOTrKalsh+Fbvj1tI8XTMNxeQ/MwjV8dIuuXGhXWxcQZdUD5KAfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0p4paM+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0p4paM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6715FC32786;
	Thu, 15 Aug 2024 14:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730464;
	bh=C6nJVo0gtCIHqXQvu5P68lY+mBHdgWXUX/70ckB+Vlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0p4paM+4YUmHW3pJH8wsrD4itiMVz91lI3tWeajcDHNC9uZPujBpWSC6Kaoz6diB
	 Y/QdtnpCBAkOfsggM+6+hQ3Cxe0uM5UmT7ifw9rLqjD+O99QZUQgfzmYEsf/7XSjkU
	 xurg0148Gs4xzlvXaQdL3Ut6vk6o9+kTHABmkz9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 5.15 416/484] drm/client: fix null pointer dereference in drm_client_modeset_probe
Date: Thu, 15 Aug 2024 15:24:34 +0200
Message-ID: <20240815131957.520843069@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 113fd6372a5bb3689aba8ef5b8a265ed1529a78f upstream.

In drm_client_modeset_probe(), the return value of drm_mode_duplicate() is
assigned to modeset->mode, which will lead to a possible NULL pointer
dereference on failure of drm_mode_duplicate(). Add a check to avoid npd.

Cc: stable@vger.kernel.org
Fixes: cf13909aee05 ("drm/fb-helper: Move out modeset config code")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20240802044736.1570345-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_client_modeset.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/drm_client_modeset.c
+++ b/drivers/gpu/drm/drm_client_modeset.c
@@ -867,6 +867,11 @@ int drm_client_modeset_probe(struct drm_
 
 			kfree(modeset->mode);
 			modeset->mode = drm_mode_duplicate(dev, mode);
+			if (!modeset->mode) {
+				ret = -ENOMEM;
+				break;
+			}
+
 			drm_connector_get(connector);
 			modeset->connectors[modeset->num_connectors++] = connector;
 			modeset->x = offset->x;


