Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A60434DCFA;
	Tue, 26 Aug 2025 13:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216478; cv=none; b=Uv/8mFE9cNwoRB6edSuK4XrtkjBnNSgnhCmD7V7Dd12KulEqCdTyFoc9iEJrku+jHJWZEv8cIqpd0vWhxSImY0E4v2ZZbuTmRDhP+Pj1S/FixKGARBEq42oVLVIgRT7IYdumLiC1DEsyg/ny0qcf8WiUqltaC3n9/jmu0w9J/Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216478; c=relaxed/simple;
	bh=NvU7SrWJt0zVXCnfx3ayn5OG2ELPvrO44WbJvYrNst0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paT0pNpuS3bTVt28VzOsqRhV3iNx4gv8rVsieBehXEpsV0ZAhhcf4hW8CP1+HWMMBL02fqxdRLh0NRD2Fh/IffURT+AeIFnHBcQM4hxkR0ymX0qt9/2khCLHQ5EiRNb/3Gq3MUVfJ4hQeGOrsYUtnUFdxvcLJ/oa/s0KsyMwdVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANqHiBkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANqHiBkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958DDC4CEF1;
	Tue, 26 Aug 2025 13:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216475;
	bh=NvU7SrWJt0zVXCnfx3ayn5OG2ELPvrO44WbJvYrNst0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ANqHiBknjUgL7Ix7U+nJNFhS/uybkS15ZCOWdMosVMW/9o9uPxwXRZ74YCOc3OraS
	 N85VAbunzUFmmr47bzOC8cTLdocTZhXompZn3q8ritTDXSQMlH0B1U0VNmRnK52Yy4
	 AteypslWqa+jzSEtTMm+e59Gq7ZXn3OBqKEAXb0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 424/644] kconfig: gconf: avoid hardcoding model2 in on_treeview2_cursor_changed()
Date: Tue, 26 Aug 2025 13:08:35 +0200
Message-ID: <20250826110956.966466146@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



