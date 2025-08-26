Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E98B196C7C;
	Tue, 26 Aug 2025 13:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214673; cv=none; b=jtgXq83tTJ7FZNK4H+DtqKR+3DxYdHJ5MTOm0O3SmvU+3FlpAOmiLlH95MJQzfoUXE8u6/8B6cw8RrVR6r1SOQtvh7QCWxmxtq5ygAtUxI3SBe6g3t6histkvOUCpDMV2UEymIu/FfERc9HQ3eC0ZnTbhdvMsuE467rXRvgdfSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214673; c=relaxed/simple;
	bh=izvSYM7MB/GBKFHcRvzlAdYEsQ+9mf+e9O+UmzZhRU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHwsnr5LvLyQz/A24WDbHTeULK92d7duaPtgybD3w71jWZY7M6t9xTLSdp846bU0Iw+W63X3BmSumd6ItZu1jEu80BK/YeuYOBeQFiD2pPyW+vui+wdFmGyrIAgXOS1YKDOUjuunjSUT8Hz2xm3hMmmNjORrSoWvmCM8fW8rg1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rg5Np2og; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rg5Np2og"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAABC4CEF1;
	Tue, 26 Aug 2025 13:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214672;
	bh=izvSYM7MB/GBKFHcRvzlAdYEsQ+9mf+e9O+UmzZhRU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rg5Np2og73Xy3oElM8yPGoNurRXEpkw+bbLC4BIateWfuRgxi8XBs3VaDLPgWwiHJ
	 N7nmrRWsIWlE1D6uH4VT53D1zLa3LYhLcNkS6Mocn3qinkP0Sxa7P5zmaDb+3k2vWX
	 pBj1HdKh9TJ46LI8UyigbzWJaa15d0CEZ+wUYBEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 227/482] kconfig: gconf: fix potential memory leak in renderer_edited()
Date: Tue, 26 Aug 2025 13:08:00 +0200
Message-ID: <20250826110936.384181573@linuxfoundation.org>
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

[ Upstream commit f72ed4c6a375e52a3f4b75615e4a89d29d8acea7 ]

If gtk_tree_model_get_iter() fails, gtk_tree_path_free() is not called.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/gconf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index 87f8a4db5bc6..3c726ead8f7e 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -783,7 +783,7 @@ static void renderer_edited(GtkCellRendererText * cell,
 	struct symbol *sym;
 
 	if (!gtk_tree_model_get_iter(model2, &iter, path))
-		return;
+		goto free;
 
 	gtk_tree_model_get(model2, &iter, COL_MENU, &menu, -1);
 	sym = menu->sym;
@@ -795,6 +795,7 @@ static void renderer_edited(GtkCellRendererText * cell,
 
 	update_tree(&rootmenu, NULL);
 
+free:
 	gtk_tree_path_free(path);
 }
 
-- 
2.39.5



