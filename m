Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637B61422AB;
	Thu, 13 Jun 2024 11:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279537; cv=none; b=rGOmYBIMqt0NTr2bz4WNqp9GGAaDCRvJYVhyfZUmdslxHHBKBeVAlwRmxaHcIDG3QO8NBiqw2ZvRGu/DZsJWpOvdWzzfWeGycDfX5LX5ny/CZN4XpgZJBMx3FXnD5JSSf3WlSY2mWTHVOMbZdR/hFdV9w48Ppmbe7UQd04X5Ozw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279537; c=relaxed/simple;
	bh=yj3gZRKYDHZvanm0uc1a59qZwyX4f/ZWauocnXP1yQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0t0QRH70xcnm96MlRYmfpV1lqQXmZqdlovXFdYjNTme77Sxn0kriXtQRp2z9JpVYXFvuUU3x8Pa2SM+xmkTnkfDz8wQTNwp86KtWl4Unw8gR0BeqWcC+hNR2y45VuL50O0gAVVz7PpYpXrVZZvvWI6en8inhOQaf6nLl66nx2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=POTlPZ2G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="POTlPZ2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D642AC32786;
	Thu, 13 Jun 2024 11:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279537;
	bh=yj3gZRKYDHZvanm0uc1a59qZwyX4f/ZWauocnXP1yQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=POTlPZ2GXlRlXPiCFowGEgsskPN4G0mApDVusxuW2uc64RUIjKeHdjBimxmLzIQF0
	 OIhgYy2lWNroEes9v0QEBBMHjpkLLSLFyEufV9WTEmFm51n8Sg++I3795NQNOoTNJw
	 L/24IwtCXXJAJUSpxnd512F5bSVOuZDcXAevVa/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Stitt <justinstitt@google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 6.9 109/157] kdb: Use format-strings rather than \0 injection in kdb_read()
Date: Thu, 13 Jun 2024 13:33:54 +0200
Message-ID: <20240613113231.633283349@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -184,6 +184,33 @@ char kdb_getchar(void)
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
@@ -212,7 +239,6 @@ static char *kdb_read(char *buffer, size
 						 * and null byte */
 	char *lastchar;
 	char *p_tmp;
-	char tmp;
 	static char tmpbuffer[CMD_BUFLEN];
 	int len = strlen(buffer);
 	int len_tmp;
@@ -249,12 +275,8 @@ poll_again:
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
 	case 10: /* linefeed */
@@ -272,19 +294,14 @@ poll_again:
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
@@ -390,13 +407,9 @@ poll_again:
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


