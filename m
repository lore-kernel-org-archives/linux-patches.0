Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C186316184;
	Wed,  3 Dec 2025 15:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776604; cv=none; b=TR4Rc+cz0lmS6+MVGVafbwHgS/mcrxIR9j4mhYyE4ZuyUa9E0M1p2gzCNVAwMauRTULwAbm6c7bE88xP67vYm3UvTuIJUptOimg+KWFh+/grNe6T59vFudyrH+kXchzo6wP9/IVlxGK1j0kmKAW8Ichr2w6BF2BHGG5lAyQHATY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776604; c=relaxed/simple;
	bh=Ikh25/HdJSaoiPXWDVrKrSkrR0NmabvMREZWYI5ZYAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vEuXKx+xSi3NqydnUP5RLfuvj9ujeKtSWs/94qk09jTCFbhi/71Uy4ugk9en92RGZmoVopHp1bRxr8lVa30b59XA+3Jl8aZ63nAdC6qV9OjDgLKEs1ZKQOuSS28HD9s21eylzdkLmTYHDlNl5iBNxrVYGRhc2qgqqxpE45ty29Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAoIvDqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAoIvDqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC7EC4CEF5;
	Wed,  3 Dec 2025 15:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776603;
	bh=Ikh25/HdJSaoiPXWDVrKrSkrR0NmabvMREZWYI5ZYAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wAoIvDqF/XiutCGOD1+szSGl7gAFPJciDlFPUHua9snczfQUvTOTMnDyrkIjssLg+
	 F10GdvUYqiRj2PrvD0YrxPxrAvtdorFRDv1aaSitmofa0VwRndP4I/meRQw4hrvqMm
	 aPOSqf6rZzkNYNEaVcKYCDzEPWNfzCevn6C3hmew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jakub=20Hork=C3=BD?= <jakub.git@horky.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 232/300] kconfig/mconf: Initialize the default locale at startup
Date: Wed,  3 Dec 2025 16:27:16 +0100
Message-ID: <20251203152409.221844265@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4063dbc1b9270..a6d24c63c98c2 100644
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
@@ -1008,6 +1009,8 @@ int main(int ac, char **av)
 
 	signal(SIGINT, sig_handler);
 
+	setlocale(LC_ALL, "");
+
 	if (ac > 1 && strcmp(av[1], "-s") == 0) {
 		silent = 1;
 		/* Silence conf_read() until the real callback is set up */
-- 
2.51.0



