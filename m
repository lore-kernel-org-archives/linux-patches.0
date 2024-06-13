Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB051459F1;
	Thu, 13 Jun 2024 11:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279190; cv=none; b=ZPWQZWcnzsxWXOXH0ddv7UkRZmb8+pW0o1OKj1IqIP2iuSoW1NjQfzm2MQ1MIuSFzOLPRV97W1wNGT658KSw3UiNPwH0YZF+L0m5wIX2rD8UcAamd5vkZCdOljc7+y5211URloQ+KVlVPKy75y2OWnlqmGkwuki5UznAEY0rTjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279190; c=relaxed/simple;
	bh=eg4Ju8Gg7wJ1JeidNfPyx/8dZ2VZi4BCA2Nh7Yln35c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9qq6A70B0Eiotlg6s9dcQeHAq2eUhBk5eeE4kFb0YfXeY5do3616glG4pjJUmL+93m7WEYBRjY5xaGOTjEbxyppROvz3pDaBXP9MxojgTFA+s2QLUnUI/HWzCPZzgHdM4wRUik2UisnUrRxAZVmOUQkhmB1FDzh2AXiJND/7Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3Y2L83D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3Y2L83D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C40C4AF1C;
	Thu, 13 Jun 2024 11:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279189;
	bh=eg4Ju8Gg7wJ1JeidNfPyx/8dZ2VZi4BCA2Nh7Yln35c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3Y2L83Db9MzJ5YO+6OrLn5vzVD/kibl0ojyASp+6UBfwrJWbnSTDJ6EqiD/G0iQv
	 5f9+hGWU7C6liDON7338gUpl8vTFvURCFhYZRciT7ifbXOEwgs/xAk3jGqHr8YpOBv
	 Bzp7zL2pv7QalV5Ozd1EtM0Dh8bRanDUPnk4z4c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Stitt <justinstitt@google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 4.19 205/213] kdb: Use format-strings rather than \0 injection in kdb_read()
Date: Thu, 13 Jun 2024 13:34:13 +0200
Message-ID: <20240613113235.889254175@linuxfoundation.org>
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
@@ -170,6 +170,33 @@ static int kdb_read_get_key(char *buffer
 	return key;
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
@@ -208,7 +235,6 @@ static char *kdb_read(char *buffer, size
 						 * and null byte */
 	char *lastchar;
 	char *p_tmp;
-	char tmp;
 	static char tmpbuffer[CMD_BUFLEN];
 	int len = strlen(buffer);
 	int len_tmp;
@@ -247,12 +273,8 @@ poll_again:
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
@@ -269,19 +291,14 @@ poll_again:
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
@@ -387,13 +404,9 @@ poll_again:
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


