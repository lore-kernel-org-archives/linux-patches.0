Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E59101F2;
	Tue, 26 Aug 2025 13:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213264; cv=none; b=ANxjHuFR8jclPTMEfmsbWCFmvkveV/08IyW6PywDIE6aSz7AYkanLbGeSw4WtUCnpPGkQLBC4hn2CMob1MfC5MtKt7dWD1qLKGJnX60DgsfNgXa3JrWpT59GpJuYtnwnUiRLYWIk3CJmh3lPWy1lj4W6ZtrJXXR6j0R6sinlnnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213264; c=relaxed/simple;
	bh=gsOMGmr7/O0qul8vYCKh+Y8cQ0LP32rvXgIbsEde5Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5Pxf9Cn1lQ5K26BqCcg6kmuemTE8yygyEr7RqBV/6ZapbvJ1d24zxJuT7M+afPyazASpuad3YrwCedHsVczEIa5JPmdvdu8a8v5VRimnq3GGxySyLex04nEDSCqyiFntaUVS1ia16oG+SxnXcCH/5JoxIH7eLwqfTY8ANeIr4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQYv8W55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQYv8W55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25233C4CEF1;
	Tue, 26 Aug 2025 13:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213264;
	bh=gsOMGmr7/O0qul8vYCKh+Y8cQ0LP32rvXgIbsEde5Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yQYv8W55uQuCWWxqLbqMaGxyClntQ2t3XAfdmx24iMpAEDJlKUMQ7H8SB6dAZzp7Q
	 F70x4sHA7e5pjhyo4B01arSyRTnr7TIKjJZ3DsKzPJVMHEu4fdOVC3MQKYvgbsO63T
	 I4fpi6tGyqA/k6P85CgfoQFmGY0S/24E5bz3IH8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 282/587] kconfig: gconf: avoid hardcoding model2 in on_treeview2_cursor_changed()
Date: Tue, 26 Aug 2025 13:07:11 +0200
Message-ID: <20250826111000.105531171@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit cae9cdbcd9af044810bcceeb43a87accca47c71d ]

The on_treeview2_cursor_changed() handler is connected to both the left
and right tree views, but it hardcodes model2 (the GtkTreeModel of the
right tree view). This is incorrect. Get the associated model from the
view.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/gconf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index 9e52c7360e55..a9f78e167e2e 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -974,13 +974,14 @@ on_treeview2_key_press_event(GtkWidget * widget,
 void
 on_treeview2_cursor_changed(GtkTreeView * treeview, gpointer user_data)
 {
+	GtkTreeModel *model = gtk_tree_view_get_model(treeview);
 	GtkTreeSelection *selection;
 	GtkTreeIter iter;
 	struct menu *menu;
 
 	selection = gtk_tree_view_get_selection(treeview);
-	if (gtk_tree_selection_get_selected(selection, &model2, &iter)) {
-		gtk_tree_model_get(model2, &iter, COL_MENU, &menu, -1);
+	if (gtk_tree_selection_get_selected(selection, &model, &iter)) {
+		gtk_tree_model_get(model, &iter, COL_MENU, &menu, -1);
 		text_insert_help(menu);
 	}
 }
-- 
2.39.5



