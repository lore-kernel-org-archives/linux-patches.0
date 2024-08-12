Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB449183CC4;
	Mon, 12 Aug 2024 16:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479516; cv=none; b=MwLS5sBUQMh9vK8WUfXX+h/ayUeNBB0fyAKokrojgET7Z9x/Jd9xVTVon53cYgPZB2jIyNnn2YMYR6YhlWyfgqgmFkjb1h361EEH1By2GDGI37lfWK6bFwY1Dv7bx1CARuAyWa9AIIz7f3bHbEUcIwkBTP8vH4EPGcM6Burd4dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479516; c=relaxed/simple;
	bh=NPrmhYh9didfZLqCRVzMiAun5sevs9fOUCF+lB3iuy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=juvPv6nWsvGg8IwuYbzHKrnsZXHCSwzteTQGLA9T8pjLuRX0GvT4sDSZ5oD6AprKih3mSi1whP3CnJTTOaeAhuR0e1BuVm3ugppnSIMfiyTGAVHAEwIMgZdUnls5xKVEPW5asGzswrMCPZ+DlVva0cNV1T5kNOKdgmcqVkqzqAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cMbkwvTu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cMbkwvTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA391C32782;
	Mon, 12 Aug 2024 16:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479516;
	bh=NPrmhYh9didfZLqCRVzMiAun5sevs9fOUCF+lB3iuy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cMbkwvTu84SrUrnKuIP5Y0P5oJ5NstFXxXf/sZHLklK45Tabg2OxBtBk13YAv4evE
	 /jb6fKI7MtFjrMRy/utB+rJ7B1FItSWs90wSKlfwqpn+Esh/Dgi9AP9eT5Fl8V91Gm
	 J85BUvZjPFD1IsjF1mGMJsIz80DKRBX9iw3XL0Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.6 112/189] drm/client: fix null pointer dereference in drm_client_modeset_probe
Date: Mon, 12 Aug 2024 18:02:48 +0200
Message-ID: <20240812160136.453449090@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -869,6 +869,11 @@ int drm_client_modeset_probe(struct drm_
 
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


