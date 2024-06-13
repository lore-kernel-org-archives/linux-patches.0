Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26571465B0;
	Thu, 13 Jun 2024 12:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280571; cv=none; b=QrTcEnqUJDpp+qVT8g0OWLBlW0zQ9Hw2oxLugSt2DJLrmnP3B17VGizGMzGjhxNICv3MhnPI2FzWsjGvILaAe95TiHJ1S8oiPED740x3vgqJgxRd/wrKcu/5tJ1SN5NdndHfdz3Pz2p8/qZ1nAuQehEgqOOw504nt24I3VW3WKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280571; c=relaxed/simple;
	bh=mkwivJ/enw2+MRUV0WjxaefW1i0uhDZOMtNl0MPxsK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dp7MKb5NHhszDQ9vEoz/5FaiiWmyWbKcp0Gdb4zRp77QXdJEx3Ddl9CHcbgzzFKbBlreRNLSRR2Edl4RHRiPACIZAKqqFFlp0ZqllROmI7jDOO6SlFngS97gZZ2lJFTva/QlFsJQEhevtRrqvJJoQJz8TqANKuhanAhy+KLmaKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UefBE+4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UefBE+4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A277C2BBFC;
	Thu, 13 Jun 2024 12:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280570;
	bh=mkwivJ/enw2+MRUV0WjxaefW1i0uhDZOMtNl0MPxsK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UefBE+4MMsLQsp7h6p71IoLLowkNmFleyNgYQZ5+le94W76ctP1jGjxGu215wnw8g
	 q/xKkTkajblnEPnS2tHsGtdAJDFvLISUQgdH/oMV8ypuEu7e9FX70S0ERJ4rXatF4W
	 BnG9dVlELhmW2TQi3sicdAk5h/ldCaZKdiEMu36I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Stitt <justinstitt@google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 6.6 098/137] kdb: Fix buffer overflow during tab-complete
Date: Thu, 13 Jun 2024 13:34:38 +0200
Message-ID: <20240613113227.098237970@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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
@@ -367,14 +367,19 @@ poll_again:
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


