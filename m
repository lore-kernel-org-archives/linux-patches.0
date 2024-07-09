Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AA255E4C;
	Tue,  9 Jul 2024 11:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524709; cv=none; b=YH6c0/mIhbqU/nfuXC+GH6DNCCQLj3W+P7/dWWWCFF4aDIvTLwNmf9j3eWi9ZOw3ruzhqfHeFxHifJyQJ92XVO7xfljL3DJHw9/M2N+gHpElCO1tmeLcrIGhC1LBoyfO6sothlEdy2oIpKExsJdQc66DMOgEYbf4lHp0fyZxY+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524709; c=relaxed/simple;
	bh=jm04+2Uj1qhlIMJIjYHj94I0kcCIabFHP6Dqp+2fL3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dt5dwb+ny3Y0EQ8g/wjt8t8QU3qT/GV1ah6cvq6oFiIeycBiB+bFShuX5ZvEWy2kXBcuygf2vZ+IZ56kECKEaeEs9Xlikc9n3fXmOv2jz0DwLRf1rhDM+DQf725gr+tWaJjBBUzFGcI/RTON+tFvAS6hxXxpaRpnWdlrrKwFeDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTY3YLY7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTY3YLY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8325EC3277B;
	Tue,  9 Jul 2024 11:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524708;
	bh=jm04+2Uj1qhlIMJIjYHj94I0kcCIabFHP6Dqp+2fL3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTY3YLY7Ermobr7CNra1fOgmQYKmvVeDKatIbcaxJ9p68gPmNlSbr8Pc9THQ0tXZh
	 wEgFatdZINQYovOuMO+X1JmBjPfuVqh0Qa8/tvEVU9SOaDFvFDWITnLGIpTjlQYWCJ
	 00MTkpMZJrN1PFjeuz/UO/TtvIV0+r8ud1OH9kDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.1 074/102] drm/nouveau: fix null pointer dereference in nouveau_connector_get_modes
Date: Tue,  9 Jul 2024 13:10:37 +0200
Message-ID: <20240709110654.254981050@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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
@@ -980,6 +980,9 @@ nouveau_connector_get_modes(struct drm_c
 		struct drm_display_mode *mode;
 
 		mode = drm_mode_duplicate(dev, nv_connector->native_mode);
+		if (!mode)
+			return 0;
+
 		drm_mode_probed_add(connector, mode);
 		ret = 1;
 	}


