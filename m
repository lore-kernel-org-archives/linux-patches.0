Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE88A335BA0;
	Mon, 18 Aug 2025 13:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524244; cv=none; b=D6YXcPnFKRPbwlVSqSVbSYXS7BLXnc2ArNlzG5V9F3A++GDh204wefUDoF+/udihSHzKC+sVorG1L6fv9yDzutZkOmwvs/CKUgQ8SEl+49Ne46RQTua2EfR6SpbFZkLKpjC1i59djCLm0P3bLbp4+z+hgBLNv9NSouImgK9Lk5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524244; c=relaxed/simple;
	bh=SwoBefCQlFgOZEWKvS2Feg9hn5hRC07gjdGgf8x+wsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5VIkJOhX0sgLoACIURXWn9XkSVHEbbmJWNs/vwTk0KcOJ+20CvBSqRb9F8JD797WeWzLHeegAUNiSGCsD0Tx/TZDj8JyPOLJ762Xs9oYEZIv271zZBgyoS+H2XiLT6/HtJMcuusxsKEBZO3j5pchzQDin3luyaiOKkwaH24ges=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsSfit52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsSfit52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448E1C4CEF1;
	Mon, 18 Aug 2025 13:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524244;
	bh=SwoBefCQlFgOZEWKvS2Feg9hn5hRC07gjdGgf8x+wsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsSfit52J0oGqoG6tkCp5TJrrAQt1cXdbjFkEBAW4m8Lc7ta+E3cRIwFZ/FOFNjGs
	 MbqLwWb7Hk97CHtIvOkVTCGoVW8ElqXdsfSZi1Be2aPb7DwQ0uG62Rx3yA4691X/XQ
	 LYLVmqXeSZIHgX3zTzCdrYyVC5693SDkVQUEuXGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 413/515] kconfig: gconf: avoid hardcoding model2 in on_treeview2_cursor_changed()
Date: Mon, 18 Aug 2025 14:46:39 +0200
Message-ID: <20250818124514.317187916@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index c0f46f189060..abe4cfe66b14 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -942,13 +942,14 @@ on_treeview2_key_press_event(GtkWidget * widget,
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



