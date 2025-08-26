Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CB0352FCE;
	Tue, 26 Aug 2025 14:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217928; cv=none; b=ZPDpBogE2rzb/DMk6ft7Swlvxl2+Lgo60Bw83GG3Vm4QzYZ5mNyfiCaoF1IqYquYH3cX4x2YocSV9yhGZGKhPx2lhJBgHjxFW7veB1y9D8/R6Y4hl9ps3DjGg4AKQHD5z1J6kN/uG6270yy2Pb/S5yUa23ihySmgiI5lhWIKmNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217928; c=relaxed/simple;
	bh=VOTwixWmXZZG1GXeltXZONuTpq/5fM2PwUvKrJLOAZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G23vyUx5uEQttWJcLOeXlxcOpe4HeO+Q0/C+3xDaV3CdpCvrq2OwF2KdVZJuTCTUafTHdlgIwdT1fcDXfwddar6h/UIGC/bjqpExhmSWWVJ8W/OQBHpjeqNwKiIvEiRMzbA75eKJuC/6qPptfVnDD1C3d2/XXccXQPYmrWdzCzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFSPu5rO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFSPu5rO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C73C4CEF1;
	Tue, 26 Aug 2025 14:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217928;
	bh=VOTwixWmXZZG1GXeltXZONuTpq/5fM2PwUvKrJLOAZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFSPu5rOsDOtGtN+UdYSU3+tb8zAriRpDG6DTbERpht4x67dcBI7j8oQw/8WqCD/3
	 OUIpTqshGkczUH4IFOVL5grkXH5A2Xp1xUUmphIGBdv5QT+pg7lymeJKHBkkqEsH9c
	 KFzkpu2+KFvPaBgCyfesraQWSjMEyS5jOng6A3Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Yann E. MORIN" <yann.morin.1998@free.fr>,
	Peter Korsgaard <peter@korsgaard.com>,
	Cherniaev Andrei <dungeonlords789@naver.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 328/523] kconfig: lxdialog: fix space to (de)select options
Date: Tue, 26 Aug 2025 13:08:58 +0200
Message-ID: <20250826110932.568068166@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



