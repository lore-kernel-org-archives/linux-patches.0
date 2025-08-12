Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC333217736;
	Tue, 12 Aug 2025 18:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021839; cv=none; b=LmYD/8eFLlTnI78ROj6K4IiJZH0Y6CxFRLBwNy4NvN5XRqHByeMNJOsj05brASdXBYuHcB29463/jVshDE1FFkaNgyG0F3uzUyKd1GtyynV5fMwThbpUeJrGr5PkIFj5/mkLaNE2PQzfqioLtjAs4EwgXad0myTB0kfL/zEf3hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021839; c=relaxed/simple;
	bh=mraxedJmANSE7TGDeZov1zWNkyn6EQWLswH0t0tCDo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNzixV7KaspmoXCam9wbzubBaIhvHu2gXsKaU7B8GY4w2m4vfJHP1my4uBtWOISFjx8x8qkHZDN2tVDwooF4tUNbnITVAf476dMV/gTzKSm4Jyt9S8C0AxjUEfxq9AuBBwuWhMMdgcxJ4nVAsg3kE2373JJPtTexg6YBHgvapF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hgNGdNA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hgNGdNA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9B9C4CEF0;
	Tue, 12 Aug 2025 18:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021839;
	bh=mraxedJmANSE7TGDeZov1zWNkyn6EQWLswH0t0tCDo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgNGdNA84Q4VWKVRnJTwDlPx3WL4aVAunPgEFomTwJNfaCVt4OJ75v2Z40kqT3XpW
	 MGGPFMwO5cn1Qnmht1KBovWUI1FEgohjMe1eXY2w/V2oLZiqJKLtMYG3VQDYw1fzO0
	 p5tVGIdEZTYLdfRTTIcf9tz8eGettdMIuw6xxcqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 241/262] smb: server: Fix extension string in ksmbd_extract_shortname()
Date: Tue, 12 Aug 2025 19:30:29 +0200
Message-ID: <20250812173003.413719296@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 8e7d178d06e8937454b6d2f2811fa6a15656a214 upstream.

In ksmbd_extract_shortname(), strscpy() is incorrectly called with the
length of the source string (excluding the NUL terminator) rather than
the size of the destination buffer. This results in "__" being copied
to 'extension' rather than "___" (two underscores instead of three).

Use the destination buffer size instead to ensure that the string "___"
(three underscores) is copied correctly.

Cc: stable@vger.kernel.org
Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -515,7 +515,7 @@ int ksmbd_extract_shortname(struct ksmbd
 
 	p = strrchr(longname, '.');
 	if (p == longname) { /*name starts with a dot*/
-		strscpy(extension, "___", strlen("___"));
+		strscpy(extension, "___", sizeof(extension));
 	} else {
 		if (p) {
 			p++;


