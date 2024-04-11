Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E326E657AE;
	Thu, 11 Apr 2024 10:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831583; cv=none; b=OFhsSL8YZcYHusQ2oVLCQ5CzVXjhmKDGK7YskuIrlIQS4i1cXMN1EeJhYE6lJabP3nbX6nO2fGdTelAypCj5quOF5XLTHbMNShMhSYj8WDfOOwbF5nAx/5G99f1Y5xXLxdIIoXlToqf6VOw5qIB2tAuGj3odpWS0xqwdJuFR958=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831583; c=relaxed/simple;
	bh=vFv24UePh+WOs7HBXqmlBz1SI2Ttdp0Y9TpXnybIkU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCKHE3onfpqXzCTkEDxAtWWM4yd1Kq5L/XUJoY8Dr3X3a7BgIsagAuHHpvH9U8N6y6eqUo6cS7aAEqLwEHAVQEosXLLV+M+q3YkAgS450IDrGPFqhTDVGiU08Vd8wIRALkV0fSp5t/cG/OeL1lRffXj4cgIcfs/EPsJUgNer8jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hjiyj6q1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hjiyj6q1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6904AC433C7;
	Thu, 11 Apr 2024 10:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831582;
	bh=vFv24UePh+WOs7HBXqmlBz1SI2Ttdp0Y9TpXnybIkU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hjiyj6q1G+SW00d8NTR/WEIkE5nrNsDv2V2uYqJy9/t6GU16xv24vwIxZH+ZpZT39
	 IkJChCbWyw+90dpoHxglMNjJAtvJnyDJ3BKDOTkAtKWtTF5ncUAZESxp+tB/fT8x1P
	 sirvXgXXtWBroxPKg1Pk3DP+4a8UrmY7NbI4oWGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Mladek <pmladek@suse.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/294] printk/console: Split out code that enables default console
Date: Thu, 11 Apr 2024 11:53:39 +0200
Message-ID: <20240411095437.327396352@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 17a310dcb6d96..632d6d5dcfa70 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2693,7 +2693,8 @@ early_param("keep_bootcon", keep_bootcon_setup);
  * Care need to be taken with consoles that are statically
  * enabled such as netconsole
  */
-static int try_enable_new_console(struct console *newcon, bool user_specified)
+static int try_enable_preferred_console(struct console *newcon,
+					bool user_specified)
 {
 	struct console_cmdline *c;
 	int i, err;
@@ -2741,6 +2742,23 @@ static int try_enable_new_console(struct console *newcon, bool user_specified)
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
@@ -2797,25 +2815,15 @@ void register_console(struct console *newcon)
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



