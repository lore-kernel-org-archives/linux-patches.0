Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D53F1A76C1;
	Tue, 30 Jul 2024 17:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360563; cv=none; b=nvEcSM6QtXpckclHPD2/OID6fxiSCOfnPScr2NGR2IhpdKhr9eZ7N5sQCL1XXbuZcgp5PFD68yNNcPa7YFhiTnQIcZYoBTWS8wYYJE7nEZ8/mFnJLysnkyq4OpJufry3w2LnFXn7iaXInXFW/rSy9m6DSqYfHvszFmEdpvQLuWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360563; c=relaxed/simple;
	bh=Wm/T0kuJ2jCGQh3JBq/ZlAvyF29vbJPEnryLrWZfpWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U79gEtGkb9qgdnoN9RV4P18eS5hhjG6yPqib3KBaIhjDm/VuE82pGpvY4totTAJeLOzBkztf9WQz6BYwT0X0/2xHa5jVvW1OD1CrxXJ2AgExwlLQkXG7mKHZx66WFwCh2QQg4dqDq3paV58dt1lQytahBcGZGdOZWGwO+wzhm48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D9knMAtY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D9knMAtY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B676DC32782;
	Tue, 30 Jul 2024 17:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360563;
	bh=Wm/T0kuJ2jCGQh3JBq/ZlAvyF29vbJPEnryLrWZfpWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D9knMAtYVHnyKQZT+AlEHOHrvRTatBxj/ZpIS7+KTT9zt2nstnJNcRGH6cnx6SxSN
	 kw6UfECn7sbpOzMq5s+MZvYbiUFc4njbMIXHZX+8tSmlU2CD6xkgh6aD3i5DeJbFNV
	 b/daDRq34itKnFtoozOUFWJNRdaLAqpEakBk+kc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 738/809] kdb: address -Wformat-security warnings
Date: Tue, 30 Jul 2024 17:50:14 +0200
Message-ID: <20240730151754.097325425@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3131334d7a81c..7da3fa7beffd0 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -362,7 +362,7 @@ static char *kdb_read(char *buffer, size_t bufsize)
 			if (i >= dtab_count)
 				kdb_printf("...");
 			kdb_printf("\n");
-			kdb_printf(kdb_prompt_str);
+			kdb_printf("%s",  kdb_prompt_str);
 			kdb_printf("%s", buffer);
 			if (cp != lastchar)
 				kdb_position_cursor(kdb_prompt_str, buffer, cp);
@@ -453,7 +453,7 @@ char *kdb_getstr(char *buffer, size_t bufsize, const char *prompt)
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



