Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51FE223E61;
	Thu, 12 Dec 2024 17:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025874; cv=none; b=edCvisM3qGY95e3TQgBTdxAq7g9YB1YWUYgtm/YaUlRgwcmE3VArqE5OSdkT4952WQJ2b3A3/ZTCO7+HLqrNbdudwWBU/mORKGYYGMQs/td66TQkD2aX2sEuc5WXf+Mt758FhNOmdbOIem2KQK7rwRdHsDcmnbCEwvaOUdQs8ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025874; c=relaxed/simple;
	bh=3GEGoYRmpQVwIN1Kf86mM4Tfknz6XpeRX6GTAG2tAhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5aSd1wjJCHd0NUF4oM0/ztn+kV7EVJgmBjagtwdUPPV9bMBSvG/a9TcO+1DGyXt4NCyM1gYefxqepVZdeRAMfiqDhwjFRQHndu8nikxHVcsWrfz1lVcRc7kPx0bSSGs2dHypE2rTyixde9RvTgcp3R0fktH/gimoB6s/lWnIeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHhCkcEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHhCkcEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B99BC4CED1;
	Thu, 12 Dec 2024 17:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025874;
	bh=3GEGoYRmpQVwIN1Kf86mM4Tfknz6XpeRX6GTAG2tAhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHhCkcEdzd7wRsI9ZJOWWAN2ZtRXvidktS+M9fZowk/XhoCofb8POl692zm9s9IV9
	 DubjauEZmDVitT70OWv0n0nz1Na4dwm+BR+jUNkgtAMUU64xMOTiujhriJppMieenO
	 mGZD4TGxUyjHBkMoc1MWc1pALprWNnvx3vVE+Ylg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.4 317/321] modpost: Add .irqentry.text to OTHER_SECTIONS
Date: Thu, 12 Dec 2024 16:03:55 +0100
Message-ID: <20241212144242.504493295@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 7912405643a14b527cd4a4f33c1d4392da900888 upstream.

The compiler can fully inline the actual handler function of an interrupt
entry into the .irqentry.text entry point. If such a function contains an
access which has an exception table entry, modpost complains about a
section mismatch:

  WARNING: vmlinux.o(__ex_table+0x447c): Section mismatch in reference ...

  The relocation at __ex_table+0x447c references section ".irqentry.text"
  which is not in the list of authorized sections.

Add .irqentry.text to OTHER_SECTIONS to cure the issue.

Reported-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org # needed for linux-5.4-y
Link: https://lore.kernel.org/all/20241128111844.GE10431@google.com/
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/mod/modpost.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -963,7 +963,7 @@ static void check_section(const char *mo
 		".kprobes.text", ".cpuidle.text", ".noinstr.text"
 #define OTHER_TEXT_SECTIONS ".ref.text", ".head.text", ".spinlock.text", \
 		".fixup", ".entry.text", ".exception.text", ".text.*", \
-		".coldtext"
+		".coldtext", ".irqentry.text"
 
 #define INIT_SECTIONS      ".init.*"
 #define MEM_INIT_SECTIONS  ".meminit.*"


