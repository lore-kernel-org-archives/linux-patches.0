Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3777E32A3C0;
	Mon, 18 Aug 2025 14:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526159; cv=none; b=LOi29jo8F4XsdMrDMRfkOeWhcsz+56M/hrgt/JjfQS5olecGeW8p2UDcsHVpAvbOaOq2hXl5OhI1PuKLvVaJkRC4BfXbndPKphdIUSUzrK+m2EfuyY9f1TwsoyxzX6eFWHtogLvaoXuabvGUWDInWJoueKHQyt0x3ft6BpIhuj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526159; c=relaxed/simple;
	bh=coR/dOjtnF4+Q4fkL5hCdap4bTFIWmcxbOsVInGp3bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEr/0gpXnH5PrnDL2hQTu4H7CuALLu/X5ps41dNAxgEB4LUHybh5wwPo2HccXOhbN5+5KVsvr7Nl66WUitPy8gxGXxgeukqrEbXxM16lxKClvuwT7jcgXQ4ZBuACURQWtOSEx55gWCV6M2IVNFXwpbEsYIVdtcwPSxPserjLV9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IVWtv+bb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVWtv+bb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5250C4CEEB;
	Mon, 18 Aug 2025 14:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526159;
	bh=coR/dOjtnF4+Q4fkL5hCdap4bTFIWmcxbOsVInGp3bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IVWtv+bbCjShG2g4wIHvtXmc84r1ALly1nOcaNhsJCIR2abGevuh43Bmlj/hTIdWD
	 iSuV2Xlf+9fLVz17yYg/yol9trFDHzW/5KGNsb9/zKCzTJ+djjo+3mV42NR7UgwVAK
	 CF2IRONOUAka7/abJKJqzF+sJt5MON5TDeNsh4lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 448/570] kconfig: gconf: fix potential memory leak in renderer_edited()
Date: Mon, 18 Aug 2025 14:47:15 +0200
Message-ID: <20250818124523.073759505@linuxfoundation.org>
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

[ Upstream commit f72ed4c6a375e52a3f4b75615e4a89d29d8acea7 ]

If gtk_tree_model_get_iter() fails, gtk_tree_path_free() is not called.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/gconf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index abe4cfe66b14..0caf0ced13df 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -748,7 +748,7 @@ static void renderer_edited(GtkCellRendererText * cell,
 	struct symbol *sym;
 
 	if (!gtk_tree_model_get_iter(model2, &iter, path))
-		return;
+		goto free;
 
 	gtk_tree_model_get(model2, &iter, COL_MENU, &menu, -1);
 	sym = menu->sym;
@@ -760,6 +760,7 @@ static void renderer_edited(GtkCellRendererText * cell,
 
 	update_tree(&rootmenu, NULL);
 
+free:
 	gtk_tree_path_free(path);
 }
 
-- 
2.39.5



