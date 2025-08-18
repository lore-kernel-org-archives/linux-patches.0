Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F9C335BA0;
	Mon, 18 Aug 2025 13:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524251; cv=none; b=coxvFdE5cD0ikoBhIEUvWzVS4WR97FW5z7hqFxug4Mb2qKHA0EhW7z+9E2s5d5ujUrr5GzDA1eJ1L4QH0UhJ/4ckqUjyOxOTyBySozvnLA6VpXbz3hfP6r43nFE7rl++iTIoJap+IrDk1MLv8D50v57N2drIiVRmfg+KCVF8rO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524251; c=relaxed/simple;
	bh=FrQZMWUiWjsAiyl65j6AZR/zjwtMHFBoqEy1yo3eox8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bino1NFTHUzOk9U5SMV4X2xujuUe4BQcsL85ea1VW4l6WOeFzSJsgKBad2Ke0WmumhGIG96KTtE3bbpT94BM1lzDe5QNzXerUiLU/oQAe/qdamoh7fGPLwJ1q4jYk6QxlhUW0mv/iBu4RvlebNRC+ePB0s6lnH1+QCJmvI+SqAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YfH6EDSM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfH6EDSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99967C116C6;
	Mon, 18 Aug 2025 13:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524251;
	bh=FrQZMWUiWjsAiyl65j6AZR/zjwtMHFBoqEy1yo3eox8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YfH6EDSMWCbflnJalSgIINaWhgZhcfoF9wNXCklGTcrKqa5IQMY40sCoIoeBHWXnn
	 qGl6z6qJ793WD3c3v3QxCNiLLTf1EsnL3Xpn+T4L65Bzqs/ZCVDDmPz95m8DpFkx7s
	 Aplq//ZGyNIaX8i2EkQQs//9e5IGEmmXtt1G3e1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 414/515] kconfig: gconf: fix potential memory leak in renderer_edited()
Date: Mon, 18 Aug 2025 14:46:40 +0200
Message-ID: <20250818124514.355389442@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



