Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABB344AB91;
	Tue, 21 Jul 2026 22:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673374; cv=none; b=t5vMIrl56jRVDrOJAeDOBhu8jgvEAFFhA3X4bAMU2hrbbvbOjdY/TjLnbqfEEATWWelpy2E6YOlOhuWg4BdjI/GAKfPWJ8ivfal5pZRY1jKkc95xxrCn6UgklsYPIO4LR3jORQ4anPgeOLX/dY2uG4RtHqLMn8l+I4FA1ohCB2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673374; c=relaxed/simple;
	bh=Y4NLaC/+IrBZIotZdIRB602hrWho0W+D1ntyeSej6i4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awm/qsypYxiKxfn60Jc9Fjb4ru7s4Z4eWyH3hKvI3Uh19oCPoEHxB+JZV4h7vWg9Tbo5W5ke45MXZlx8+0dQy/hqRA26GnAiYmuQ+KGzlRCAD97YTOGVW3loq/76iazvZL7FDptMzYv+WUAYcH4YAGjNrs0TVBVJpbWcBbolMtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4qS446Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4qS446Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804CF1F00A3A;
	Tue, 21 Jul 2026 22:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673373;
	bh=2XwkPwn7N0wDgSfhUKgzdDdrSAjrUNmoLRdpD6Wdw7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4qS446Qb6re7XDq4vPBJjLz16K7YCkr17QMH+FHwgl6JKHJFJUtY5gV4lIroIOOF
	 0QBYfw+c0L3vHf5edMRpND3kwK/LlKf4FlOQ7yvsWbQwPAHJY5+jGJxCfqhipou22b
	 mOcAvrKYW46JuHpT5sPpSqwd+2iYachmcH1N5f+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Bryam Vargas <hexlabsecurity@proton.me>
Subject: [PATCH 5.10 139/699] exfat: bound uniname advance in exfat_find_dir_entry()
Date: Tue, 21 Jul 2026 17:18:18 +0200
Message-ID: <20260721152358.844446200@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 3a1230e7b043c62737b05a3e9275ca83a43ad20a upstream.

In exfat_find_dir_entry(), each TYPE_EXTEND (file name) entry advances the
output pointer by a fixed amount while the loop guard only tracks the
accumulated name length:

	if (++order == 2)
		uniname = p_uniname->name;
	else
		uniname += EXFAT_FILE_NAME_LEN;
	len = exfat_extract_uni_name(ep, entry_uniname);
	name_len += len;
	unichar = *(uniname+len);
	*(uniname+len) = 0x0;

uniname grows by EXFAT_FILE_NAME_LEN (15) per name entry, but name_len
grows only by the actual extracted length, which is shorter when a name
fragment contains an early NUL.  The only guard is
`name_len >= MAX_NAME_LENGTH`, so a crafted directory with many short
name fragments lets uniname run far past the
p_uniname->name[MAX_NAME_LENGTH + 3] buffer while name_len stays small,
causing an out-of-bounds read and write at *(uniname+len).

The sibling extractor exfat_get_uniname_from_ext_entry() already stops
on a short fragment (the lockstep `len != EXFAT_FILE_NAME_LEN` guard
added in commit d42334578eba ("exfat: check if filename entries exceeds
max filename length")); exfat_find_dir_entry() never got the
equivalent.  Track the per-entry write offset as a count and reject a
fragment once the offset, or the offset plus the extracted length, would
exceed MAX_NAME_LENGTH, before forming the output pointer.

Fixes: ca06197382bd ("exfat: add directory operations")
Cc: stable@vger.kernel.org
Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/dir.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -1045,6 +1045,7 @@ rewind:
 
 			if (entry_type == TYPE_EXTEND) {
 				unsigned short entry_uniname[16], unichar;
+				unsigned int offset;
 
 				if (step != DIRENT_STEP_NAME ||
 				    name_len >= MAX_NAME_LENGTH) {
@@ -1053,13 +1054,15 @@ rewind:
 					continue;
 				}
 
-				if (++order == 2)
-					uniname = p_uniname->name;
-				else
-					uniname += EXFAT_FILE_NAME_LEN;
-
+				offset = (++order - 2) * EXFAT_FILE_NAME_LEN;
 				len = exfat_extract_uni_name(ep, entry_uniname);
 				brelse(bh);
+				if (offset > MAX_NAME_LENGTH ||
+				    len > MAX_NAME_LENGTH - offset) {
+					step = DIRENT_STEP_FILE;
+					continue;
+				}
+				uniname = p_uniname->name + offset;
 				name_len += len;
 
 				unichar = *(uniname+len);


