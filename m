Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB30615D5D4;
	Mon, 29 Jan 2024 17:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548419; cv=none; b=sfdcWlsKquf3SCC68aIAqBAEVSM3pwkteYx+2fYn35gyAzrp2W6nyCYELeVCTgaMlP+/WmUcbvaBnBpc/M9645YFlXvwEwK+44DD42AuOZF0kWg9KbHxtq659M+bZyYKlB8ficfNwFPpwUh8pVfWS/r/tP57atVipZ+y+nj50JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548419; c=relaxed/simple;
	bh=ArysNrgm586c0bdfiOy9gNJW+G5/rSoWZ76DfkHz6YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHFbf5v7ColddzNF/uPZ7NKodyPLQ2hObVbkozYPBxHepQqbujmABwT/S1bUz4m2xynC7Uhf0dU+s+JJ3Ab94jalotoAhrJ6ZNQmjUzjWyjzilHt6JOYWOk7ebbpbm+27LNf+LiBcvXLstzzZWWFpzwe328dEbY5mEewmgKC2Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrXYNrnv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrXYNrnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FDBC433F1;
	Mon, 29 Jan 2024 17:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548418;
	bh=ArysNrgm586c0bdfiOy9gNJW+G5/rSoWZ76DfkHz6YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrXYNrnvpE49XcZ97vWBuurK+SW4dB3+7V6doN13687x8blWnDqxi/Mb+rI6UwLoL
	 9I1YvpEb5UPzuGDA3ltkvsKdrfCWnJnCzWjjuFuHlIn1322NuunLxmp7MNdoGuv5Dd
	 fYneh9hcEl8hyTcO9h+v8bkGRTddyF0BgkkLhfSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/331] riscv: Fix an off-by-one in get_early_cmdline()
Date: Mon, 29 Jan 2024 09:01:21 -0800
Message-ID: <20240129170015.467440724@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit adb1f95d388a43c4c564ef3e436f18900dde978e ]

The ending NULL is not taken into account by strncat(), so switch to
strlcat() to correctly compute the size of the available memory when
appending CONFIG_CMDLINE to 'early_cmdline'.

Fixes: 26e7aacb83df ("riscv: Allow to downgrade paging mode from the command line")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/9f66d2b58c8052d4055e90b8477ee55d9a0914f9.1698564026.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/pi/cmdline_early.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/pi/cmdline_early.c b/arch/riscv/kernel/pi/cmdline_early.c
index 68e786c84c94..f6d4dedffb84 100644
--- a/arch/riscv/kernel/pi/cmdline_early.c
+++ b/arch/riscv/kernel/pi/cmdline_early.c
@@ -38,8 +38,7 @@ static char *get_early_cmdline(uintptr_t dtb_pa)
 	if (IS_ENABLED(CONFIG_CMDLINE_EXTEND) ||
 	    IS_ENABLED(CONFIG_CMDLINE_FORCE) ||
 	    fdt_cmdline_size == 0 /* CONFIG_CMDLINE_FALLBACK */) {
-		strncat(early_cmdline, CONFIG_CMDLINE,
-			COMMAND_LINE_SIZE - fdt_cmdline_size);
+		strlcat(early_cmdline, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
 	}
 
 	return early_cmdline;
-- 
2.43.0



