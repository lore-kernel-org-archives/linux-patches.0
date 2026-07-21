Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B87546D549;
	Tue, 21 Jul 2026 19:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661478; cv=none; b=V9MXbIYE8RZpdkMNuhw5KlefiyLio74h4lmaa1AWXCLl7MbjmmVZIkjbkn+eYpGPIMLFt4CEquHC0T++q8fzTcyxD7pdtYpnt6Pparr+XTXcL6Cqh/yqmIrTGyN6CBG26ILu7fELBJv6lddh/LD92yEsdtCCIQXZc4cgxxtAQQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661478; c=relaxed/simple;
	bh=GP3ENy2qtQPwmF61R5oRF+mMHPTQ6OuQy3TJtSHFkLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmYOpG6OSl1TmGtiHh9OAoNKYmeXEdbaUNb83BSiIFSB5Nf6uqzsIbILBMDbTYwMT/PQyCzC5qRFQIhnksEffyFe104s5ddMyiqzGUIwKgzkYfzFodu7I/0VKWPtLP3IeM9UqgfLR33sk5brnbBYiEtzKq0wIBD0HmCE3QeBsqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmM3ftRm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmM3ftRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F70B1F000E9;
	Tue, 21 Jul 2026 19:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661476;
	bh=cevU2vwJDkdhgUSuP5kmIPxIE/xkbQjvtw/f4GGFJsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tmM3ftRmjt4C1cLXHxa6jVy5xagn1KrGRBmLQ6KmT4+3DvuKHu/W4d7pjHQVssh0P
	 IrNWiMpcBWAZR+9TIrV/NZQcJhrhqlu/ohdkPwuFq7WIBsYXoHoe0yvdeuoMoAqSBH
	 RLjviE3/9p4tarW7jvnXJ7aLawCX0c1uWTEUw+WY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingjing Deng <micro6947@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0080/1276] kconfig: fix potential NULL pointer dereference in conf_askvalue
Date: Tue, 21 Jul 2026 17:08:43 +0200
Message-ID: <20260721152447.884506849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingjing Deng <micro6947@gmail.com>

[ Upstream commit b9d21c32dca2167a614e66c9e27999b9e1c33d55 ]

In conf_askvalue(), the 'def' argument (retrieved via sym_get_string_value)
can be NULL. While current call sites ensure that 'def' is valid,
calling printf("%s\n", def) is technically undefined behavior and could
lead to a segmentation fault on certain libc implementations if the
function were called with a NULL pointer in the future.

Improve the robustness of conf_askvalue() by providing an empty string
as a fallback.

Additionally, remove the redundant re-initialization of the 'line'
buffer inside the !sym_is_changeable(sym) block, as it is already
properly initialized at the function entry.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xingjing Deng <micro6947@gmail.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20260306021709.27068-1-micro6947@gmail.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/conf.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 3d7d454c54da3c..7f4b371ef41f30 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -297,9 +297,7 @@ static int conf_askvalue(struct symbol *sym, const char *def)
 	line[1] = 0;
 
 	if (!sym_is_changeable(sym)) {
-		printf("%s\n", def);
-		line[0] = '\n';
-		line[1] = 0;
+		printf("%s\n", def ?: "");
 		return 0;
 	}
 
@@ -307,7 +305,7 @@ static int conf_askvalue(struct symbol *sym, const char *def)
 	case oldconfig:
 	case syncconfig:
 		if (sym_has_value(sym)) {
-			printf("%s\n", def);
+			printf("%s\n", def ?: "");
 			return 0;
 		}
 		/* fall through */
-- 
2.53.0



