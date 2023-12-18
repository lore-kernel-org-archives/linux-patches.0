Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700383786D;
	Mon, 18 Dec 2023 14:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOrv20aF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F65C433C8;
	Mon, 18 Dec 2023 14:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908572;
	bh=cHVO6q3z83E4RLApUiWJsEMM5a/9kTbTBoVvenj1MxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOrv20aFwkHkiI2GHqEbm42+EK96fK/tDzVa7Rw9P377a2hvjWhjtuANXqQx66Yr0
	 5/wNonvtQQFwHp2kITpP1P8h45YPMBVbg7lSd94hsbYdJ2gzNhQeMiaVEvIuwvT4gV
	 FQQgGUibyhIUP1oTW3E1+ZtX6y/APuOsbqeoX1nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jslaby@suse.cz>,
	Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Subject: [PATCH 5.10 59/62] tty: n_gsm, remove duplicates of parameters
Date: Mon, 18 Dec 2023 14:52:23 +0100
Message-ID: <20231218135048.796377822@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135046.178317233@linuxfoundation.org>
References: <20231218135046.178317233@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit b93db97e1ca08e500305bc46b08c72e2232c4be1 upstream.

dp, f, and i are only duplicates of gsmld_receive_buf's parameters. Use
the parameters directly (cp, fp, and count) and delete these local
variables.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20210302062214.29627-41-jslaby@suse.cz
Signed-off-by: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2577,27 +2577,24 @@ static void gsmld_receive_buf(struct tty
 			      char *fp, int count)
 {
 	struct gsm_mux *gsm = tty->disc_data;
-	const unsigned char *dp;
-	char *f;
-	int i;
 	char flags = TTY_NORMAL;
 
 	if (debug & 4)
 		print_hex_dump_bytes("gsmld_receive: ", DUMP_PREFIX_OFFSET,
 				     cp, count);
 
-	for (i = count, dp = cp, f = fp; i; i--, dp++) {
-		if (f)
-			flags = *f++;
+	for (; count; count--, cp++) {
+		if (fp)
+			flags = *fp++;
 		switch (flags) {
 		case TTY_NORMAL:
-			gsm->receive(gsm, *dp);
+			gsm->receive(gsm, *cp);
 			break;
 		case TTY_OVERRUN:
 		case TTY_BREAK:
 		case TTY_PARITY:
 		case TTY_FRAME:
-			gsm_error(gsm, *dp, flags);
+			gsm_error(gsm, *cp, flags);
 			break;
 		default:
 			WARN_ONCE(1, "%s: unknown flag %d\n",


