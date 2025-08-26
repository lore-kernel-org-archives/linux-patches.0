Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367633597C;
	Tue, 26 Aug 2025 13:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213267; cv=none; b=kuW9jDycVhrTc5SKUY9kAHIF04kHxKitrj3VKFQPPnuImwCCY64XkcO5WdQojr9J9ysp5lL20wXrMpy7HUK8P0BrCpa1OZGozAJOduORVSzPUpJZM6YT/iuoa8sXPLwNNznR4i3a8J4cXy2qpEBVk76EDXka49EROtWG2p9Tpg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213267; c=relaxed/simple;
	bh=qChEFNgmyyRiaZLQbWPHjPXIWksNMngI5y9WywfjHYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDTleCO1sogI4QabyNUSX8PlxpFbuNyOZ7tphd4RpntMESGvoDAY8G6Qhnj/am2WplXH7bJI4Wfz8encPjJrL5drLw1ogvH6mLDs+edVwuG1s4zz5V0dSGEe6r4GQUg91fmY+BPg6Whva0EclLb1DSbCHI0EnP6cfvvlupjXrRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RkhbY1ld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RkhbY1ld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA11FC4CEF1;
	Tue, 26 Aug 2025 13:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213267;
	bh=qChEFNgmyyRiaZLQbWPHjPXIWksNMngI5y9WywfjHYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RkhbY1ldjy2L8brFCKoJeDD5mzVLxd/1BfL9OG1xx8ZOweKg0QRKUQxqhKAbWblUC
	 tfgCjLOmp1U3Wkz1z0V7vdLFMRpEpeyRYHAEIF43eYw3kyh7SgzXL0cZBxl6PoJde3
	 21+gJZhngvY5GRrbfm48VIJG3XaA6MqdXKOg00iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 283/587] kconfig: gconf: fix potential memory leak in renderer_edited()
Date: Tue, 26 Aug 2025 13:07:12 +0200
Message-ID: <20250826111000.130895939@linuxfoundation.org>
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

[ Upstream commit f72ed4c6a375e52a3f4b75615e4a89d29d8acea7 ]

If gtk_tree_model_get_iter() fails, gtk_tree_path_free() is not called.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/gconf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index a9f78e167e2e..2b99d18e703d 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -780,7 +780,7 @@ static void renderer_edited(GtkCellRendererText * cell,
 	struct symbol *sym;
 
 	if (!gtk_tree_model_get_iter(model2, &iter, path))
-		return;
+		goto free;
 
 	gtk_tree_model_get(model2, &iter, COL_MENU, &menu, -1);
 	sym = menu->sym;
@@ -792,6 +792,7 @@ static void renderer_edited(GtkCellRendererText * cell,
 
 	update_tree(&rootmenu, NULL);
 
+free:
 	gtk_tree_path_free(path);
 }
 
-- 
2.39.5



