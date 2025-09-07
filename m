Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B321F63CD;
	Sun,  7 Sep 2025 20:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277829; cv=none; b=eC+8idjeDD2/vowUBf8knxrEtTmnDJuZmXoDNJMpd6GtXFlE8z9WE/+1cs0eQlknib2jwW19Dt+CBNpt/6qELj+LsgMjBdAni20bzGANTpdhymnjcCMW/hTdkPb+fSPdWTJZG7wqioHe+DzfbLrKvaYtHTQnt+qUPxJQlCzCBEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277829; c=relaxed/simple;
	bh=SGmjffX5fuhUk1osPn5fUmhQgzZdLH7cE47dPbTQUFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O++bum15O5PnSHgzKH5jyyvhXWkEXRfhfBuFLH4ZbLprAjwWDq7If98hJMiqSk/t72oUr2wytDMcdmPH8+i4o6uRzmUmvbxmKxn5YUDxpsfHNOw6Xy+gR7hN5vNNqb94ilLnblcPLLavqeokjcg646JLwpl7T+xjj9bKjjz54/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9Axsujq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9Axsujq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBB0C4CEF0;
	Sun,  7 Sep 2025 20:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277829;
	bh=SGmjffX5fuhUk1osPn5fUmhQgzZdLH7cE47dPbTQUFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9AxsujqDMtwN2RW+6GNGfyhg3Tr5cVzT5C/L4hKN4sZk61BJ2OvCP/cyqLaepcee
	 RzmB9k0uZAGeJGscEkFpxFdjs+/LjzdmXE2r480vc1jSOdqV+8efAe+DeAWSYKjMm1
	 EcPLeQNtg/kncQtoHtXPb4hWx17ly1nq4cnRTE+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Makar Semyonov <m.semenov@tssltd.ru>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.16 136/183] cifs: prevent NULL pointer dereference in UTF16 conversion
Date: Sun,  7 Sep 2025 21:59:23 +0200
Message-ID: <20250907195619.024272252@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Makar Semyonov <m.semenov@tssltd.ru>

commit 70bccd9855dae56942f2b18a08ba137bb54093a0 upstream.

There can be a NULL pointer dereference bug here. NULL is passed to
__cifs_sfu_make_node without checks, which passes it unchecked to
cifs_strndup_to_utf16, which in turn passes it to
cifs_local_to_utf16_bytes where '*from' is dereferenced, causing a crash.

This patch adds a check for NULL 'src' in cifs_strndup_to_utf16 and
returns NULL early to prevent dereferencing NULL pointer.

Found by Linux Verification Center (linuxtesting.org) with SVACE

Signed-off-by: Makar Semyonov <m.semenov@tssltd.ru>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifs_unicode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/smb/client/cifs_unicode.c
+++ b/fs/smb/client/cifs_unicode.c
@@ -629,6 +629,9 @@ cifs_strndup_to_utf16(const char *src, c
 	int len;
 	__le16 *dst;
 
+	if (!src)
+		return NULL;
+
 	len = cifs_local_to_utf16_bytes(src, maxlen, cp);
 	len += 2; /* NULL */
 	dst = kmalloc(len, GFP_KERNEL);


