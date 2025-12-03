Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AE135E554;
	Wed,  3 Dec 2025 16:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780142; cv=none; b=cMw2M9TvdZ9gP+qZJhoeoysdHnxQAzc8dbwLppPdfjhWqRxSd/p0l9VX0/ZLICXjRMgxF8GZYPlpBr0P3uRpCAxi4HPPDOsESksaAcuyS57F27xrilSpC4R7KL5MS6o5dLoKwbop6TpS/8k6ExqLq/iojb97Qji3roUUQDp2G1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780142; c=relaxed/simple;
	bh=Z1OrTAcITpR6nai9duUxNG5TiiE+kehtA4oZkRBV5jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZntuXz/KgnRwOyUGm2NTD1YUwSzhhMXgb9vF1jN20zPAyajEWyzldLmm5oYEnp5liYrmJSKvzt1U/N8Si8g2nPWP6ylRjZQCz/uM8obROCFPPVMzSAWRvQ4QZvZUFwD7+groYYuSvC+JcQ/9AGDzv7nvKFtkuC5pqA/eFC/sfWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YsdPR3DY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YsdPR3DY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15635C4CEF5;
	Wed,  3 Dec 2025 16:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780142;
	bh=Z1OrTAcITpR6nai9duUxNG5TiiE+kehtA4oZkRBV5jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YsdPR3DYEcgtY/VzCk4lVdpWUdH9QDk6qkNArGHKhoQcQPjYhla+L312I7VkyN9FQ
	 Tn7bjZYMfb4RyU+4aLlsyw5LA+Ae2+Opx59iPngAEaXpxfdIc4Ygpp2YZ7+CmKZvjz
	 iD2N59K70LduDchKjl4tLgTSrohYX7v6eWuLiZG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jakub=20Hork=C3=BD?= <jakub.git@horky.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 469/568] kconfig/mconf: Initialize the default locale at startup
Date: Wed,  3 Dec 2025 16:27:51 +0100
Message-ID: <20251203152457.879083813@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



