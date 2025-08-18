Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC72322754;
	Mon, 18 Aug 2025 13:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524226; cv=none; b=AmwJo4NWN4KO87txJB4Wbs6eIoVpN6zKEuJnbIU4YJs5TcMVp+0f62YPQ+SrxGpvXedsOl26SQxoq+XfGzzUvfLVj/WwQllZcDf1a2AJMkosFWwXOkbdp8ni3Po48jAIb+J+k0SGvY4aVgWtf3KCUVsJMLQzXmXjkCmYxzz6LSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524226; c=relaxed/simple;
	bh=h502uA5glZLFnWJ8UTnyyi7hwvEurRcNuCEmmmayIjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdfhnfacS8EI59ap2ynwJg8c90WzHr0Ejyxoa2d8bi6jB5+TvIqnGpdrwTLu6+H/BKVcp8Fv3rbrjnxzxsxHG+5uzAY6cBPi+Ji2tC51DCOK6feFC/ePBPt2NX9ePuaVz8QV/6dWojJkFPfRzHU4X2Zabaafoax7KN0z5MqG69I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ny3C3XYV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ny3C3XYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CD5C4CEEB;
	Mon, 18 Aug 2025 13:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524226;
	bh=h502uA5glZLFnWJ8UTnyyi7hwvEurRcNuCEmmmayIjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ny3C3XYVIPmbKma11xNUr23bEr0MgiIfV9Q2y4CTzXgudtN3xqEozfA9F//nbsCTI
	 TAS0cWES5mlnR2gkZAD++VyLJcIlhmxUc55URI52zKhpHHJaP7l4G3d8+0LUiSN1kJ
	 L0eZ54bQwSZIy/jQN8W3dLAdqa/3o6GRiI7gcRi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shankari Anand <shankari.ak0208@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Nicolas Schier <n.schier@avm.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 407/515] kconfig: nconf: Ensure null termination where strncpy is used
Date: Mon, 18 Aug 2025 14:46:33 +0200
Message-ID: <20250818124514.083254535@linuxfoundation.org>
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

From: Shankari Anand <shankari.ak0208@gmail.com>

[ Upstream commit f468992936894c9ce3b1659cf38c230d33b77a16 ]

strncpy() does not guarantee null-termination if the source string is
longer than the destination buffer.

Ensure the buffer is explicitly null-terminated to prevent potential
string overflows or undefined behavior.

Signed-off-by: Shankari Anand <shankari.ak0208@gmail.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Nicolas Schier <n.schier@avm.de>
Acked-by: Nicolas Schier <n.schier@avm.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/nconf.c     | 2 ++
 scripts/kconfig/nconf.gui.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index c0b2dabf6c89..ae1fe5f60327 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -593,6 +593,8 @@ static void item_add_str(const char *fmt, ...)
 		tmp_str,
 		sizeof(k_menu_items[index].str));
 
+	k_menu_items[index].str[sizeof(k_menu_items[index].str) - 1] = '\0';
+
 	free_item(curses_menu_items[index]);
 	curses_menu_items[index] = new_item(
 			k_menu_items[index].str,
diff --git a/scripts/kconfig/nconf.gui.c b/scripts/kconfig/nconf.gui.c
index 4bfdf8ac2a9a..7206437e784a 100644
--- a/scripts/kconfig/nconf.gui.c
+++ b/scripts/kconfig/nconf.gui.c
@@ -359,6 +359,7 @@ int dialog_inputbox(WINDOW *main_window,
 	x = (columns-win_cols)/2;
 
 	strncpy(result, init, *result_len);
+	result[*result_len - 1] = '\0';
 
 	/* create the windows */
 	win = newwin(win_lines, win_cols, y, x);
-- 
2.39.5



