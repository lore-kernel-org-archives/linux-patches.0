Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6399219DFA6;
	Thu, 15 Aug 2024 13:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729962; cv=none; b=Mj6qjKo90U2bILgzyHcmGnSqHVEIhGv3D7NwXql71zNaEEyWauoO2lUTHXX7PZTQ7lZb6aoKAcEMjAF+rTJpO7OcdoTQsxDxkJvaL478CEwgIbUyazsLXEQMpG9XXGL9820VHdM+83WRSq2IYKz6nt6Zurn9BSunXgI4deBb1z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729962; c=relaxed/simple;
	bh=PjXtw0Yld7Vi3d3jbYoYc5usFdu+ruGIYxs246yz2EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDXmt/jLRfHMzQBjOEYJB2VwiovL/ZdQ7+eMbNWrOI8v+VrBbl7VnmNZmm4x+01noMjilRsUdnw4UD7eN8L7QopgFJOY//0mENpmYLJHSNLEewyo7FfFggoSo7H4IXBRwxZdpOzBKlNivnnXVeJlLKqwq/vlP12twE/nywBb61E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CmLkpgo3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CmLkpgo3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50761C4AF0A;
	Thu, 15 Aug 2024 13:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729961;
	bh=PjXtw0Yld7Vi3d3jbYoYc5usFdu+ruGIYxs246yz2EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CmLkpgo3O9ygO104PJ2eG9mYaz8ckz5gwatcva85RwxmAykR7Udtbxr+YbQPK/0ly
	 DSZSaTSICqgfzOD63TVkNIUJQxLbLQWTlRUg4i3NE45Yn6c4EtuSzKzQD1vVMw+Wkx
	 +HIulI6Q7TQpm6kTxiqLQuOiR+6UqhSrMOBDKVog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 260/484] kdb: address -Wformat-security warnings
Date: Thu, 15 Aug 2024 15:21:58 +0200
Message-ID: <20240815131951.445181282@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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
index a3b4b55d2e2e1..a4256e558a701 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -358,7 +358,7 @@ static char *kdb_read(char *buffer, size_t bufsize)
 			if (i >= dtab_count)
 				kdb_printf("...");
 			kdb_printf("\n");
-			kdb_printf(kdb_prompt_str);
+			kdb_printf("%s",  kdb_prompt_str);
 			kdb_printf("%s", buffer);
 			if (cp != lastchar)
 				kdb_position_cursor(kdb_prompt_str, buffer, cp);
@@ -450,7 +450,7 @@ char *kdb_getstr(char *buffer, size_t bufsize, const char *prompt)
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



