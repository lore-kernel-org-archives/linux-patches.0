Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F292E28135D;
	Thu, 27 Nov 2025 15:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255901; cv=none; b=Q//olwhOF8w0V8TrWC3bi/sp08BQhA0gtVtrdkDr9s4DxnIXcqDMiuEIqZQvUVjbdAwKYV0tdJv9BbRHI8Fb3P/i9XDDL7pXinVliUThBcK16OiK8UOjOibDCywCv73GKCCagY2d7Bu12ihHqTnrz4/D91m4NP1vIryKmGalAe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255901; c=relaxed/simple;
	bh=PZdEhDkEmBVQvOug0tJ4K9pqGc2dLWoaF8x+lvgFi+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kt+kTtO0U/4MbztARUKr/Vz+kzK53pIXsiTdbUbpasDzDsbjVUdgjjPciZE1MvATBQsTfbRCW3gx+Ax6AwtFCxchn5wqmb/PY5Mk4PVsTW6VzVT2zMPXhUIJn+HDY4F8ovyRmdiM+w2dB2FDgkI+bOARl8rBcEZyd8TmNWMKsr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wp7zADNf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wp7zADNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCF7C4CEF8;
	Thu, 27 Nov 2025 15:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255900;
	bh=PZdEhDkEmBVQvOug0tJ4K9pqGc2dLWoaF8x+lvgFi+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wp7zADNf93SHxL+GI2+dKIDp4EQnfL0xvztjElUMDNHUDgAqa5fZdQXbnwAlziJyP
	 IdKuOks3AWC5yM2ESLEeNxJIvsKaYVXkdAbJ8pbI8EkFaojzljnlaAhPynGMhWaPHT
	 XdA099AAQ83mVZEYAtZIOBSvpwZ9kGw7PlgNWbqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jakub=20Hork=C3=BD?= <jakub.git@horky.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 153/175] kconfig/nconf: Initialize the default locale at startup
Date: Thu, 27 Nov 2025 15:46:46 +0100
Message-ID: <20251127144048.540772543@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Horký <jakub.git@horky.net>

[ Upstream commit 43c2931a95e6b295bfe9e3b90dbe0f7596933e91 ]

Fix bug where make nconfig doesn't initialize the default locale, which
causes ncurses menu borders to be displayed incorrectly (lqqqqk) in
UTF-8 terminals that don't support VT100 ACS by default, such as PuTTY.

Signed-off-by: Jakub Horký <jakub.git@horky.net>
Link: https://patch.msgid.link/20251014144405.3975275-2-jakub.git@horky.net
[nathan: Alphabetize locale.h include]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/nconf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index ae1fe5f603270..521700ed71524 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -7,6 +7,7 @@
 #ifndef _GNU_SOURCE
 #define _GNU_SOURCE
 #endif
+#include <locale.h>
 #include <string.h>
 #include <strings.h>
 #include <stdlib.h>
@@ -1478,6 +1479,8 @@ int main(int ac, char **av)
 	int lines, columns;
 	char *mode;
 
+	setlocale(LC_ALL, "");
+
 	if (ac > 1 && strcmp(av[1], "-s") == 0) {
 		/* Silence conf_read() until the real callback is set up */
 		conf_set_message_callback(NULL);
-- 
2.51.0



