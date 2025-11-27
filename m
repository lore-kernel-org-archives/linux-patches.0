Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98F328135D;
	Thu, 27 Nov 2025 15:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255897; cv=none; b=pfQcqXuDjHBELEpqA6gXtS97FcDhRCBf8r+VYgSZWZ5b0SYz4TvJ2n4sNB22ihXlSr08ZfKaqJkXIzFLE5xhKeyAcDozn4VlyEAialErUinXI1qh7O5WA4wDGPeiQNm1nV2DEttbj5SnQR0vOXY7SwyD7V0UpLhrhYOjiGrEiDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255897; c=relaxed/simple;
	bh=aGdT0x7sq2JZMZNiWlXgbPpfE/0vbfo/p6yDXTSu60o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ffljsqB/C6U/9fWEmzP8fL2oOMtMNSjiUYjXRTrbHYkOqWCUNUjSqfSD8/BRtHSW3wfAu5NxV/KSAr6NzlGLpm821JN/fGbfFjlqOQ+IGrl5cw16D3LwxBCentdVJQZKNPxFBe4LPOm2WoNa8TIa3xQ5hmHEe2eqr+lq5IYpCVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYnBEf2z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYnBEf2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63989C4CEF8;
	Thu, 27 Nov 2025 15:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255897;
	bh=aGdT0x7sq2JZMZNiWlXgbPpfE/0vbfo/p6yDXTSu60o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYnBEf2zOoLY7Uqu3t9mIYDMUNMuqHYzMi7APQMDbWStokOCjqysOFCdxxBpNRl75
	 FVNIGd3HxEMOdFcQPPb0/4gWpgIOb0NZK3JBmXgHMHXImq3IsUEvbbwa28WXV4UR9A
	 4WHRcE/Oy51wF7ZJmyqpfRdvjfrNoDbRO1aSkO0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jakub=20Hork=C3=BD?= <jakub.git@horky.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 152/175] kconfig/mconf: Initialize the default locale at startup
Date: Thu, 27 Nov 2025 15:46:45 +0100
Message-ID: <20251127144048.504344445@linuxfoundation.org>
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

[ Upstream commit 3927c4a1084c48ef97f11281a0a43ecb2cb4d6f1 ]

Fix bug where make menuconfig doesn't initialize the default locale, which
causes ncurses menu borders to be displayed incorrectly (lqqqqk) in
UTF-8 terminals that don't support VT100 ACS by default, such as PuTTY.

Signed-off-by: Jakub Horký <jakub.git@horky.net>
Link: https://patch.msgid.link/20251014154933.3990990-1-jakub.git@horky.net
[nathan: Alphabetize locale.h include]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/mconf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 84ea9215c0a7e..b8b7bba84a651 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -12,6 +12,7 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <limits.h>
+#include <locale.h>
 #include <stdarg.h>
 #include <stdlib.h>
 #include <string.h>
@@ -931,6 +932,8 @@ int main(int ac, char **av)
 
 	signal(SIGINT, sig_handler);
 
+	setlocale(LC_ALL, "");
+
 	if (ac > 1 && strcmp(av[1], "-s") == 0) {
 		silent = 1;
 		/* Silence conf_read() until the real callback is set up */
-- 
2.51.0



