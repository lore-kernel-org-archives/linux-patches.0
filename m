Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893CAD53B;
	Tue, 16 Jul 2024 15:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144127; cv=none; b=OBih37VkamDxlbko3rAowzxtLukBb1p709Y3LCqsv31Se7jhqVL7zr1BUcWhosaN/b2lfqU3Yp2afhLPcygASomD27K8rkWmyNr0GDhfyCMQPK4lgRUHZzl1mMPC4dARsyEARGFIyGi/EPRxmevq0aKyTzrCHao6xdkbjreBwLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144127; c=relaxed/simple;
	bh=sNhdy9+IolIitAFkE9ggsjzYQenndzpEbrAcwYmUTR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrRiCyoRr23rOuhmUblRJQSQvzmD/k9VbiF7P5v3x0fvEybq9INw21VxAk2rn+j3FQjvt7WBBdIO1Uv0IkcwaFRqVM+/ncwurIM/4Gw5KT58+iR4d1KbjcEJ7iWLcKRfmKVjsWRdGWGNuX6ya7vYszu6eh/uwGz7GksrzZcI6OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CgVEnBLu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CgVEnBLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBCEC116B1;
	Tue, 16 Jul 2024 15:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144127;
	bh=sNhdy9+IolIitAFkE9ggsjzYQenndzpEbrAcwYmUTR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CgVEnBLuOdXU1IsfaEX2Ck4jWqY57H2KA7Y1o2NQhiwwnu9sFLWZtBU6B/tsVcssF
	 5Xsi0EwJ9xZzCGkQ6JweY0WekEv20GcKPPkBG9W/Lq4tdsoOuqcZCzU2tRoS5Aj1Nh
	 lbJqFbGGVEheMPF59w8AIN+eniwnoagYYtNmIlE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 4.19 36/66] drm/nouveau: fix null pointer dereference in nouveau_connector_get_modes
Date: Tue, 16 Jul 2024 17:31:11 +0200
Message-ID: <20240716152739.544841135@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
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
@@ -934,6 +934,9 @@ nouveau_connector_get_modes(struct drm_c
 		struct drm_display_mode *mode;
 
 		mode = drm_mode_duplicate(dev, nv_connector->native_mode);
+		if (!mode)
+			return 0;
+
 		drm_mode_probed_add(connector, mode);
 		ret = 1;
 	}


