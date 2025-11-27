Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6107832C301;
	Thu, 27 Nov 2025 14:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255398; cv=none; b=kJVT0PBnUyMirjKX+MC6RHW00pgUHku31NpB27hiKCJqyt7HEdUwbCo35d7J7EasPUzaUDK1G+12BBl7PVmVcctiQc3kCMYpALHT3fS+fAM1DT+w/ssYbOkAymlxMVGPJDQS2b7Rlm+mIgr+wMjh9+8o9oPtFHNzApYPOND6+OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255398; c=relaxed/simple;
	bh=zifeG1Cahg2ZQAPIg4HI81NcLceRzXVasFK0DDV6QAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E/FR+K1HI2jNWk87T3BKGOaLQB9a4rfVWUS5rB40nX5IVOfkSRRcsXFdBR1OrtMzIyRWu6Gu2PEHzAxXFHd0Dfb4kOUnbguYhaxWm+6+OYpKBUU+7IMmzN8T/ccyuozElfAGo4gX3VgYDV4gO37KAUThiac8jEooy+MtFV2wT2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s2DNn/ng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2DNn/ng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E4AC4CEF8;
	Thu, 27 Nov 2025 14:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255398;
	bh=zifeG1Cahg2ZQAPIg4HI81NcLceRzXVasFK0DDV6QAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2DNn/ngcgrvl4NuEDWtLnRQ26FKyUI6TNXz5z0YPsLgZkBkUVL3WBYtByEX1zVqM
	 LOUA16gBor4Ms223D+AFmy0kiR56cNxBdIi04eMNHc9KarxB0ri0zeEQvAQjN4iiU6
	 ETRdHvJU4u+BStRq034BxvKqFNK2/PHokdw3S1HU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jakub=20Hork=C3=BD?= <jakub.git@horky.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 091/112] kconfig/mconf: Initialize the default locale at startup
Date: Thu, 27 Nov 2025 15:46:33 +0100
Message-ID: <20251127144036.172388856@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



