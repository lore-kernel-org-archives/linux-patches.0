Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D543376A5;
	Tue, 26 Aug 2025 13:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214670; cv=none; b=Od3bsOBxeg3wSn0fvE1cLwz6+GyT8DiKEotM/ryio5owX+uU4eWvOpGG96lfpLxSYF0chpvPmm5QZ3NOLxWjMW/cWmudFRqbBPusWs7aU0kSyQs29rpxAHFUQClbSGPpeNb1hkORZHB1SJTMJ5FmdJmgk1YKmck3j+FyLc3jPTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214670; c=relaxed/simple;
	bh=2N+Hklv+RBKb1YrmFpArKnBoVpHka8mW8KO+D2ryS4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7VS//2mlf/m+QWc7zMRUHEzpqoFdjnON58j4/V1hxPlID2hEAna4KZW81DRgMEOiwj/cG5+hB+e1vZARe3gAP8jchjmIIo6x0tCB/o1E/TNKXmbb5w5EWkOH0+3IJlU+nnRw+Uis7DKAhFyjubmY+syLv/QHAD8466D+yTeXgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s2TRPLPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2TRPLPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A556DC4CEF1;
	Tue, 26 Aug 2025 13:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214670;
	bh=2N+Hklv+RBKb1YrmFpArKnBoVpHka8mW8KO+D2ryS4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2TRPLPDxA8a24Fr3ATw/aW1wwZhcEczGEk2WWP7poLtJalw+YGqeM2IZcGN3k641
	 q7Xh5lfbWeyrpQU5X9tPQ+ugRML7fLBBOL95VT0+2gcXy3/a5ifIOs4mEwtIUhgMPR
	 m7L9BIGpCDV8W/O6bHL0b4D3THawkpraXyP0hEc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 226/482] kconfig: gconf: avoid hardcoding model2 in on_treeview2_cursor_changed()
Date: Tue, 26 Aug 2025 13:07:59 +0200
Message-ID: <20250826110936.358978447@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5d1404178e48..87f8a4db5bc6 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -977,13 +977,14 @@ on_treeview2_key_press_event(GtkWidget * widget,
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



