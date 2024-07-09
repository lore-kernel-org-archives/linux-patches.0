Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D34A27713;
	Tue,  9 Jul 2024 11:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524342; cv=none; b=SwL9TtFICpXRzmAC4VHuughmg5ueko+lAM13P2gzWNSaqEKEGGnX55uJAaRAxpeSoHKRnnqO+a4+gqepzTsSPL8O+ve2q2YG7k6+Yiks0txNACCilnP+zHt5YpHZyKZLozUDurzV7map1Nfv6z28MdW6V1MFUq6yPYmt+s02h7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524342; c=relaxed/simple;
	bh=LjubLiAT+BXWaqtfJSBed1h+oa+YHPYtS4S4VUWY16g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGQjs0BSee40y7RR0jS4QdfxnMc3y+byObAp0p/tHPpTI0qEKdWSeI68VcNv98L+ZZKPT5b4lc1B7MvnCzNNTfi/6bCY+inAhHjjWjBsDk5/hhCpd5DjnSmzZuXqsW0uRuiYckWfaOjUQRysnyL6vRwT9Ztbmx3cq1/vRC0MrM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dGkmMhgJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dGkmMhgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8514C3277B;
	Tue,  9 Jul 2024 11:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524342;
	bh=LjubLiAT+BXWaqtfJSBed1h+oa+YHPYtS4S4VUWY16g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dGkmMhgJMLs9+j+VXktfHjbzyQVy/E5U+NRiI93gvkwVj7NGxoQZ2I+ar8vpHRmuZ
	 vWu671Sbeijhhiq2QjJCEb9/zVi9q3lgGXuNBfxZ5WQVWGb9sAAcjTJThqflytm5ct
	 ldI6KZc58yN4Lbng9XChTTqXb/G8pMSsddKiR9s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.9 151/197] drm/nouveau: fix null pointer dereference in nouveau_connector_get_modes
Date: Tue,  9 Jul 2024 13:10:05 +0200
Message-ID: <20240709110714.796016736@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1001,6 +1001,9 @@ nouveau_connector_get_modes(struct drm_c
 		struct drm_display_mode *mode;
 
 		mode = drm_mode_duplicate(dev, nv_connector->native_mode);
+		if (!mode)
+			return 0;
+
 		drm_mode_probed_add(connector, mode);
 		ret = 1;
 	}


