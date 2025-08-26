Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53872258A;
	Tue, 26 Aug 2025 13:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216460; cv=none; b=lrO04R9EvGGaoP/S1B8mUizIUW95F6BximWdNdyNzNYD3pihwgry0lWJg9rZuRjgsjDEdHRLYxwuGFNf+e3E/x8UgL55q9+6y00buVaqsGSWjvoGLoeIwvBVR09rVGbH6rxD5eUbyjb2ccKq0iGtspUygVAmZ/YAwj2p6EOddQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216460; c=relaxed/simple;
	bh=CzBS4VRE3T9hPKxrLJmKWb/4/b8K2uKK+A9z1p1k//E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDwLaXNwTsBdWEvELdYEdV4w+Bqzv8KYp/sd7+MQIIO4i9JVQG2uDilC77ZdW6KLlme9/C9b0f2HDYzSKVaCXKKMmOsbKzqOqzTHA2nFhXRDMtB63azcYSnJCotAqPjp7JQ53pEXugyLIBChWPhe60t9BdsKyichU75e4iF8JCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KrL2KNDA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KrL2KNDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8416C4CEF1;
	Tue, 26 Aug 2025 13:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216460;
	bh=CzBS4VRE3T9hPKxrLJmKWb/4/b8K2uKK+A9z1p1k//E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KrL2KNDA6crW28Wxpvj71iu/cvYbLRTrp65/452d7sfcnepBSq8RHlJKpxp1CUhrl
	 S7IbbkGkwNTLFJq84cPLWXXIMYX+a6NQkuyMi4PrFaGbLYC8tcNXGBSCkOQNnVsVOC
	 M29hF8IzmTwstS2vIIz/Wx+mV4q/NaDCVfZxSxr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shankari Anand <shankari.ak0208@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Nicolas Schier <n.schier@avm.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 419/644] kconfig: nconf: Ensure null termination where strncpy is used
Date: Tue, 26 Aug 2025 13:08:30 +0200
Message-ID: <20250826110956.840780036@linuxfoundation.org>
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
index 7b371bd7fb36..8b166ccb0447 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -585,6 +585,8 @@ static void item_add_str(const char *fmt, ...)
 		tmp_str,
 		sizeof(k_menu_items[index].str));
 
+	k_menu_items[index].str[sizeof(k_menu_items[index].str) - 1] = '\0';
+
 	free_item(curses_menu_items[index]);
 	curses_menu_items[index] = new_item(
 			k_menu_items[index].str,
diff --git a/scripts/kconfig/nconf.gui.c b/scripts/kconfig/nconf.gui.c
index 9aedf40f1dc0..da06ea2afe08 100644
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



