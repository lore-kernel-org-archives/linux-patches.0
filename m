Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FEF495E3;
	Wed, 20 Dec 2023 16:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnbChmbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03831C433C8;
	Wed, 20 Dec 2023 16:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703089031;
	bh=F9DXwnFp9LBA/8W1Q1/1eyHXk9fsM5Gv6v+y8feMiYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnbChmbbSK9EVRbUtylyz4RDoya0flfdGenbg2TFlDYhlwgHvP9HwZ34xuEV1o5fF
	 mmAGsU7G90bWq88hPo/QX0VhKSNzsRTkxOr2RFGdycAriWsoecvazNtA7sSqKQQ+YD
	 Vh1HLYQB74cvFMaaFB1I9cIYDw6IbNd2WaxzZdJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marios Makassikis <mmakassikis@freebox.fr>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 144/159] ksmbd: add support for surrogate pair conversion
Date: Wed, 20 Dec 2023 17:10:09 +0100
Message-ID: <20231220160938.046216860@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 0c180317c654a494fe429adbf7bc9b0793caf9e2 ]

ksmbd is missing supporting to convert filename included surrogate pair
characters. It triggers a "file or folder does not exist" error in
Windows client.

[Steps to Reproduce for bug]
1. Create surrogate pair file
 touch $(echo -e '\xf0\x9d\x9f\xa3')
 touch $(echo -e '\xf0\x9d\x9f\xa4')

2. Try to open these files in ksmbd share through Windows client.

This patch update unicode functions not to consider about surrogate pair
(and IVS).

Reviewed-by: Marios Makassikis <mmakassikis@freebox.fr>
Tested-by: Marios Makassikis <mmakassikis@freebox.fr>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/unicode.c |  187 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 138 insertions(+), 49 deletions(-)

--- a/fs/ksmbd/unicode.c
+++ b/fs/ksmbd/unicode.c
@@ -15,45 +15,9 @@
 #include "smb_common.h"
 
 /*
- * smb_utf16_bytes() - how long will a string be after conversion?
- * @from:	pointer to input string
- * @maxbytes:	don't go past this many bytes of input string
- * @codepage:	destination codepage
- *
- * Walk a utf16le string and return the number of bytes that the string will
- * be after being converted to the given charset, not including any null
- * termination required. Don't walk past maxbytes in the source buffer.
- *
- * Return:	string length after conversion
- */
-static int smb_utf16_bytes(const __le16 *from, int maxbytes,
-			   const struct nls_table *codepage)
-{
-	int i;
-	int charlen, outlen = 0;
-	int maxwords = maxbytes / 2;
-	char tmp[NLS_MAX_CHARSET_SIZE];
-	__u16 ftmp;
-
-	for (i = 0; i < maxwords; i++) {
-		ftmp = get_unaligned_le16(&from[i]);
-		if (ftmp == 0)
-			break;
-
-		charlen = codepage->uni2char(ftmp, tmp, NLS_MAX_CHARSET_SIZE);
-		if (charlen > 0)
-			outlen += charlen;
-		else
-			outlen++;
-	}
-
-	return outlen;
-}
-
-/*
  * cifs_mapchar() - convert a host-endian char to proper char in codepage
  * @target:	where converted character should be copied
- * @src_char:	2 byte host-endian source character
+ * @from:	host-endian source string
  * @cp:		codepage to which character should be converted
  * @mapchar:	should character be mapped according to mapchars mount option?
  *
@@ -64,10 +28,13 @@ static int smb_utf16_bytes(const __le16
  * Return:	string length after conversion
  */
 static int
