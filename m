Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E5C306D3F;
	Tue, 26 Aug 2025 14:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217913; cv=none; b=O1IR+SsEWq90tzouDpKIdAyBE13LCYLtL5XDJT3RRai0i+iNjhQQrysLQmDKq1sLIERzL5Z0I3xIMJbf6/3TIEEaoOQNPPcebRbl1tdKGreH6zPY6bGjBlvx/sioU2HFtEvB6449p9K12b7XCvB0i4Lc8CrNKcwpwyMWOpq4Exg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217913; c=relaxed/simple;
	bh=7VbbnCfHx/ebJ285bsf2oKz7Awvy2IC2wuCVFbCNl9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PH6Z5WnCznuGB2jXv45Cj2ZLC0lR0yEzsc/astMpm5CAiJWAbETPG68QYNvVeI749/vdqYCRRabXy34amPwm7b/TeYG2O6pbYbrk0E1jlkU4vjlehD9ejpxvh5JKA/XVaZBltgGV5gWMog9GLgQfD6+xGaSyaDVnU8yP95ces5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mezh5PyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mezh5PyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9581FC4CEF1;
	Tue, 26 Aug 2025 14:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217912;
	bh=7VbbnCfHx/ebJ285bsf2oKz7Awvy2IC2wuCVFbCNl9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mezh5PyZUqKVMQLzCqwBbP5Oqi4GAhcDBebFLrdxBYE3K+u+/yxJnGdcJlfQijAQC
	 y9TirWF4nco0oxpdGagVWoZ4sAP7uezEFCFwucLlPhES9DmsLmql1CbH+pu1H9Wjte
	 zrfedNgYY42XuK0lNfBlaIacFi1GGLJlOo1oQuZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shankari Anand <shankari.ak0208@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Nicolas Schier <n.schier@avm.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 322/523] kconfig: nconf: Ensure null termination where strncpy is used
Date: Tue, 26 Aug 2025 13:08:52 +0200
Message-ID: <20250826110932.408940094@linuxfoundation.org>
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
index af814b39b876..cdbd60a3ae16 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -581,6 +581,8 @@ static void item_add_str(const char *fmt, ...)
 		tmp_str,
 		sizeof(k_menu_items[index].str));
 
+	k_menu_items[index].str[sizeof(k_menu_items[index].str) - 1] = '\0';
+
 	free_item(curses_menu_items[index]);
 	curses_menu_items[index] = new_item(
 			k_menu_items[index].str,
diff --git a/scripts/kconfig/nconf.gui.c b/scripts/kconfig/nconf.gui.c
index 77f525a8617c..8b3e9bc893a7 100644
--- a/scripts/kconfig/nconf.gui.c
+++ b/scripts/kconfig/nconf.gui.c
@@ -398,6 +398,7 @@ int dialog_inputbox(WINDOW *main_window,
 	x = (columns-win_cols)/2;
 
 	strncpy(result, init, *result_len);
+	result[*result_len - 1] = '\0';
 
 	/* create the windows */
 	win = newwin(win_lines, win_cols, y, x);
-- 
2.39.5



