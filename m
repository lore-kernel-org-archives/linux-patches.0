Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FE33168E8;
	Wed,  3 Dec 2025 15:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776610; cv=none; b=SH8d7mjmpdnJh1nGNNB3cgBhi/9hX0K+vwI9/5xmhhCmVgMs4VdjuJIbgXcNe5LZ8kIQG/hzFbrOR9iTgZ5pl2t+kphobB6KNy+jL2JwozlE3JI/kiAQMcrGfbsHcBUNPoQTnuzO7j4SmYE6NpO+3amoqSOKDjvbM00VphwgAMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776610; c=relaxed/simple;
	bh=QTHkV4stns3yCn4gHJsqRRvyT4PNNbAJD92NLzzBDuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C272C/N/OR/c34e7tFZhl+dWxaOONXfPd+aX1k/9QFVHnQBhv0ip/icb5lq2arfyKdb+QXh+/tHO2e6RZsnNHM8tU1Ax9fIfRqXvi4r+Mzree2CJFFsBeXTn4u7E+SImRmo6ac6RP8cOhS4apNNPgju+qOGxVYcOymISsideJj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQvn6SQk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQvn6SQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4010CC4CEF5;
	Wed,  3 Dec 2025 15:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776610;
	bh=QTHkV4stns3yCn4gHJsqRRvyT4PNNbAJD92NLzzBDuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQvn6SQkNQwl2NLLTFq+rfs2GRDm744MmYF5CuzD7y2HbZedyAUitp8uvVZaM2WLS
	 cOiBKvU4B6zOWxftppRyyb8i8PtGqogyeVZ6ekN7vJEDjS+e10Ottcr2wHjumPPA3D
	 j9Tii5Bjlw3HEvKk3njq3t/3lvZHXhuOwPrL1lxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jakub=20Hork=C3=BD?= <jakub.git@horky.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 233/300] kconfig/nconf: Initialize the default locale at startup
Date: Wed,  3 Dec 2025 16:27:17 +0100
Message-ID: <20251203152409.258703007@linuxfoundation.org>
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
index cdbd60a3ae16a..5b504be357135 100644
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



