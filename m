Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C70223335;
	Tue, 26 Aug 2025 14:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219126; cv=none; b=PaCW/N9fTDTKFSQIm7Ft9edG7IJ2vNYPPXBub5uopUGeEHYojzGjIU/4m6IeaH47llnT9Uwfr3AtdJm32PJ1dd8/TVb+zv5OlnYU8vJc5m2cP+79nBkSK2RNZbH0m4x8+T/VkpfBB16AAalNa6mF086mlEpFDotj5mEc+OH5uyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219126; c=relaxed/simple;
	bh=8h6jLWjFY+e7MtWYfveXxkNzNy6b4WK8hRW2Lw0HDCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0QYhqyNqrSt5vvkdom/PcWv7fknxNPS6fpUSqLf1kKqxipDuZRZwJGpWTRd+SB9Ie42ysFHRnrksuiCMxfCx4CiEjaEHARK9fJ7qmb0ma3gOFgqFLrlmLTZj03I1WlvL4CYOH3UlNZw70Jah4PscrVFLyUc12xLBzLGitQ+daU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MeTK1ll0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MeTK1ll0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56526C113CF;
	Tue, 26 Aug 2025 14:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219125;
	bh=8h6jLWjFY+e7MtWYfveXxkNzNy6b4WK8hRW2Lw0HDCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MeTK1ll0f8F2CJ2KvK2J8jeqMGKxkjtXe5aHQr5ZCzt7GmQsLIBSSOkMbXAn9FP7v
	 +RoWrINWYB7wNYeXJ5vwo8Sbp6ufBQh/6hvW5nb2QAiAxPStsYzahZYhn9ZrzI6Llj
	 nVmesszPdiUXtnrLXaMmQLQwEO/XKfFJNgcDTEnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 263/403] kconfig: gconf: fix potential memory leak in renderer_edited()
Date: Tue, 26 Aug 2025 13:09:49 +0200
Message-ID: <20250826110914.078948736@linuxfoundation.org>
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

[ Upstream commit f72ed4c6a375e52a3f4b75615e4a89d29d8acea7 ]

If gtk_tree_model_get_iter() fails, gtk_tree_path_free() is not called.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/gconf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index bd1fdbd949cc..6eb71c75b765 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -786,7 +786,7 @@ static void renderer_edited(GtkCellRendererText * cell,
 	struct symbol *sym;
 
 	if (!gtk_tree_model_get_iter(model2, &iter, path))
-		return;
+		goto free;
 
 	gtk_tree_model_get(model2, &iter, COL_MENU, &menu, -1);
 	sym = menu->sym;
@@ -798,6 +798,7 @@ static void renderer_edited(GtkCellRendererText * cell,
 
 	update_tree(&rootmenu, NULL);
 
+free:
 	gtk_tree_path_free(path);
 }
 
-- 
2.39.5



