Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826975;
	b=Ff+Rnomh4fPju7J6AAWWLDVtNDUM+Ez2hfb44N13uwieIbksRjSuLzStdUPW0zLRtOjX
	 T/darKCUTsnB8r427MmrZxNE9ImfTkKdgr3ezMIQrCh7wb8KJAh1jkwoNoRnD5fZxexu6
	 z9ikK6zdId6QDrhqnsqKEZDkNBgm6dbuYcJP+BuYQR7huWqyJutEJFdwFlCaEV4oVGKmv
	 IXy06FVEATMAIBV4KT00cux37kxgVmbkFlh4rdyJxdeR9UpR92Al5zMdrfeSM8Z7HAS+D
	 SJhApS/Z7ekQWhw7rARypWUtVHVGXzbWHsGXBmLt2S2vuHgL5A2p7KK97ETK4Td+BRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826975;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZtB9Gl1/2QqhS40vdSRBMmazDXPZ2opYSHc1oPCsLtQ=;
	b=E43PI0luO6OUctg+zWHpM56EjhG7VYGVOxY+5TeHPbY8uKILJOoSi3Pe7yHu/XzlVMsd
	 ssHIjHeFNGjoAO29xjXUr2NOw1c3jdaZwklPFKC10N6J5PG5Z+FnqwlU19Jepc8JBInix
	 YZytUWCt/VB0NeFBdDldcn9SEBjGMn/NRofIflFP+z2GkFaxnRgnR8GnLZHOPrq3UeaWx
	 OfcOdkbNgAoedjkXFk8oc6YeEkRhxAaV3Y0pRFYhHdg1bAd8jO73NTVlYSrZVJeQuZc0p
	 ZDAdQ7kTcZsbaN2YksnB4iotXq2SwLGL/qBf5aws9mMw8GsP4KA++dIQRw1kc3smmhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJFklqLU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864486070AAB;
	Wed,  4 Nov 2026 21:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJFklqLU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21ED21F000C1;
	Wed,  4 Nov 2026 21:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826975;
	bh=ZtB9Gl1/2QqhS40vdSRBMmazDXPZ2opYSHc1oPCsLtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJFklqLUaCWkF/XWNlR7UtxhgVIVnG2ZX0v/C6GWB1bFDs5uy8MuG5zXc4dRWVsy/
	 bJEVCQqHXMF1LgGB/5RYRv5d6+kpd1dbMKr5utAIWDGcW9pd0CajNSw14hO4Tlxjbf
	 VL44OxUDNlrx92E0KZCHyOhIOeGyToYosMz+9Qhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dairui Zhang <zhangdairui@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 119/547] ksmbd: fix OOB read and cross-share confusion in ksmbd_validate_name_reconnect()
Date: Wed,  4 Nov 2026 16:05:03 -0500
Message-ID: <20261104211041.577122683@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dairui Zhang <zhangdairui@gmail.com>

commit 783a7fc454991544bf92268d8f2413af1a7c7eb8 upstream.

ksmbd_validate_name_reconnect() indexes
ab_pathname[share->path_sz + 1] without checking that the path is
longer than share->path_sz + 1 (d_path() fills the buffer from the
end). A durable fp is not bound to its original share, so a client
can preserve a file from a short-path share and reconnect it on a
long-path share, making strcmp() read past the PATH_MAX buffer -
with a long enough share path this oopses the kernel, and on a
mapped page it also gives a byte-equality oracle on adjacent heap
(the reconnect succeeds exactly when the out-of-bounds string
equals the requested name). A same-share variant with the durable
fp at the share root reads 1 byte past the buffer
(strlen(ab_pathname) == share->path_sz).

Check before comparing: the path must be longer than share->path_sz,
it must start with share->path, and the next character must be '/'.
The share root itself is accepted only for an empty name.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Reported-by: Dairui Zhang <zhangdairui@gmail.com>
Assisted-by: LLM
Cc: stable@vger.kernel.org
Signed-off-by: Dairui Zhang <zhangdairui@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs_cache.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1877,9 +1877,21 @@ int ksmbd_validate_name_reconnect(struct
 		return -EACCES;
 	}
 
-	if (name && strcmp(&ab_pathname[share->path_sz + 1], name)) {
-		ksmbd_debug(SMB, "invalid name reconnect %s\n", name);
-		ret = -EINVAL;
+	if (name) {
+		size_t len = strlen(ab_pathname);
+
+		if (len == share->path_sz && !strncmp(ab_pathname, share->path, len)) {
+			/* the durable fp is the share root itself */
+			if (name[0])
+				ret = -EINVAL;
+		} else if (len <= share->path_sz ||
+			   strncmp(ab_pathname, share->path, share->path_sz) ||
+			   ab_pathname[share->path_sz] != '/' ||
+			   strcmp(&ab_pathname[share->path_sz + 1], name)) {
+			ret = -EINVAL;
+		}
+		if (ret)
+			ksmbd_debug(SMB, "invalid name reconnect %s\n", name);
 	}
 
 	kfree(pathname);


