Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9569B14BFA2;
	Sun,  7 Sep 2025 20:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276275; cv=none; b=PvODqiLZSed1sDbhw4W1EacSC79A31dR7m4+TxuAIu8Diy6mv4K39asAXWAIBefIyaBp0DEqCS+VFK07Rr/8Rg+m5IVhLYrudHr//dik9wOnND+bp9MPNvGXhzBeJFukMF5u8pf5aQke9c+Bje8jmOzf7GytpaTZQ3r9HoVjLc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276275; c=relaxed/simple;
	bh=P0F6xxlV7Yoag49kvrpzB/O4vUVO1FX2s4ZvTjso9PI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClE9Us/BSa4J2d/v9UTw9EmyHZTJFKzr5jaMvvZKH+9LPdPGTMR/coBT48NvM6LPb8do/8tZjRoABeijM84/NwCPEK5hp3U2wzRZUDLtkRvxbOLVZeJcdC07Hdfmgal9Pk5GJ5HdzGMdADbEUX/ZYANFhy+UDBM0NnGYtVXbowE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1MhYUfTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1MhYUfTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67C4C4CEF0;
	Sun,  7 Sep 2025 20:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276275;
	bh=P0F6xxlV7Yoag49kvrpzB/O4vUVO1FX2s4ZvTjso9PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1MhYUfTp8MVCK2IXrB3rJBCi4iOAHJh2vW05bwupo6zfLyfXpTE3XZyWxEhWtlMQD
	 FRiPCKIiPlHq9UjX9VBK3YoZxLlSGWcz4gdV9joCn+3E0Tpod+GCrwmsCAVezIKeKK
	 aeEq4jmot0/iCv3kcRj+or5f3lMWTH/smMPqyfrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Makar Semyonov <m.semenov@tssltd.ru>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 051/104] cifs: prevent NULL pointer dereference in UTF16 conversion
Date: Sun,  7 Sep 2025 21:58:08 +0200
Message-ID: <20250907195609.012822604@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -619,6 +619,9 @@ cifs_strndup_to_utf16(const char *src, c
 	int len;
 	__le16 *dst;
 
+	if (!src)
+		return NULL;
+
 	len = cifs_local_to_utf16_bytes(src, maxlen, cp);
 	len += 2; /* NULL */
 	dst = kmalloc(len, GFP_KERNEL);


