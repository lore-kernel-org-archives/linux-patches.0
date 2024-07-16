Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AB3F9E8;
	Tue, 16 Jul 2024 15:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144587; cv=none; b=JayLReJh/9TmXEhOzK+Z7KzqnXloJ+rgDdUp+/RBVOcSEAwGurR3JOHISM4BI1vquJtsc49cvnp/DwXU2gxpnsfuVeYM5TdW+w+B942do/qhJVQEMTioQJCWQYEzFygKBjeGgBc7QUaGLTuMJEaIjjp3wding/6Bv2DvotHUxNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144587; c=relaxed/simple;
	bh=sLd2hbb5d6OTw+rdHSxSyymSPSVQcR5I7bwnTde9txM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfNFB5D/bQq58I0VVK1cfGONoKeOljXF7sYSV7NnLZss/p/I2W3cCAQrX6+MGSEl7B8jkkLtpfvVtKuUyILOY+hZKCyaZZicVDnPfzu+8hMsFWR7f71bB0F0mpnGnu7FL25nzOQZqjDJRK3uaLpRFZaa3q2sCP2wZbCq/XLzCj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BWKWtIeR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWKWtIeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD0AC4AF0D;
	Tue, 16 Jul 2024 15:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144587;
	bh=sLd2hbb5d6OTw+rdHSxSyymSPSVQcR5I7bwnTde9txM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWKWtIeRExlre5UdE+WYqGJRLaBcOKVFWL9OseyrzZCfiBuEOuosXrR8XQhnp1VV+
	 LOOCopxDWB+4gwZjty26cxgBtN3SuvajukHqUgVHZV6oubp3jndkgOfboQjTf6KkMX
	 WrQ2PKChCbGTPTRpHrokGJAKjwYmvlCd+ZDXmLFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.10 042/108] drm/nouveau: fix null pointer dereference in nouveau_connector_get_modes
Date: Tue, 16 Jul 2024 17:30:57 +0200
Message-ID: <20240716152747.609637168@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

commit 80bec6825b19d95ccdfd3393cf8ec15ff2a749b4 upstream.

In nouveau_connector_get_modes(), the return value of drm_mode_duplicate()
is assigned to mode, which will lead to a possible NULL pointer
dereference on failure of drm_mode_duplicate(). Add a check to avoid npd.

Cc: stable@vger.kernel.org
Fixes: 6ee738610f41 ("drm/nouveau: Add DRM driver for NVIDIA GPUs")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240627074204.3023776-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -960,6 +960,9 @@ nouveau_connector_get_modes(struct drm_c
 		struct drm_display_mode *mode;
 
 		mode = drm_mode_duplicate(dev, nv_connector->native_mode);
+		if (!mode)
+			return 0;
+
 		drm_mode_probed_add(connector, mode);
 		ret = 1;
 	}


