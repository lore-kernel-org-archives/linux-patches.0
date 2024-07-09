Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5671313A25F;
	Tue,  9 Jul 2024 11:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523769; cv=none; b=WVkZKm7FgKd+IugEbTlj0aSEkeTDn0CEPrY6251gZq0eiN/I6nso5wEWzXemDbViN6mKxI9S6PO/Pa/MEWH33U1S2hKzM82EsT4SDQFaUFHSs4K9aMdBTx0hFZ8MwdFJTepZs9ONdwDgRfTnI2wM6zFt3FpXyBK3mBGtpTwlOKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523769; c=relaxed/simple;
	bh=N5jSwKJreAVsW6UlydfOWvHukgs/GmmQGXBBEtgT5Ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDwAgkAhreY1SsUuete6hluhNVdC0RgvrvREyFMg1bBx2Wq/QoOm8qyuQ32mA2xkCtRQnwP1Hlpg+3XqJrSoM/Kcuhw+xLae2J2sZA0aLJXhsnd2bkWAvz3Jl9Cyhma3Mmiz37vmTWosYWPXa6P8XlapMNqI4ob4pbkIbSpQKDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5GJ3ca8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5GJ3ca8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDF4C3277B;
	Tue,  9 Jul 2024 11:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523769;
	bh=N5jSwKJreAVsW6UlydfOWvHukgs/GmmQGXBBEtgT5Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q5GJ3ca8uVBgR9GnkNEP178vGWa1lT9QsN3Lwz4mWJ2IdH0ieaq8bEiwthlsWMIw7
	 OJE2ry3weNCbP5XQHGXZC7UQzGKVIwck4Dve5UIt7BGX7wutMFFUS3ixYQHMn/s2wS
	 IMF2e+vyde2W1PFfLUqEFXGgPetTZjWi7OG4bFWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.6 102/139] drm/nouveau: fix null pointer dereference in nouveau_connector_get_modes
Date: Tue,  9 Jul 2024 13:10:02 +0200
Message-ID: <20240709110702.120385942@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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
@@ -983,6 +983,9 @@ nouveau_connector_get_modes(struct drm_c
 		struct drm_display_mode *mode;
 
 		mode = drm_mode_duplicate(dev, nv_connector->native_mode);
+		if (!mode)
+			return 0;
+
 		drm_mode_probed_add(connector, mode);
 		ret = 1;
 	}


