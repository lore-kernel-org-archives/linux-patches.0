Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBE22772A;
	Thu, 15 Aug 2024 14:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732835; cv=none; b=DBlwFuXgEUMEi5biN3y3Xe4GjGri4+yJE8ChA2j5DDbsDSdHJ2fq7H57MC0yaXEaz1jfmPQHqa+fvpToWJCr+/cythdg7NpV0HyMBl8NHYAsSSLDxZU80ZG0e2s9S8eLBijNOlCzTumsFW83Gw26xYdGnSXQYYxhWSZ2JBA9MnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732835; c=relaxed/simple;
	bh=cA+9bUXQofDfUcnWe75Ys0dQHPqfZ2a9A/G3p5k0Sfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/mGB8suQB1qIl94VoPAvCDChOxwl/EK/ie+CDQt3nmotDGUU2/fQtzDNDSyNpf3lrN0AGuGzpkGyUljqA5nNClUjNRvbkoxVdMg38tSA0AB1e8lY4SI45n76RLoE0kywnvz+tM54qIJqb1BeIhdeBeroy6BbRM0YYd4aaZmx/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2YNUzfi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2YNUzfi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941D6C32786;
	Thu, 15 Aug 2024 14:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732835;
	bh=cA+9bUXQofDfUcnWe75Ys0dQHPqfZ2a9A/G3p5k0Sfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2YNUzfi5D5HPuuo/hexjBwwVXHG6kQwI4u/AVI2w8J7ZuvTQxOyW0Ki9eV85btU7
	 aRu5Ed+3jtyA+HAXA3zEsIikQLCqonP7m6kXvMDszkQtaj+uRyYhuCSOCJQgX8Dw7t
	 086/8BVd1Du7kmLtht4bY3QbTsKxRR2MJg1XUdk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 5.10 301/352] drm/client: fix null pointer dereference in drm_client_modeset_probe
Date: Thu, 15 Aug 2024 15:26:07 +0200
Message-ID: <20240815131931.096027106@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -866,6 +866,11 @@ int drm_client_modeset_probe(struct drm_
 
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


