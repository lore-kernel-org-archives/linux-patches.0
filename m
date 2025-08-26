Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6414F34A325;
	Tue, 26 Aug 2025 14:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219128; cv=none; b=M7VCjE+WE8wgdnD+rZtxRnTA+JvYKmkR9TAq2BLS4EM/UCEhx7dHqGWkif2cKXQC60WB9U+my9TYZQuoJJZWkmxPNLZ2FRGHAmhT3MitmB2MHlTHQvoTEbyupehmFqGnckUrUDsLCVY7xxwmQNtFvTTw/Cw98Mfn7aUH01h5j04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219128; c=relaxed/simple;
	bh=bdwgwyPfaEf2vVeQL02cPc191nKRPEnUTDLjw02ab8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lX5VJjKP0Ne8x6EmhU13lhS0ODfl54TsrAiV7Uu7nZ8pO75uUKqRivws0rF6B+xlPI1ajKRf3kkthd/4d0vKSSywCCsjqasNr8WrlkK83eoKaPAbRHGg6yfGSyisetWMXnI0m0bw9zlzJqIkvlBqbdoIDEMb5fF+sz0dWZcPAAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fSgjtS79; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fSgjtS79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6ECC4CEF1;
	Tue, 26 Aug 2025 14:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219128;
	bh=bdwgwyPfaEf2vVeQL02cPc191nKRPEnUTDLjw02ab8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fSgjtS79jmYFtluinrl9bxQMsDmgb2zHD5onNtEukXO8rbNC/YFHZooraP3EnCVdq
	 W2CPTp//0Z3CKKdQLduvY+TJ4A6wA3F5GKpGf9WBJBjMhdshtmCdkygV2ahtAoJ+Ny
	 3VYiWITOOkZFdxkhK/JnbraOdtSP7LY6bqCFV48E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Yann E. MORIN" <yann.morin.1998@free.fr>,
	Peter Korsgaard <peter@korsgaard.com>,
	Cherniaev Andrei <dungeonlords789@naver.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 264/403] kconfig: lxdialog: fix space to (de)select options
Date: Tue, 26 Aug 2025 13:09:50 +0200
Message-ID: <20250826110914.105041098@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yann E. MORIN <yann.morin.1998@free.fr>

[ Upstream commit 694174f94ebeeb5ec5cc0e9de9b40c82057e1d95 ]

In case a menu has comment without letters/numbers (eg. characters
matching the regexp '^[^[:alpha:][:digit:]]+$', for example - or *),
hitting space will cycle through those comments, rather than
selecting/deselecting the currently-highlighted option.

This is the behaviour of hitting any letter/digit: jump to the next
option which prompt starts with that letter. The only letters that
do not behave as such are 'y' 'm' and 'n'. Prompts that start with
one of those three letters are instead matched on the first letter
that is not 'y', 'm' or 'n'.

Fix that by treating 'space' as we treat y/m/n, ie. as an action key,
not as shortcut to jump to  prompt.

Signed-off-by: Yann E. MORIN <yann.morin.1998@free.fr>
Signed-off-by: Peter Korsgaard <peter@korsgaard.com>
Signed-off-by: Cherniaev Andrei <dungeonlords789@naver.com>
[masahiro: took from Buildroot, adjusted the commit subject]
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/lxdialog/menubox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/lxdialog/menubox.c b/scripts/kconfig/lxdialog/menubox.c
index 58c2f8afe59b..7e10e919fbdc 100644
--- a/scripts/kconfig/lxdialog/menubox.c
+++ b/scripts/kconfig/lxdialog/menubox.c
@@ -272,7 +272,7 @@ int dialog_menu(const char *title, const char *prompt,
 		if (key < 256 && isalpha(key))
 			key = tolower(key);
 
-		if (strchr("ynmh", key))
+		if (strchr("ynmh ", key))
 			i = max_choice;
 		else {
 			for (i = choice + 1; i < max_choice; i++) {
-- 
2.39.5



