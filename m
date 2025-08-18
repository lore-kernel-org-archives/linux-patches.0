Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE44B20010A;
	Mon, 18 Aug 2025 14:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526122; cv=none; b=F4EftRbmv5Kan6KWOZiYfId0DigZ0Vi0+RViP8Bsmm4/zet0ha9GXM0Q7/Pu70oObK35A8/3/dvV87XhZqJ3ImcTXHE7zOK9XTqQsV9oYosLhrZL02qsuqOTRG4UY/kW+BjjgitRKektDQmtFc3cNugfbms+qB+N+YIpH/PBP0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526122; c=relaxed/simple;
	bh=/aqiaxOrCTyCFV67dPi6D9oPv6KmJH9/wrxv6+YAB5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cS1m+7vLY69T7srxO30iJ+poD0eUanwlP6fC21PbglbjNFZjJls0NOMX1fEpH8hn/SyPfaD/Fl3b5kajRNRItX0nEQzbE/WPP4aOhJmKw5SrHeeipQfyEF639JezWNU6Quk2LDQoOrS+jFrwHdnk2S/WSYvTXZt8Z4FT30vsAKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3wCez6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3wCez6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1639BC4CEEB;
	Mon, 18 Aug 2025 14:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526121;
	bh=/aqiaxOrCTyCFV67dPi6D9oPv6KmJH9/wrxv6+YAB5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3wCez6RjVpRjXEiNzPtoFbBgiY5I24YoMgfyVIRqtCLzGSaY+ee228jwm9kfq8FD
	 Of3pfKl79GuE/E+r/xsiXqjEW2I7Z7403ea9XCydYpNZFSYp8CWbXjZJ/F/KnxBIN/
	 gMhImNrie63x27NaUpb/VJDjCgZarDxyaNyYpreQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 447/570] kconfig: gconf: avoid hardcoding model2 in on_treeview2_cursor_changed()
Date: Mon, 18 Aug 2025 14:47:14 +0200
Message-ID: <20250818124523.035766150@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



