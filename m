Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C9247252B;
	Tue, 21 Jul 2026 20:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665420; cv=none; b=NywNfy0YQVrqC4vM2UNJ4g/u4JynnMRjCGtRAT9mv+mNxD523pKoU6jfLtAmPk4xUg1rCpiwHwYBclsjtjzzc4yibprcxrT5eLjuY6KDMzwqUwya1bleiJmPI2CsyUnmLQGStSfoB88z2GbdLwwURZ2fksaEuvHcb2TYAkHDSt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665420; c=relaxed/simple;
	bh=YbT1DIt3/M2+/Xs4DNbNCanw9wC+GxzMWR0tN05nvnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHVrnqqtnLyPaLQvSU0mZ4NYuhAZBI172+xuZQrqqSloL86Y0uCioc12unWPfoqc2I8NZ5XmCa+dhg8tLvd/KAuK1jaa7eCsIUAvwmHMoZ1bS4VHpbJ2X2Y6ZIJZLiSMCSmMObDgJmTnFIf5pKlsqHpdESuywOdHBnVLjPYjPag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qCu34kcM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qCu34kcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99BF1F000E9;
	Tue, 21 Jul 2026 20:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665419;
	bh=8gZ9/QX+h+hxSckT3hWFcydGVF7Bk47aH9yLtZcclQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qCu34kcMVEXWCx4myZBhERziGhqfAiWgtux1jalIHlIU7bcJU25cND4L+BN7YPXC9
	 0OVZ9+/SORISqkAWj9aszfbw/6J03p6fqNGFVYVn2HaazWlPiKHVtcRYvcifzvEUiQ
	 wxjyl3HzD0xmxHC+OxW63EH74/xdY41gpUNzVCD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Bryam Vargas <hexlabsecurity@proton.me>
Subject: [PATCH 6.6 0297/1266] exfat: bound uniname advance in exfat_find_dir_entry()
Date: Tue, 21 Jul 2026 17:12:14 +0200
Message-ID: <20260721152448.472150580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1081,6 +1081,7 @@ rewind:
 
 			if (entry_type == TYPE_EXTEND) {
 				unsigned short entry_uniname[16], unichar;
+				unsigned int offset;
 
 				if (step != DIRENT_STEP_NAME ||
 				    name_len >= MAX_NAME_LENGTH) {
@@ -1089,13 +1090,15 @@ rewind:
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


