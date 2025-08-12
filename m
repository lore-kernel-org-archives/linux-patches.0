Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DA93F9D2;
	Tue, 12 Aug 2025 18:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023086; cv=none; b=u9opLjzpOGKktinnRbOZzMDZM+Mjy0wYifWLfHhEN2383NjIIIEjsHQt96bSCNUqkJa3ABmj8r+fKKlNuD9q4vmBI4ObczQz3869worB4GXKY3FsuTFnk9BQ5XqNDqiocS3nQgBEFRj9f6XVg31FxkVo2p5Ay51xAvdAK9VIsXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023086; c=relaxed/simple;
	bh=kaShhwmS2hx7D3HftjzwXhiai6Fg+bi073vcWOt5lS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cULLKfVHzUUJ55FlT50niK/hdgQC7GJ80OTWo+xAZG2fT8YIw81rNrnPlMQRTQXpmYbW7k0d3jYV80rOfdc+d7QT35FZvCx77hGk3QaRjkQOKZinqDfv1FyoTKIsP7Mjr9rKAqHof0lvZ4VyFvKcUK4/bev+VMH/0qhMDG8YROs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6kXwIlF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6kXwIlF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B6DC4CEF0;
	Tue, 12 Aug 2025 18:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023086;
	bh=kaShhwmS2hx7D3HftjzwXhiai6Fg+bi073vcWOt5lS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6kXwIlFFvh9qKIzibdO62glRy4kLz7BijUeinun9tNi9E8oGuLPK8dgnkrbG4Wnc
	 TQ8vazGfPX81IGZ/ZO7HnZkVkhy6Y8IyxqJKX8FmqSiUnJaeKvS5ETQa1Owe7o8ANk
	 wc2afsWNi8JjcnAt46GQHJmNoqV0/L5LPnU3qJwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 345/369] smb: server: Fix extension string in ksmbd_extract_shortname()
Date: Tue, 12 Aug 2025 19:30:42 +0200
Message-ID: <20250812173029.673326279@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


