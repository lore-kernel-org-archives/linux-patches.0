Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C822FDC5C;
	Tue, 26 Aug 2025 14:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219123; cv=none; b=H77W544GxR7waB6u5ouwwqq05MCJROfA29GOvIvqNNxbNj85xFMVfYCKHCoKA9KInqnPvUOiZctcJWhdeAwyelM1MbxOggAW+xDP/6bXbFOH52tbLhIeMDb7AMJcxBxuThFxM3ZoMYfQgjfKo/29z/16hAXEDnOVupVQa19nhw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219123; c=relaxed/simple;
	bh=W+l6RGLyTdqkx9beWQBwrb/LbwulZ154XBR4h5gq9b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=liYX8ViQ4p+ygWXL6M9poqhUlIAqnMvdWGDGKnTCMyUB3YJC+tN0b9g+3VKLdReovr9OGcZcUc0xSNr0nGRAoJCTgYKsxsJgYzxFk83flr2g/t7bGDCX/SZprbMp2AwcvElAh8wfcNu1rwNUcgDtWOd1os6Badr8UJaIKEbUCsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHXBB2+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHXBB2+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF452C4CEF1;
	Tue, 26 Aug 2025 14:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219123;
	bh=W+l6RGLyTdqkx9beWQBwrb/LbwulZ154XBR4h5gq9b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHXBB2+liay7AeyArOVq2oNIisdkes1MgwaGnsXVDtbcX5gIsj9b0s6+iqiwHS6y6
	 TdfCP0algidMWEMv9b+niqm1Nc3iOyelPjAvhMjKg/BDalIlxB1TkTXMmlHP38TEDW
	 uLYRRKb4QHFgorJ4q14RPyGWdNZI0kHRd7f6VwW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 262/403] kconfig: gconf: avoid hardcoding model2 in on_treeview2_cursor_changed()
Date: Tue, 26 Aug 2025 13:09:48 +0200
Message-ID: <20250826110914.052870300@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9b10f1248da1..bd1fdbd949cc 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -980,13 +980,14 @@ on_treeview2_key_press_event(GtkWidget * widget,
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



