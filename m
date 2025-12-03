Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7729E346E58;
	Wed,  3 Dec 2025 16:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778308; cv=none; b=qhDpeNnFUDP+keu837pQD+hpp8OKoKExf+Ty2u6LEt7/PFaG7w9kQbIbPQEkIZuMM33IcieXnhwZA8d2kMCzFG0ASO6T6/dDzoNaQkLL9JyFkK1h1mvWjbNzYsSI+fkG8ywuBz+gUlt59RW8967fXNZCBg94IDNMPBWaaR2RlZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778308; c=relaxed/simple;
	bh=+03kmBdLbCMoCnis6LhHAfKj1L2zmulsNTZlQgC3eoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GgxnuWgBgO3l4h80KIpNokboDWYrnG26oQYVtTH7MUMbWe1GspyFQ05n8E9SHLeMFfTIY2INEleDsTNUt+rqRiutoYxNzLa4m8MoJRkCHoM0W7qhQPhhho+SujFLzHzrPXoynMZPIgzP6EeMv61hb9Lwr3tNvxChr3+SQ/r3cno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNKmeCsn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNKmeCsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0879C4CEF5;
	Wed,  3 Dec 2025 16:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778308;
	bh=+03kmBdLbCMoCnis6LhHAfKj1L2zmulsNTZlQgC3eoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNKmeCsnQfipo2RQ7cW0NNqQqjA8yKNIDoxGvZqyggwmddZvyPQfZbHqzAldPaKCO
	 DJpmwRZaK9nocq1y+IUXgDgD8Wecv2u2xyPsgci+05ST9lpuUnqJEUzlgMnlOqIZEl
	 IL/DspedUzoSnTzOsc8HhwLuCer334IHr4L/qFwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jakub=20Hork=C3=BD?= <jakub.git@horky.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 305/392] kconfig/mconf: Initialize the default locale at startup
Date: Wed,  3 Dec 2025 16:27:35 +0100
Message-ID: <20251203152425.387560697@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9d3cf510562f8..0649ff35ec5c0 100644
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
@@ -1005,6 +1006,8 @@ int main(int ac, char **av)
 
 	signal(SIGINT, sig_handler);
 
+	setlocale(LC_ALL, "");
+
 	if (ac > 1 && strcmp(av[1], "-s") == 0) {
 		silent = 1;
 		/* Silence conf_read() until the real callback is set up */
-- 
2.51.0



