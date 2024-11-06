Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE471E0DFD;
	Wed,  6 Nov 2024 12:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897479; cv=none; b=qMKN9AeH9qg3T9Z3LK/sU/i8oDjQTyKQzMtTToLXJYedjRenmrr+V2Jye5ALEOqDi72I16h/GetCjXD2OEuJ7moyNQ4nyDpv6vevsQkeMXNtRJGp7gNSs9jWh16+HPQRBYX3Dtg/HQVWJ4ickO/aJxldClCZ+mG/dK7Lnw5BDL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897479; c=relaxed/simple;
	bh=dJXWUmJbxhBRZCsOWEg49sMt9tyYHBbHiMC7wf3gens=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dxWxDceRSuKP0+GcmhyRVih6NWqZYmaJO/eOxAOCusS8dmVKKjAVUSUDuxxwqZAdM/aT+wY1ZyLvFuF9xJ4e3mPnGdKWvQ0UZm9CeUTzZ575gD5PAfRsQcjymxsvE0OG9FL6zhg+XVVzw9gRpR+TyleVbxtNBk7HAJcfKf3NTqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fjw/pkqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fjw/pkqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53349C4CECD;
	Wed,  6 Nov 2024 12:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897479;
	bh=dJXWUmJbxhBRZCsOWEg49sMt9tyYHBbHiMC7wf3gens=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fjw/pkqSPxxUEYOxG/pWmJXG52Nomzdk/9ppBFPZEQuzlOL8UNtgT5xKFz+tpRA8E
	 BiRM1AP+mC48iiIGamxAujEFyOebQeSw0/JwJ9SW+j/Br14LrSnfHYfD11gHRAFd3f
	 vtIa6CGf2bfEmYE3E9sPiPyJntRXgpzlIx+tXQG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/151] cifs: Fix creating native symlinks pointing to current or parent directory
Date: Wed,  6 Nov 2024 13:04:14 +0100
Message-ID: <20241106120310.653616292@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 63271b7d569fbe924bccc7dadc17d3d07a4e5f7a ]

Calling 'ln -s . symlink' or 'ln -s .. symlink' creates symlink pointing to
some object name which ends with U+F029 unicode codepoint. This is because
trailing dot in the object name is replaced by non-ASCII unicode codepoint.

So Linux SMB client currently is not able to create native symlink pointing
to current or parent directory on Windows SMB server which can be read by
either on local Windows server or by any other SMB client which does not
implement compatible-reverse character replacement.

Fix this problem in cifsConvertToUTF16() function which is doing that
character replacement. Function comment already says that it does not need
to handle special cases '.' and '..', but after introduction of native
symlinks in reparse point form, this handling is needed.

Note that this change depends on the previous change
"cifs: Improve creating native symlinks pointing to directory".

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifs_unicode.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifs_unicode.c b/fs/smb/client/cifs_unicode.c
index 79d99a9139441..4cc6e0896fad3 100644
--- a/fs/smb/client/cifs_unicode.c
+++ b/fs/smb/client/cifs_unicode.c
@@ -484,10 +484,21 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
 			/**
 			 * Remap spaces and periods found at the end of every
 			 * component of the path. The special cases of '.' and
-			 * '..' do not need to be dealt with explicitly because
-			 * they are addressed in namei.c:link_path_walk().
+			 * '..' are need to be handled because of symlinks.
+			 * They are treated as non-end-of-string to avoid
+			 * remapping and breaking symlinks pointing to . or ..
 			 **/
-			if ((i == srclen - 1) || (source[i+1] == '\\'))
+			if ((i == 0 || source[i-1] == '\\') &&
+			    source[i] == '.' &&
+			    (i == srclen-1 || source[i+1] == '\\'))
+				end_of_string = false; /* "." case */
+			else if (i >= 1 &&
+				 (i == 1 || source[i-2] == '\\') &&
+				 source[i-1] == '.' &&
+				 source[i] == '.' &&
+				 (i == srclen-1 || source[i+1] == '\\'))
+				end_of_string = false; /* ".." case */
+			else if ((i == srclen - 1) || (source[i+1] == '\\'))
 				end_of_string = true;
 			else
 				end_of_string = false;
-- 
2.43.0



