Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8106531E103;
	Mon, 18 Aug 2025 13:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522554; cv=none; b=RbLEuCtUsqGfktBJTMVXxmcTqwkXt50wvSRSjIJHwjmhRsCKYmEYot14HOTUDKNx8f7O2U9NBUMy49hgcRGzCQrUfedZyUqLG9JlA0neoINuS1hZH2bqG8PVJZb2G6So5Lm1y2TTDbklQ2Xy2+4laimpR2H6l7Eu1je94V4MB/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522554; c=relaxed/simple;
	bh=fE2SSmAQcEuI/8GVV1Jdph6vvY88GOLXGZ+bWEDyUbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wt3dX1DYElDrWN7eiXugPPTLHLX/ngXEtDEegYsbJ9UiqRWofiS1XuguK031g2M7Om7k+l+csBXK2YcD2JfRWiJ/exFH9aqyDDHbkdv5tvvIjwXMLq59t4DOhodyW6zOu6mmyyEvP4nnRrxcx+eGZic1CMl7F5dhssfUqg22U9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QldutMkt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QldutMkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57ECC4CEEB;
	Mon, 18 Aug 2025 13:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522554;
	bh=fE2SSmAQcEuI/8GVV1Jdph6vvY88GOLXGZ+bWEDyUbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QldutMkt0XhV5QscRCd+t45g90qe/1pX2DXOCnbCzN6fOP0COjX5Sb77W7twsmoXj
	 /yajbvwNN7QqFInT5OHm53WFdnl7PyAkg6EnyU3dG9pLdEPBsPPiuvjP79cw53nKzr
	 +nzvKq5bQ7S0lmh41YnVBqFIgnQcexr6qzFT3JOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 350/444] kconfig: gconf: avoid hardcoding model2 in on_treeview2_cursor_changed()
Date: Mon, 18 Aug 2025 14:46:16 +0200
Message-ID: <20250818124502.043704458@linuxfoundation.org>
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



