Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BD1346FAE;
	Wed,  3 Dec 2025 16:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778311; cv=none; b=BJKtywHOTCJ+1KqKpXPFopn8spOcP9SIkNj/hfFegR+y14D63dXpAnmDlqgtjxwoAQff/wf0AXw7+aeUNzAL9ucaSSygnPaNbzbVcwiCZym2UCHfSv66AWW1+x/pNl/+m4ZdEKLMKbj4jhfE7IAsFpVp7x1oKcTXwwSzJeD0Nqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778311; c=relaxed/simple;
	bh=yN3vbxw31puUTRlk8TXRuEBxNUTw38WikPXUMXAsGUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TOo0WBSvsizLzieA+2cec40Tm7J5wYMS0DHLu/tILNM53AAeXyKulvC0s30yrbp2AuDdX7lBP2rKp1AW5Zx7rVV5F4BFkjtbcoFgkgTWihJgZcdCdg7TW2gVLO2fGV8yXVBg0fgk17VGsBfe1BUiTMTdCYDBnVuzIQmsCkVKAsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBOcdLOR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBOcdLOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2DBC4CEF5;
	Wed,  3 Dec 2025 16:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778311;
	bh=yN3vbxw31puUTRlk8TXRuEBxNUTw38WikPXUMXAsGUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBOcdLORXIpgclr4zMvEpO0TCCelM/qSQCLVflZWsfNCDHDV+mpRcMmH40k9psFM3
	 mhjneAVE4C+NncGbBKmhHJpl7j+qlrAPUrtS+PDd4BjJO6IXQ5mVxqNh1ngGRRC/MG
	 7X+FosvmKpZIljO4K4Ki6mn63VdhXV3CbL80wLUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jakub=20Hork=C3=BD?= <jakub.git@horky.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 306/392] kconfig/nconf: Initialize the default locale at startup
Date: Wed,  3 Dec 2025 16:27:36 +0100
Message-ID: <20251203152425.422917801@linuxfoundation.org>
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
index 8b166ccb0447f..d1d928b20ecfd 100644
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
@@ -1472,6 +1473,8 @@ int main(int ac, char **av)
 	int lines, columns;
 	char *mode;
 
+	setlocale(LC_ALL, "");
+
 	if (ac > 1 && strcmp(av[1], "-s") == 0) {
 		/* Silence conf_read() until the real callback is set up */
 		conf_set_message_callback(NULL);
-- 
2.51.0



