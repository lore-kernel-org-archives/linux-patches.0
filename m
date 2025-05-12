Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09B71E2602;
	Mon, 12 May 2025 17:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071748; cv=none; b=Ty8uSdvlqkxPA9U7Uz5xrqIcAUWU2FnPYfGRzOM/mKF/Jnd5sahNG3V3dMOO8Qgb1AFhRwYdVIXB2gK0vJZ7eLlMD0+4GskKeMJqzS6gcbcnWZ3J/PnMmrl4TnRQmOnW1ZDRjpUgYGHFv8VKOnfo/Sa8idjs+etNFDRtr2chUKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071748; c=relaxed/simple;
	bh=JSH4Dt/mRutdKrGWRCBJctXwrUEhet74U+Z8GL2XLo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=joqoMIwfSkNOhCA6es4iYwqmQc4vCnksxrL1M+z7HUQo3xndMjp7dDsApVwODhSTeoJQV+CVk7x98+CWPxkWvdRajhzMPVg8/2LCHoN+nEXGhVqwKrOXqPbKELqvYur0nqYOLUGya8Gl/4a95iqsYdyNEILMTbht4v+agZpy0Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qq9fJKVr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qq9fJKVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68393C4CEE7;
	Mon, 12 May 2025 17:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071747;
	bh=JSH4Dt/mRutdKrGWRCBJctXwrUEhet74U+Z8GL2XLo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qq9fJKVrRg9aPw/J3cOlPufpke/4MQzkDBAAzVAKP/ghtTg8OvaVJT/cUOu3VJKuk
	 U4uUbul0B+4GIaGGt8BOzILRGh490Nmw46KaHgKCPjvCHb9YL1ltKAE+UyvB8uWan5
	 RZBD2xXxkY7ohYTXVcaf8KgCqhZE3ApNUaYZpe6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.14 014/197] ksmbd: prevent out-of-bounds stream writes by validating *pos
Date: Mon, 12 May 2025 19:37:44 +0200
Message-ID: <20250512172044.925701323@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

commit 0ca6df4f40cf4c32487944aaf48319cb6c25accc upstream.

ksmbd_vfs_stream_write() did not validate whether the write offset
(*pos) was within the bounds of the existing stream data length (v_len).
If *pos was greater than or equal to v_len, this could lead to an
out-of-bounds memory write.

This patch adds a check to ensure *pos is less than v_len before
proceeding. If the condition fails, -EINVAL is returned.

Cc: stable@vger.kernel.org
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -443,6 +443,13 @@ static int ksmbd_vfs_stream_write(struct
 		goto out;
 	}
 
+	if (v_len <= *pos) {
+		pr_err("stream write position %lld is out of bounds (stream length: %zd)\n",
+				*pos, v_len);
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (v_len < size) {
 		wbuf = kvzalloc(size, KSMBD_DEFAULT_GFP);
 		if (!wbuf) {


