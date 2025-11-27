Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5FD332EA0;
	Thu, 27 Nov 2025 14:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255401; cv=none; b=mf6ZNtxWfK6Mb0eE3HxrkbAGUD1m3c+JtLj0B1KgOEcDSmaG9KPOW8GyzBTGuLvdQsljVD2Eh0OqHJeLWcaSPIaS61TbXSYDYYyFEEvecYL0phuPFUNLboyg8LMUVVbjVg9oYg+q7WLS7Rfx1UnZY4nE749KRNVDsRNXPbe8Vko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255401; c=relaxed/simple;
	bh=+CKqqqYe7XBcamQ2WPpYmsHbtSv30Fd+KWF/TcGXmpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UiUF/1ovS6rnRJPIpdfNok9q7yvhFSZEcsZFNdhteWQR6QWzJPiumzVGTZbqGpmDuQPsVYqdr1/ckg5wpHsJizKiCgs2FgHpGHQHN/UbY0aof6JWbjgnGPfqSS/27X2gq1IWD6QIgaFMF8QTKhfV9LeZuY0I2h34F1gBS9Lh4jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9C2HR8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9C2HR8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6ADBC4CEF8;
	Thu, 27 Nov 2025 14:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255401;
	bh=+CKqqqYe7XBcamQ2WPpYmsHbtSv30Fd+KWF/TcGXmpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V9C2HR8MG2VFyE6Zav2l0FIHG32tAzo4jFv3XZhwZsWalf1p6dlRkk0E5iHfJcLYe
	 CduyVo8kiceWIbpxSUHXFDR3Wkcz6mefm6ddnTZzKmxt1Dd+R6HlUbCGelTfNoY3/1
	 ukZfmhujMePJ8CIq/qqm2edO3MKZSqPG3v5fBTas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jakub=20Hork=C3=BD?= <jakub.git@horky.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/112] kconfig/nconf: Initialize the default locale at startup
Date: Thu, 27 Nov 2025 15:46:34 +0100
Message-ID: <20251127144036.209143204@linuxfoundation.org>
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
index 5f484422278e1..cfe66aaf8bfe9 100644
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



