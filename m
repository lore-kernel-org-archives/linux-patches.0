Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B3413957E;
	Tue, 26 Aug 2025 13:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213248; cv=none; b=Su3pkiUH3VnOeEJoX57pN6o+Q9legMMlFQJsd/ekFGEiJCLC19ekpiTF7kYaafQnGHrcTPwXWbx/zpx2uGbKRgcmtmMMjd6zBEao5TmkGixx5bytm6xg2waxXip90PFmvDxrDRs1fUGntF+E9r3TJ5wEpZQ4rqOzBqa8kiX6Vss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213248; c=relaxed/simple;
	bh=zs7wjhdApDgAOLGlxKLCTSmEM1VKmzAmX8tZMwBWLkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBLMs5Q/PM12rTGoZdNYaWiOkBOSs/jvkp70KvBNKp9N1YxbnIIAliI3XfGRR58mfHZa4HetT3KHZa9jyz/erPqEb+YBG79VU4YfWymu5IN+T+BYmYzPK/8KQrFb5yp4fFIkECCqZ1frSIiShNl8Ww58me4gr49Ail7BbVZ0aFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MkMukoUi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MkMukoUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E01C4CEF1;
	Tue, 26 Aug 2025 13:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213248;
	bh=zs7wjhdApDgAOLGlxKLCTSmEM1VKmzAmX8tZMwBWLkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MkMukoUiSw6wdnGSW159SbuZCkyixPyHAyOiqHFMOaZYX20BOu/e22aTK7M0Maxg0
	 ETGq1gABRas+CJlgCZKfqR3bPWIGLCsPiEOeQWCh5vcVxXKRRGXG/LaTRMLNgrN+Iw
	 bPgBWsC58dD3b4iRlnOtwS3e17NUIp61rA7P+OFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shankari Anand <shankari.ak0208@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Nicolas Schier <n.schier@avm.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 276/587] kconfig: nconf: Ensure null termination where strncpy is used
Date: Tue, 26 Aug 2025 13:07:05 +0200
Message-ID: <20250826110959.948892993@linuxfoundation.org>
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
index 8cd72fe25974..7a17c94a1594 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -591,6 +591,8 @@ static void item_add_str(const char *fmt, ...)
 		tmp_str,
 		sizeof(k_menu_items[index].str));
 
+	k_menu_items[index].str[sizeof(k_menu_items[index].str) - 1] = '\0';
+
 	free_item(curses_menu_items[index]);
 	curses_menu_items[index] = new_item(
 			k_menu_items[index].str,
diff --git a/scripts/kconfig/nconf.gui.c b/scripts/kconfig/nconf.gui.c
index 25a7263ef3c8..5f13a0a7fb0b 100644
--- a/scripts/kconfig/nconf.gui.c
+++ b/scripts/kconfig/nconf.gui.c
@@ -349,6 +349,7 @@ int dialog_inputbox(WINDOW *main_window,
 	x = (columns-win_cols)/2;
 
 	strncpy(result, init, *result_len);
+	result[*result_len - 1] = '\0';
 
 	/* create the windows */
 	win = newwin(win_lines, win_cols, y, x);
-- 
2.39.5



