Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C3335E546;
	Wed,  3 Dec 2025 16:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780145; cv=none; b=e/WqBpprMuE6ryn/PJoMimxhr4f1EJkGFqc0X0caiN1eYC7y9MtVp5ylGEtmD/XZlj9nV9f/UQC8UQhstdjkRh7CbuUiN5vFQy4IcFu71oY+fz1WG3AOV1Odk0a7Ql5o5FVsHZgfZUmGzevT/AxM/M5BdFVYoC9nTxob7dTUcnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780145; c=relaxed/simple;
	bh=kKgpuvmHbeRw8w0P5Wqse/1TlbfVmSYKHy2QQuJbL0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FMWlYrMxVfcGFzEo72MSCTqeaGxuUQpGG9HsuVnYStzUv+ynLarkQbDBa0aCjXRe1Js/f0N8KkAd1V9luiuBDpcdWJDk4fmcBlmvnm0GlTnIrEY3CzTyrDUSQlvDpEoxZxTM+4eY4mCLLJULWwWJ3Tq8z8XR10OCYHZSaA1wID0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/Ul0doB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/Ul0doB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAB8C4CEF5;
	Wed,  3 Dec 2025 16:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780145;
	bh=kKgpuvmHbeRw8w0P5Wqse/1TlbfVmSYKHy2QQuJbL0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/Ul0doBBL7GuS7MMKQ+YRkbRv8GAXADqoUShvWQl2WPddgUzEfAXVMlKt3o3hvV5
	 6nRiTQA11/AbhCWVQsWSBdZ5t72Zu2w13hBKDENt3HUoWU6BsLMO5kCEJQwlUnXWVK
	 h5DQ0sHrEc7KbidhZu8LnW9XOr9s1MkNVOOm2i7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jakub=20Hork=C3=BD?= <jakub.git@horky.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 470/568] kconfig/nconf: Initialize the default locale at startup
Date: Wed,  3 Dec 2025 16:27:52 +0100
Message-ID: <20251203152457.915068492@linuxfoundation.org>
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
index 16a2db59432a5..e9ae03d056b09 100644
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
@@ -1476,6 +1477,8 @@ int main(int ac, char **av)
 	int lines, columns;
 	char *mode;
 
+	setlocale(LC_ALL, "");
+
 	if (ac > 1 && strcmp(av[1], "-s") == 0) {
 		/* Silence conf_read() until the real callback is set up */
 		conf_set_message_callback(NULL);
-- 
2.51.0



