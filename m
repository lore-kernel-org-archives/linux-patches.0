Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47781448C3;
	Thu, 13 Jun 2024 12:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281581; cv=none; b=Wkm+iSJx8KgJEua3/O4Gpu8E9KcjflICC9dP9hsU7pOqL+2UUwKqTCjnGahpdksJ2maMatV8dUn2z37C/c+lxr8nZp0WwXSMG4shSs7V0NGF70pBfgufBsb7jmH0lAgTurjlfBLWr8vXChWFfgxNC3j0qv4GIwceX0s8Vop2tJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281581; c=relaxed/simple;
	bh=TSbV6LF19n3nQupjV6yzvx8o1v45v6PMhJQMDUzgAb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okHqReJxdz8sYEuiHHYBysUcnbysAxKD1HN4dOEPyjKgqRnfSOynRP0JPM0kCRcoiR9/Fj9UKSmhskcGzf1oj85C7oMDIh4cbMnBXVMCCcc3E6SGpEuZfawlSDkS29tintF9DX2URsQJKj8Yyd3u6QeIHjPZVeuIK4agRvBZsfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0QogH8My; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0QogH8My"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE92C2BBFC;
	Thu, 13 Jun 2024 12:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281580;
	bh=TSbV6LF19n3nQupjV6yzvx8o1v45v6PMhJQMDUzgAb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0QogH8MyIXmwVhPasQ5SZJxmiw/RU9I2n1F5k+aHAAzLFypcqbrGo3O/v4Lm29g/R
	 +4LEgsk0VPkG0zaUvS5VZ0olboY+Re8MSAQYhHjwfatA9ZuNJZE6jwDh4Yae1ED+mG
	 8ZdXnF7Zy5yn9GOYFjUUL6+4bHjld0eRHtVFujvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Stitt <justinstitt@google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 5.10 304/317] kdb: Use format-strings rather than \0 injection in kdb_read()
Date: Thu, 13 Jun 2024 13:35:22 +0200
Message-ID: <20240613113259.310610866@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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
@@ -172,6 +172,33 @@ char kdb_getchar(void)
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
@@ -200,7 +227,6 @@ static char *kdb_read(char *buffer, size
 						 * and null byte */
 	char *lastchar;
 	char *p_tmp;
-	char tmp;
 	static char tmpbuffer[CMD_BUFLEN];
 	int len = strlen(buffer);
 	int len_tmp;
@@ -237,12 +263,8 @@ poll_again:
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
@@ -259,19 +281,14 @@ poll_again:
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
@@ -377,13 +394,9 @@ poll_again:
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


