Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A421C32;
	Thu, 13 Jun 2024 12:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718283002; cv=none; b=S7RyMqxnUZ8Zwatbv88pEq2JScjyA1pnbfLjJP8QRj90u2nMlYkP8YxFzVZ9lUlWpBq5lk3jyshVc+p+V8x4j/EW3jbzASkweLZpJc/15i7AfWLD+49CNXCxhwPY90nCSfVPsq+wUle8obhCkNYRGQfQ6Bqqiw9KNnFfNlK/kts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718283002; c=relaxed/simple;
	bh=zAc7d5xpRjhFGiOvZXKJwxMdtgkOaQgDzG5btwPPdS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClvWi65Rzg1TENy+AB98dUr0+8zYXMIv9qLuQG4rdSy7+qZj0p8tg41Thzte/rlIcVvJt//0itp3vRPN0e2DsGWgJm82dwVQzvZAgPlknm5tJ+FJY9KGOOVd2yrMmDe2TF/us45/bGBMc8gLnroOcz8i7OfEdRVHmFw/RCg72aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uyyK7av+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uyyK7av+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CAFC2BBFC;
	Thu, 13 Jun 2024 12:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718283002;
	bh=zAc7d5xpRjhFGiOvZXKJwxMdtgkOaQgDzG5btwPPdS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uyyK7av+tMnp3IdI0peqEZllpZTHUWE4EIuYlPszo4YmAFrgu3/iMgTq6ZSVCNmde
	 cpWF5i4BBHPfOMrQLQgyBDIvE303NKxW3CA7iM+7u8c+u/OsVY4JbDNHk7LnID0zug
	 d2HHpaY1zHJaCsfnJ1ZhmJ6ctVW32w+Ws/VtOv4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Stitt <justinstitt@google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 6.1 66/85] kdb: Use format-strings rather than \0 injection in kdb_read()
Date: Thu, 13 Jun 2024 13:36:04 +0200
Message-ID: <20240613113216.684214504@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Thompson <daniel.thompson@linaro.org>

commit 09b35989421dfd5573f0b4683c7700a7483c71f9 upstream.

Currently when kdb_read() needs to reposition the cursor it uses copy and
paste code that works by injecting an '\0' at the cursor position before
delivering a carriage-return and reprinting the line (which stops at the
'\0').

Tidy up the code by hoisting the copy and paste code into an appropriately
named function. Additionally let's replace the '\0' injection with a
proper field width parameter so that the string will be abridged during
formatting instead.

Cc: stable@vger.kernel.org # Not a bug fix but it is needed for later bug fixes
Tested-by: Justin Stitt <justinstitt@google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20240424-kgdb_read_refactor-v3-2-f236dbe9828d@linaro.org
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/debug/kdb/kdb_io.c |   55 ++++++++++++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 21 deletions(-)

--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -171,6 +171,33 @@ char kdb_getchar(void)
 	unreachable();
 }
 
+/**
+ * kdb_position_cursor() - Place cursor in the correct horizontal position
+ * @prompt: Nil-terminated string containing the prompt string
+ * @buffer: Nil-terminated string containing the entire command line
+ * @cp: Cursor position, pointer the character in buffer where the cursor
+ *      should be positioned.
+ *
+ * The cursor is positioned by sending a carriage-return and then printing
+ * the content of the line until we reach the correct cursor position.
+ *
+ * There is some additional fine detail here.
+ *
+ * Firstly, even though kdb_printf() will correctly format zero-width fields
+ * we want the second call to kdb_printf() to be conditional. That keeps things
+ * a little cleaner when LOGGING=1.
+ *
+ * Secondly, we can't combine everything into one call to kdb_printf() since
+ * that renders into a fixed length buffer and the combined print could result
+ * in unwanted truncation.
+ */
+static void kdb_position_cursor(char *prompt, char *buffer, char *cp)
+{
+	kdb_printf("\r%s", kdb_prompt_str);
+	if (cp > buffer)
+		kdb_printf("%.*s", (int)(cp - buffer), buffer);
+}
+
 /*
  * kdb_read
  *
@@ -199,7 +226,6 @@ static char *kdb_read(char *buffer, size
 						 * and null byte */
 	char *lastchar;
 	char *p_tmp;
-	char tmp;
 	static char tmpbuffer[CMD_BUFLEN];
 	int len = strlen(buffer);
 	int len_tmp;
@@ -236,12 +262,8 @@ poll_again:
 			}
 			*(--lastchar) = '\0';
 			--cp;
-			kdb_printf("\b%s \r", cp);
-			tmp = *cp;
-			*cp = '\0';
-			kdb_printf(kdb_prompt_str);
-			kdb_printf("%s", buffer);
-			*cp = tmp;
+			kdb_printf("\b%s ", cp);
+			kdb_position_cursor(kdb_prompt_str, buffer, cp);
 		}
 		break;
 	case 13: /* enter */
@@ -258,19 +280,14 @@ poll_again:
 			memcpy(tmpbuffer, cp+1, lastchar - cp - 1);
 			memcpy(cp, tmpbuffer, lastchar - cp - 1);
 			*(--lastchar) = '\0';
-			kdb_printf("%s \r", cp);
-			tmp = *cp;
-			*cp = '\0';
-			kdb_printf(kdb_prompt_str);
-			kdb_printf("%s", buffer);
-			*cp = tmp;
+			kdb_printf("%s ", cp);
+			kdb_position_cursor(kdb_prompt_str, buffer, cp);
 		}
 		break;
 	case 1: /* Home */
 		if (cp > buffer) {
-			kdb_printf("\r");
-			kdb_printf(kdb_prompt_str);
 			cp = buffer;
+			kdb_position_cursor(kdb_prompt_str, buffer, cp);
 		}
 		break;
 	case 5: /* End */
@@ -376,13 +393,9 @@ poll_again:
 				memcpy(cp+1, tmpbuffer, lastchar - cp);
 				*++lastchar = '\0';
 				*cp = key;
-				kdb_printf("%s\r", cp);
+				kdb_printf("%s", cp);
 				++cp;
-				tmp = *cp;
-				*cp = '\0';
-				kdb_printf(kdb_prompt_str);
-				kdb_printf("%s", buffer);
-				*cp = tmp;
+				kdb_position_cursor(kdb_prompt_str, buffer, cp);
 			} else {
 				*++lastchar = '\0';
 				*cp++ = key;


