Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4F2352096;
	Tue, 26 Aug 2025 14:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217923; cv=none; b=jvgB/rj0sTs9mr5nkyO0VnnGkyJttWHV6E4NBPwSOMjC/EP2ATpxeFFoshBU1CvuD/YYLT9P65ka6vndOxPzmzHDRACzxIcgzetHP9BHkcPlxePiQroywgrfigF/tMewj0Y5hJ/peRc9uYSjQaYojMuKC4U315hlQoLONNPZnWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217923; c=relaxed/simple;
	bh=N8WgroJj001A72DU0bgbTMM0nuXy9FTP97sEWERgD0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBi20d7AbqtpGNcvjYaWJw7HXLhbiH+EE7Pq9ydIg020aGu7Hmt7n5Ajp2T3nruMorel0pCWl3sfM89M65XCH1TF6x0fAHGVzA7P5IKfBmZuIB0+M6YfY8ev9sco2OOgsp3MeqG7zGvJIvK/yBYa0SinXaAqPI/pJfNCtdHyqDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KhttThyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KhttThyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EAF2C4CEF1;
	Tue, 26 Aug 2025 14:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217923;
	bh=N8WgroJj001A72DU0bgbTMM0nuXy9FTP97sEWERgD0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KhttThyrTmWy+Ue2Dy5akJQfluK0bfK8Vz93lSg1/F5N3WnW5z63B0uJk5zmJht/k
	 byUYzltvYUtujjP/03V4qAvGq3/SkmuJxTdjt7Vq8OnhzYU9ttQEXDFyAe45fgayfq
	 +S9HgrMoWhIaVV0nWp4VjohX+Msa5Q2rygl56lco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 326/523] kconfig: gconf: avoid hardcoding model2 in on_treeview2_cursor_changed()
Date: Tue, 26 Aug 2025 13:08:56 +0200
Message-ID: <20250826110932.515368320@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 409799912731..50c1340cf636 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -981,13 +981,14 @@ on_treeview2_key_press_event(GtkWidget * widget,
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



