Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4966CDA8;
	Mon,  8 Apr 2024 13:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581504; cv=none; b=FkSrpyCiv9d/5JwTSZVkqvuZSyxchvWjJpQsHIVxsXl9mC6wmCFaAcV7zARgp7TpHa7gUGfKzPw5n5A3hT5l9r+tfd0eUGiZ0GlLhgjKz2HflLjAfSdHIuuoO6FAoWtBXV1t329YGvNyoTHd94icMbiA4vS6bsd7hbnZ28Agzxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581504; c=relaxed/simple;
	bh=UgIbFtA6XRmY5DObalqbB8UnGYfbTvufJ+2jmUY/Yvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSxMvONvLgtQlOdS8ORA7dSGaLEM5xWGr6gie3XLrlyWHEqj3/ps3f/FhNmhmgYCRXDnMzZPuCaIIWnHhMdeHSzsPDtbTFAftDfteI0p/ZRyVasyCofB+Q3m/tQnQM0hZFmCX7PnnpA1x2wbNCNXte/HS9DgBbv0vBF2MC/X1QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mgcU349P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mgcU349P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971CBC433C7;
	Mon,  8 Apr 2024 13:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581504;
	bh=UgIbFtA6XRmY5DObalqbB8UnGYfbTvufJ+2jmUY/Yvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mgcU349P3TGmK3oPEGpvYw4gQtcMs6C0sZys0IL1Yc721tuYx9NxwWa5+PfH6olZo
	 0XgR6jdmcNJondq4uHV0dtVGhbGXmj19akTHSg59+nzIwCu//A4fKu6TsUZVJNSeQy
	 Y6ClC6ewE2II0I4MmaEM2iAQggAFO0mWqItPJBds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Mladek <pmladek@suse.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/690] printk/console: Split out code that enables default console
Date: Mon,  8 Apr 2024 14:48:43 +0200
Message-ID: <20240408125401.585119811@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Mladek <pmladek@suse.com>

[ Upstream commit ed758b30d541e9bf713cd58612a4414e57dc6d73 ]

Put the code enabling a console by default into a separate function
called try_enable_default_console().

Rename try_enable_new_console() to try_enable_preferred_console() to
make the purpose of the different variants more clear.

It is a code refactoring without any functional change.

Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Link: https://lore.kernel.org/r/20211122132649.12737-2-pmladek@suse.com
Stable-dep-of: 801410b26a0e ("serial: Lock console when calling into driver before registration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 8b110b245d92c..4bef2963284af 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2888,7 +2888,8 @@ early_param("keep_bootcon", keep_bootcon_setup);
  * Care need to be taken with consoles that are statically
  * enabled such as netconsole
  */
-static int try_enable_new_console(struct console *newcon, bool user_specified)
+static int try_enable_preferred_console(struct console *newcon,
+					bool user_specified)
 {
 	struct console_cmdline *c;
 	int i, err;
@@ -2936,6 +2937,23 @@ static int try_enable_new_console(struct console *newcon, bool user_specified)
 	return -ENOENT;
 }
 
+/* Try to enable the console unconditionally */
+static void try_enable_default_console(struct console *newcon)
+{
+	if (newcon->index < 0)
+		newcon->index = 0;
+
+	if (newcon->setup && newcon->setup(newcon, NULL) != 0)
+		return;
+
+	newcon->flags |= CON_ENABLED;
+
+	if (newcon->device) {
+		newcon->flags |= CON_CONSDEV;
+		has_preferred_console = true;
+	}
+}
+
 /*
  * The console driver calls this routine during kernel initialization
  * to register the console printing procedure with printk() and to
@@ -2991,25 +3009,15 @@ void register_console(struct console *newcon)
 	 *	didn't select a console we take the first one
 	 *	that registers here.
 	 */
-	if (!has_preferred_console) {
-		if (newcon->index < 0)
-			newcon->index = 0;
-		if (newcon->setup == NULL ||
-		    newcon->setup(newcon, NULL) == 0) {
-			newcon->flags |= CON_ENABLED;
-			if (newcon->device) {
-				newcon->flags |= CON_CONSDEV;
-				has_preferred_console = true;
-			}
-		}
-	}
+	if (!has_preferred_console)
+		try_enable_default_console(newcon);
 
 	/* See if this console matches one we selected on the command line */
-	err = try_enable_new_console(newcon, true);
+	err = try_enable_preferred_console(newcon, true);
 
 	/* If not, try to match against the platform default(s) */
 	if (err == -ENOENT)
-		err = try_enable_new_console(newcon, false);
+		err = try_enable_preferred_console(newcon, false);
 
 	/* printk() messages are not printed to the Braille console. */
 	if (err || newcon->flags & CON_BRL)
-- 
2.43.0



