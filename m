Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590269;
	b=2xw2eWRgsNqXRL/P9dN5lUKmuQEFVRus9YtYqa+80aQrCrYjd9+Ot+LAlSQXYuKHMZ7v
	 monVQ2QnHYcP9zAlpragpVMFOE+Si15g3JFZeAEp0xxbQmZs4fdq4QmJyeu71n0t2/F9+
	 meU1gHfpI8Ki0JWg4yEJjVkM5S5nFllbiWTjieMbt0S8V2+AjaNRYtFy4/KQHkThUppCu
	 Gq1mLnLfcM3gDuovdl4yxqlJYyscLUBDARrRGSHNXlrwSRe61vBjzWuPYf9NKOSYlyDhH
	 srsucp4IFzpxt+6yfbLGWuZdkKu7wjNsXIfS7hbVWyP5+t/nL0YQBT+ZUUHPBd5UBYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2n2Mg/1+gvIL/sD0vgdhdqoVN2n5YPRqHW2PlBXKdrA=;
	b=GoQL85HTrKiCtvnEbeXxZ+NLLWbFNo1dYrZw2JDQ1OxfReMfxGiqLz65yhtnOwG6ICjd
	 TlhOvdvkVa1PLvF1RCOEBUEBLzSlHtknHdMg1WuSJIMiziiKVl/+5z5aKfc++yYY2po2X
	 r956439FT6ZbQuxiXO900dTFw0XPztCWInq6mZ0AcPHWtw5oOj3MvyDb/v5z8AGH6wt0W
	 nNLJ9AF1Bv+YueV5aNknmwfTWz3jJH+x8KLZdJoNiQki6UnwTu9J9Gf96KuFNUe6W1o4w
	 pPWXijO8gGoXQuh37BrIlig+F0ai3y5Umz0MUaNqBoCgfeEHJVbgFDUecX1aQdsp5yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mdt7lykc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D16060A5BD0;
	Fri, 13 Nov 2026 17:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mdt7lykc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD97D1F000C5;
	Fri, 13 Nov 2026 17:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590269;
	bh=2n2Mg/1+gvIL/sD0vgdhdqoVN2n5YPRqHW2PlBXKdrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mdt7lykcjKcy0yZ25spspxkH+okKxwKju8BpaLMT3pm+n8wNIgZDvJlA8BU+e4quB
	 gxkUFUHPtJGBysxH62eRSkRiRaP52mHhn5gIiJE0TJ7sHqLjjPW1d8LFs20rxZ6p9p
	 xXx/RPxIPh0mW8UYkyqgFqkt91clC87SRFzi94wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 260/686] ext2: preserve completed DIO bytes when buffered fallback fails
Date: Fri, 13 Nov 2026 10:46:33 -0500
Message-ID: <20261113153829.838818884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit cbf04dde8b3c5a7e043e91cefad68b8980ea0d18 ]

ext2_dio_write_iter() can complete part of a direct write before
falling back to buffered I/O for a hole inside i_size. If
generic_perform_write() then fails, its error overwrites the completed
direct-I/O byte count.

For example, on a full filesystem, an 8 KiB write to a file with an
allocated 4 KiB prefix and a 4 KiB hole overwrites the prefix but returns
ENOSPC and leaves the file position unchanged. GNU dd with oflag=direct
consequently reports zero bytes written.

Preserve a positive direct-I/O result and return the buffered error
when no bytes were direct-written. This restores the fallback policy of
generic_file_write_iter(), which ext2 used before its iomap conversion.

Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Link: https://patch.msgid.link/20261102061555.55183-1-dennylin0707@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index c59c19e5ff72b..81f9cf3b884ce 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -256,7 +256,8 @@ static ssize_t ext2_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		pos = iocb->ki_pos;
 		status = generic_perform_write(iocb, from);
 		if (unlikely(status < 0)) {
-			ret = status;
+			if (!ret)
+				ret = status;
 			goto out_unlock;
 		}
 
-- 
2.53.0



