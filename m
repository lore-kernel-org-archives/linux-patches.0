Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407481AC896;
	Thu, 15 Aug 2024 14:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731757; cv=none; b=T69lqWBZCTyCydkqgCLtjqLdyjTorcdzXxz178WNzHgjQ92/BnVitAxoQquDUjgckNqZ6oasZ83csOiQnOKAXQUyvKtUxGsMvmSCxqYqZFdN/ZuE79Lqz0Pz4wUh4DuzV9S7XmNpGH8qY7qg7gOIuHOCDc0I2rBCeX2MLbRQFE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731757; c=relaxed/simple;
	bh=TGr3xFLJGydlOPQM906cuid03lA00r3SurCZsOXr3gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P65SOudPngyVZ18JCqEjuu3byILoCQ4GT9hvdisNqo5tx64ZPfuq+pqdByDlGXnE2cllWPHpFB2oJvDJK4VDIy+q/S1ojQTxFIVJBIv25iUXP+fkgnYShc1UzRxBar3PUFUAJBdYm9ps6xOsfpxFbuSyqBAdnm9RlX3kNaAAyX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=svGqThm/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svGqThm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEECC4AF0C;
	Thu, 15 Aug 2024 14:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731756;
	bh=TGr3xFLJGydlOPQM906cuid03lA00r3SurCZsOXr3gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=svGqThm/dY1SwAC71eWElNCGYt9ltm4XF5432V3f1bPrRaehVZnM+M5SkTE5fYyjR
	 w7KuHOSEYmUDEuA97beAYlP6HnWUD0x69cxyrp0uhrQjBhgDjEl24qGWwwFt+KzsYa
	 n/edZhyEuh2QvgptWjgZS282wA3jE0T2FLFyEc0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 5.4 227/259] drm/client: fix null pointer dereference in drm_client_modeset_probe
Date: Thu, 15 Aug 2024 15:26:00 +0200
Message-ID: <20240815131911.546893917@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -792,6 +792,11 @@ int drm_client_modeset_probe(struct drm_
 
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


