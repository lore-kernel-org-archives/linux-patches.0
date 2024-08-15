Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC0B7DA78;
	Thu, 15 Aug 2024 13:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728746; cv=none; b=p0zu6Ve478YgMH6idM+84+AYjN7poXOxpvkINqP24yRhpMEiD0YmR2Mi2l5numG8xxgdxBzCIbbhp5zoTLmD4x3tD8pyl7S4rLb650xKPvUZKZiyyny/lyrgUo2Jt6i3zQmwsS4PyrOMf4i7vDzsQrduXKiP6hFIRgc5+uvXftE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728746; c=relaxed/simple;
	bh=dHNGL5nricywmxtMwLXvT71yviANLvwR9qyyePmynCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQVPyVSBsFNBeQQLEiAqn7KTb5hppcBcwB/piCIA2D5zxDG2gYsnF9Sk+VJiOg1c7m3fFxCHIP2MgSq6ph4N7+LDvQbLrrQwJq8x+I88X84qDteIXxcLRgGm8UhsuJMGLfJHlyq1rGsJ9chUxG0BHaN/ylFvRInXU3QlmETxyrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AAj66RHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AAj66RHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7F9C32786;
	Thu, 15 Aug 2024 13:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728746;
	bh=dHNGL5nricywmxtMwLXvT71yviANLvwR9qyyePmynCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AAj66RHb1l8Qp+RcBL4Wx7+PlIJLClFuWV7qxRuAFLRh8zSADcyU0i+o6ePAiBl4I
	 DEH0p+TDyISNxvdCLHvv5iTyn9K1XAxsH31wjf28l/yV0298p3vIlO/ZQInx7+jHio
	 fejkwqxPJGIwiOeIcxKQoDuwaj0sChppRzGGBilI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 096/196] kdb: address -Wformat-security warnings
Date: Thu, 15 Aug 2024 15:23:33 +0200
Message-ID: <20240815131855.755165805@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 70867efacf4370b6c7cdfc7a5b11300e9ef7de64 ]

When -Wformat-security is not disabled, using a string pointer
as a format causes a warning:

kernel/debug/kdb/kdb_io.c: In function 'kdb_read':
kernel/debug/kdb/kdb_io.c:365:36: error: format not a string literal and no format arguments [-Werror=format-security]
  365 |                         kdb_printf(kdb_prompt_str);
      |                                    ^~~~~~~~~~~~~~
kernel/debug/kdb/kdb_io.c: In function 'kdb_getstr':
kernel/debug/kdb/kdb_io.c:456:20: error: format not a string literal and no format arguments [-Werror=format-security]
  456 |         kdb_printf(kdb_prompt_str);
      |                    ^~~~~~~~~~~~~~

Use an explcit "%s" format instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 5d5314d6795f ("kdb: core for kgdb back end (1 of 2)")
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20240528121154.3662553-1-arnd@kernel.org
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/kdb/kdb_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 5358e8a8b6f11..9ce4e52532b77 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -368,7 +368,7 @@ static char *kdb_read(char *buffer, size_t bufsize)
 			if (i >= dtab_count)
 				kdb_printf("...");
 			kdb_printf("\n");
-			kdb_printf(kdb_prompt_str);
+			kdb_printf("%s",  kdb_prompt_str);
 			kdb_printf("%s", buffer);
 			if (cp != lastchar)
 				kdb_position_cursor(kdb_prompt_str, buffer, cp);
@@ -460,7 +460,7 @@ char *kdb_getstr(char *buffer, size_t bufsize, const char *prompt)
 {
 	if (prompt && kdb_prompt_str != prompt)
 		strscpy(kdb_prompt_str, prompt, CMD_BUFLEN);
-	kdb_printf(kdb_prompt_str);
+	kdb_printf("%s", kdb_prompt_str);
 	kdb_nextline = 1;	/* Prompt and input resets line number */
 	return kdb_read(buffer, bufsize);
 }
-- 
2.43.0