-cifs_mapchar(char *target, const __u16 src_char, const struct nls_table *cp,
+cifs_mapchar(char *target, const __u16 *from, const struct nls_table *cp,
 	     bool mapchar)
 {
 	int len = 1;
+	__u16 src_char;
+
+	src_char = *from;
 
 	if (!mapchar)
 		goto cp_convert;
@@ -105,12 +72,66 @@ out:
 
 cp_convert:
 	len = cp->uni2char(src_char, target, NLS_MAX_CHARSET_SIZE);
-	if (len <= 0) {
-		*target = '?';
-		len = 1;
-	}
+	if (len <= 0)
+		goto surrogate_pair;
 
 	goto out;
+
+surrogate_pair:
+	/* convert SURROGATE_PAIR and IVS */
+	if (strcmp(cp->charset, "utf8"))
+		goto unknown;
+	len = utf16s_to_utf8s(from, 3, UTF16_LITTLE_ENDIAN, target, 6);
+	if (len <= 0)
+		goto unknown;
+	return len;
+
+unknown:
+	*target = '?';
+	len = 1;
+	goto out;
+}
+
+/*
+ * smb_utf16_bytes() - compute converted string length
+ * @from:	pointer to input string
+ * @maxbytes:	input string length
+ * @codepage:	destination codepage
+ *
+ * Walk a utf16le string and return the number of bytes that the string will
+ * be after being converted to the given charset, not including any null
+ * termination required. Don't walk past maxbytes in the source buffer.
+ *
+ * Return:	string length after conversion
+ */
+static int smb_utf16_bytes(const __le16 *from, int maxbytes,
+			   const struct nls_table *codepage)
+{
+	int i, j;
+	int charlen, outlen = 0;
+	int maxwords = maxbytes / 2;
+	char tmp[NLS_MAX_CHARSET_SIZE];
+	__u16 ftmp[3];
+
+	for (i = 0; i < maxwords; i++) {
+		ftmp[0] = get_unaligned_le16(&from[i]);
+		if (ftmp[0] == 0)
+			break;
+		for (j = 1; j <= 2; j++) {
+			if (i + j < maxwords)
+				ftmp[j] = get_unaligned_le16(&from[i + j]);
+			else
+				ftmp[j] = 0;
+		}
+
+		charlen = cifs_mapchar(tmp, ftmp, codepage, 0);
+		if (charlen > 0)
+			outlen += charlen;
+		else
+			outlen++;
+	}
+
+	return outlen;
 }
 
 /*
@@ -140,12 +161,12 @@ cp_convert:
 static int smb_from_utf16(char *to, const __le16 *from, int tolen, int fromlen,
 			  const struct nls_table *codepage, bool mapchar)
 {
-	int i, charlen, safelen;
+	int i, j, charlen, safelen;
 	int outlen = 0;
 	int nullsize = nls_nullsize(codepage);
 	int fromwords = fromlen / 2;
 	char tmp[NLS_MAX_CHARSET_SIZE];
-	__u16 ftmp;
+	__u16 ftmp[3];	/* ftmp[3] = 3array x 2bytes = 6bytes UTF-16 */
 
 	/*
 	 * because the chars can be of varying widths, we need to take care
@@ -156,9 +177,15 @@ static int smb_from_utf16(char *to, cons
 	safelen = tolen - (NLS_MAX_CHARSET_SIZE + nullsize);
 
 	for (i = 0; i < fromwords; i++) {
-		ftmp = get_unaligned_le16(&from[i]);
-		if (ftmp == 0)
+		ftmp[0] = get_unaligned_le16(&from[i]);
+		if (ftmp[0] == 0)
 			break;
+		for (j = 1; j <= 2; j++) {
+			if (i + j < fromwords)
+				ftmp[j] = get_unaligned_le16(&from[i + j]);
+			else
+				ftmp[j] = 0;
+		}
 
 		/*
 		 * check to see if converting this character might make the
@@ -173,6 +200,19 @@ static int smb_from_utf16(char *to, cons
 		/* put converted char into 'to' buffer */
 		charlen = cifs_mapchar(&to[outlen], ftmp, codepage, mapchar);
 		outlen += charlen;
+
+		/*
+		 * charlen (=bytes of UTF-8 for 1 character)
+		 * 4bytes UTF-8(surrogate pair) is charlen=4
+		 * (4bytes UTF-16 code)
+		 * 7-8bytes UTF-8(IVS) is charlen=3+4 or 4+4
+		 * (2 UTF-8 pairs divided to 2 UTF-16 pairs)
+		 */
+		if (charlen == 4)
+			i++;
+		else if (charlen >= 5)
+			/* 5-6bytes UTF-8 */
+			i += 2;
 	}
 
 	/* properly null-terminate string */
@@ -307,6 +347,9 @@ int smbConvertToUTF16(__le16 *target, co
 	char src_char;
 	__le16 dst_char;
 	wchar_t tmp;
+	wchar_t wchar_to[6];	/* UTF-16 */
+	int ret;
+	unicode_t u;
 
 	if (!mapchars)
 		return smb_strtoUTF16(target, source, srclen, cp);
@@ -349,11 +392,57 @@ int smbConvertToUTF16(__le16 *target, co
 			 * if no match, use question mark, which at least in
 			 * some cases serves as wild card
 			 */
-			if (charlen < 1) {
-				dst_char = cpu_to_le16(0x003f);
-				charlen = 1;
+			if (charlen > 0)
+				goto ctoUTF16;
+
+			/* convert SURROGATE_PAIR */
+			if (strcmp(cp->charset, "utf8"))
+				goto unknown;
+			if (*(source + i) & 0x80) {
+				charlen = utf8_to_utf32(source + i, 6, &u);
+				if (charlen < 0)
+					goto unknown;
+			} else
+				goto unknown;
+			ret  = utf8s_to_utf16s(source + i, charlen,
+					UTF16_LITTLE_ENDIAN,
+					wchar_to, 6);
+			if (ret < 0)
+				goto unknown;
+
+			i += charlen;
+			dst_char = cpu_to_le16(*wchar_to);
+			if (charlen <= 3)
+				/* 1-3bytes UTF-8 to 2bytes UTF-16 */
+				put_unaligned(dst_char, &target[j]);
+			else if (charlen == 4) {
+				/*
+				 * 4bytes UTF-8(surrogate pair) to 4bytes UTF-16
+				 * 7-8bytes UTF-8(IVS) divided to 2 UTF-16
+				 * (charlen=3+4 or 4+4)
+				 */
+				put_unaligned(dst_char, &target[j]);
+				dst_char = cpu_to_le16(*(wchar_to + 1));
+				j++;
+				put_unaligned(dst_char, &target[j]);
+			} else if (charlen >= 5) {
+				/* 5-6bytes UTF-8 to 6bytes UTF-16 */
+				put_unaligned(dst_char, &target[j]);
+				dst_char = cpu_to_le16(*(wchar_to + 1));
+				j++;
+				put_unaligned(dst_char, &target[j]);
+				dst_char = cpu_to_le16(*(wchar_to + 2));
+				j++;
+				put_unaligned(dst_char, &target[j]);
 			}
+			continue;
+
+unknown:
+			dst_char = cpu_to_le16(0x003f);
+			charlen = 1;
 		}
+
+ctoUTF16:
 		/*
 		 * character may take more than one byte in the source string,
 		 * but will take exactly two bytes in the target string


