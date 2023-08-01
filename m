Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6BA1FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DDEC433C7;
	Tue,  1 Aug 2023 09:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883301;
	bh=osKxvr2rCQ7M/isONJjfJ60w80FM14ABmnvn7fVLBf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c06ib5YzpED5+sKJTbkKAcBbptf5Hqdp7S7SxY5SOTMc1eQOw0z6Fao+ikyvUa2VA
	 lM/Xqb7ExHwWjyZKjev0jjkQ1zcUTv9uplS0W6NppuHefeGPzOaQJ59G6bJQRXiMEl
	 ufvvryP5LRBFsi9/okR0Z7dvfAP2tFMDSXCey/n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Kees Cook <keescook@chromium.org>,
	Nicolas Pitre <nico@fluxnic.net>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.4 158/239] TIOCSTI: always enable for CAP_SYS_ADMIN
Date: Tue,  1 Aug 2023 11:20:22 +0200
Message-ID: <20230801091931.342370928@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit 690c8b804ad2eafbd35da5d3c95ad325ca7d5061 upstream.

83efeeeb3d04 ("tty: Allow TIOCSTI to be disabled") broke BRLTTY's
ability to simulate keypresses on the console, thus effectively breaking
braille keyboards of blind users.

This restores the TIOCSTI feature for CAP_SYS_ADMIN processes, which
BRLTTY is, thus fixing braille keyboards without re-opening the security
issue.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Acked-by: Kees Cook <keescook@chromium.org>
Fixes: 83efeeeb3d04 ("tty: Allow TIOCSTI to be disabled")
Cc: stable@vger.kernel.org
Reported-by: Nicolas Pitre <nico@fluxnic.net>
Link: https://lore.kernel.org/r/20230710002645.v565c7xq5iddruse@begin
Acked-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/tty_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2276,7 +2276,7 @@ static int tiocsti(struct tty_struct *tt
 	char ch, mbz = 0;
 	struct tty_ldisc *ld;
 
-	if (!tty_legacy_tiocsti)
+	if (!tty_legacy_tiocsti && !capable(CAP_SYS_ADMIN))
 		return -EIO;
 
 	if ((current->signal->tty != tty) && !capable(CAP_SYS_ADMIN))


