Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D3313D624;
	Thu, 13 Jun 2024 11:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279187; cv=none; b=Fo/SnM5qRNakyGilRyyz13ahk4s6k8brJgYUadRW7kukSMTuXf6v7Bu7qLJj2p9Kgnlmjy3z2ZOrSyN3UZv0Wo2TbDO20Mvhie1Ck5z6tt/ZMB0wKb7DsYIcFXy1U3gR1h0knwLskqLQrBlcowBmFumAP7tp7i47l+l8MmBMyL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279187; c=relaxed/simple;
	bh=grA2bFU2SgNvC3gKiFwmJ+woFPy6It7bQY1bz16F64A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rF8QnYrAjeNmLzBXxZwSugijSxVBvzG9VxR9H15KnCm5MFHYEBQD6brVFWBc3YxYxSmXlshkieQAxeTd0fLHQZiBJMb3RxmGfdo2Df02ZG1o5b9ImE9yNk5V0/hzK0LZza2VlDBn1kw6cc3Kr0UpWVzJubZwLgUsYs93lhcX/80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOpKfOgd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOpKfOgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CB7C2BBFC;
	Thu, 13 Jun 2024 11:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279186;
	bh=grA2bFU2SgNvC3gKiFwmJ+woFPy6It7bQY1bz16F64A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOpKfOgdKkA1swy7FZtTT6N0g4EbYiN3GLBph+0mB8GJ+1N8mMYmffJax51Q5kwfy
	 s8KDyae31FmO1xLWZPOUm3K6TiF18VSLshFq9rOXuf0n3mtlhWXDCIGjgd6f/8pnbX
	 SRFu76KmBGEEmcFkL6EE00Pj1mX9ujKlgXyuIs94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Stitt <justinstitt@google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 4.19 204/213] kdb: Fix buffer overflow during tab-complete
Date: Thu, 13 Jun 2024 13:34:12 +0200
Message-ID: <20240613113235.849526175@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Thompson <daniel.thompson@linaro.org>

commit e9730744bf3af04cda23799029342aa3cddbc454 upstream.

Currently, when the user attempts symbol completion with the Tab key, kdb
will use strncpy() to insert the completed symbol into the command buffer.
Unfortunately it passes the size of the source buffer rather than the
destination to strncpy() with predictably horrible results. Most obviously
if the command buffer is already full but cp, the cursor position, is in
the middle of the buffer, then we will write past the end of the supplied
buffer.

Fix this by replacing the dubious strncpy() calls with memmove()/memcpy()
calls plus explicit boundary checks to make sure we have enough space
before we start moving characters around.

Reported-by: Justin Stitt <justinstitt@google.com>
Closes: https://lore.kernel.org/all/CAFhGd8qESuuifuHsNjFPR-Va3P80bxrw+LqvC8deA8GziUJLpw@mail.gmail.com/
Cc: stable@vger.kernel.org
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Tested-by: Justin Stitt <justinstitt@google.com>
Link: https://lore.kernel.org/r/20240424-kgdb_read_refactor-v3-1-f236dbe9828d@linaro.org
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/debug/kdb/kdb_io.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -364,14 +364,19 @@ poll_again:
 			kdb_printf(kdb_prompt_str);
 			kdb_printf("%s", buffer);
 		} else if (tab != 2 && count > 0) {
-			len_tmp = strlen(p_tmp);
-			strncpy(p_tmp+len_tmp, cp, lastchar-cp+1);
-			len_tmp = strlen(p_tmp);
-			strncpy(cp, p_tmp+len, len_tmp-len + 1);
-			len = len_tmp - len;
-			kdb_printf("%s", cp);
-			cp += len;
-			lastchar += len;
+			/* How many new characters do we want from tmpbuffer? */
+			len_tmp = strlen(p_tmp) - len;
+			if (lastchar + len_tmp >= bufend)
+				len_tmp = bufend - lastchar;
+
+			if (len_tmp) {
+				/* + 1 ensures the '\0' is memmove'd */
+				memmove(cp+len_tmp, cp, (lastchar-cp) + 1);
+				memcpy(cp, p_tmp+len, len_tmp);
+				kdb_printf("%s", cp);
+				cp += len_tmp;
+				lastchar += len_tmp;
+			}
 		}
 		kdb_nextline = 1; /* reset output line number */
 		break;


