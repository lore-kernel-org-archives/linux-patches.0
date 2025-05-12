Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B19255E52;
	Mon, 12 May 2025 17:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072648; cv=none; b=QqwuiCKf127TQJdkGPta/4hR6uN7CI1fz3/joplC8iO09SGRHGGz9Jxx5omwKXkFqTEdJJB0/+QWvglWlsya+JHQIBqmtKoNtpMMIbDHTXk7aeMgrolm4IesQskv6Y3BWkGHmdfb0evJfm3w76vm+yXgVXthMtd0n7/Hem33xtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072648; c=relaxed/simple;
	bh=OZfyvdc32MVQGcfdoBOSWLZI2thSGIHJh3Ubp1qzhGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBBLYXAMKrnQmAuorfhsXjyTyrcsTZvemimxWDmMO985Uo4BGngVtw9UjN1NejiitO4go4IaE9UqW0WOlJUtjT1hOhLUquHbaSaYa+sfnSwbgqKK7gW7iPp1EIsl3d7kpM6QMlcZQaNjCFf7Sr/XEKtSqvwwIM5hp9SFCwkLyX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5NE7TyK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5NE7TyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5997EC4CEE7;
	Mon, 12 May 2025 17:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072648;
	bh=OZfyvdc32MVQGcfdoBOSWLZI2thSGIHJh3Ubp1qzhGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5NE7TyKhjGWuzPwke+eWul4QUaPGcqHlEm/0+cCw5aaiKQyjj5MmpRxkuf16hC0o
	 CdSlzcXRNQ8aqypqW4rGRqLr3dLJi5gSbLyIIDT9odXQrTdCR1fTb2FVRPf70TaG8E
	 Ocg1P/4r0cwLtHJvu0Gf/LX/fOjbleof95Z20r6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 014/184] ksmbd: prevent out-of-bounds stream writes by validating *pos
Date: Mon, 12 May 2025 19:43:35 +0200
Message-ID: <20250512172042.255305206@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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


