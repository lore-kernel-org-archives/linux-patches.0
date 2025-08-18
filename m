Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDA427F736;
	Mon, 18 Aug 2025 13:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522557; cv=none; b=fDDHqZdamg7IovuF8Adv78exF/m+sKG0erewJIl6odozp4Oi7FLn+MXSV3aTataGm1P6+1jBsBc/sDbhgVCT3DWy/vXLchI0OBHbAaaX8msls9sxodKTLgdINSm9hIJFXa5gA/UbRb6ldTyQc+vFR4srTS89MG4pE5TB7PeB4YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522557; c=relaxed/simple;
	bh=HEbxQ3B/GdpVsodCawBZXoDuTkHpPU3/mJQolFZyKdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T735/1Sz4o6jP2+gnrrHbPGeLjn9dRiOJOh5Fu0qy+8Y+/e/Yy41rZZ2DwUb/Rf3pZa+/mfiApY2utw4juDVKW8bOdqoS/iFdOc/ZeisFVB3j2d+5gCT2JzrEh2mEGwy4EX5ur6m6teNJzQ2sOgQ1099s/rCfxIhu4Jyt34Z7vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PgjBwc5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PgjBwc5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E7AC4CEEB;
	Mon, 18 Aug 2025 13:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522557;
	bh=HEbxQ3B/GdpVsodCawBZXoDuTkHpPU3/mJQolFZyKdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PgjBwc5SjU5uz/BXrHFicFXsE/F+scSzkm86PJuMILAcebuls3k9ssNi9OsBJXyic
	 4oYiFTIP6dnocXZaIVx/SjCCiZl/hhzFjMAiNHAdPKx+USr9njXw9gb6O3MctydBIN
	 zwjrjK/6psON4GJ1hrAGbuAfOUAfKLsOYrOiv75Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 351/444] kconfig: gconf: fix potential memory leak in renderer_edited()
Date: Mon, 18 Aug 2025 14:46:17 +0200
Message-ID: <20250818124502.080165091@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit f72ed4c6a375e52a3f4b75615e4a89d29d8acea7 ]

If gtk_tree_model_get_iter() fails, gtk_tree_path_free() is not called.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/gconf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index abe4cfe66b14..0caf0ced13df 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -748,7 +748,7 @@ static void renderer_edited(GtkCellRendererText * cell,
 	struct symbol *sym;
 
 	if (!gtk_tree_model_get_iter(model2, &iter, path))
-		return;
+		goto free;
 
 	gtk_tree_model_get(model2, &iter, COL_MENU, &menu, -1);
 	sym = menu->sym;
@@ -760,6 +760,7 @@ static void renderer_edited(GtkCellRendererText * cell,
 
 	update_tree(&rootmenu, NULL);
 
+free:
 	gtk_tree_path_free(path);
 }
 
-- 
2.39.5



