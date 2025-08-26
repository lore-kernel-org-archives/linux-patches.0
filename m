Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517E9342CA7;
	Tue, 26 Aug 2025 14:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217926; cv=none; b=LDV+qMryPxI3zv5W1lCFnIs10ntPExPNAlyLJpyAQuZHbaeloapS3BQIawNfi0xPLNu8uee2OcnUUFm0wR8B1yrgy47OoLwl9nyJWzPZaaz/FEeJSH1WOqQr1E3D/HqSSULsOw/PbzL6JGhYbM2Wc9aAmj/coBqnPMImqt20bkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217926; c=relaxed/simple;
	bh=vIrujHXVp5W9rGd4L0IeJv+yM7ttyH6ZX0B3+DIqud0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVa55ON9qtaR0BXqpQZmPdWmx1LAoZyMkL9D6PN9i+esV9ql96V0VDnTMz9nsi0bmsag5FMWZ9cxS+I0CEGKJixyvwf+ozl2VTpEwIokPnS92LkcP94BZ55yqP29Lazr//ZLLIyFXSjhbhiHXPz6F507hSdnaOSp9ggMLE9+3Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qhpsjG1i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qhpsjG1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA94EC4CEF1;
	Tue, 26 Aug 2025 14:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217926;
	bh=vIrujHXVp5W9rGd4L0IeJv+yM7ttyH6ZX0B3+DIqud0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qhpsjG1ijHXazC7jquNJpzy2i49YA0jhhJjucJlQ7Udj0Uz9JKF6twkJKXJhMaPLk
	 L21zXXNBENZZVx6d7nA7CqSLGAQEjkVnGHKqoEuc4ymqQl5K6GBm7VWLEWtoSIdk6A
	 zyJm2497vn53636wo419cP4SMFMEBYP8EBMg1S+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 327/523] kconfig: gconf: fix potential memory leak in renderer_edited()
Date: Tue, 26 Aug 2025 13:08:57 +0200
Message-ID: <20250826110932.541788425@linuxfoundation.org>
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

[ Upstream commit f72ed4c6a375e52a3f4b75615e4a89d29d8acea7 ]

If gtk_tree_model_get_iter() fails, gtk_tree_path_free() is not called.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/gconf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index 50c1340cf636..e092bb686f45 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -787,7 +787,7 @@ static void renderer_edited(GtkCellRendererText * cell,
 	struct symbol *sym;
 
 	if (!gtk_tree_model_get_iter(model2, &iter, path))
-		return;
+		goto free;
 
 	gtk_tree_model_get(model2, &iter, COL_MENU, &menu, -1);
 	sym = menu->sym;
@@ -799,6 +799,7 @@ static void renderer_edited(GtkCellRendererText * cell,
 
 	update_tree(&rootmenu, NULL);
 
+free:
 	gtk_tree_path_free(path);
 }
 
-- 
2.39.5



