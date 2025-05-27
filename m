Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F4D27933A;
	Tue, 27 May 2025 17:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366404; cv=none; b=dHHl3ePBT2/jSTrEeL2zjE05TI2qkpjG+tfbfca7ymilyizbNZnRv6h3CXxY9y0BEe5lnmYvvgWLIUcBqdWnB7BjL6z6xLHods53ZiQHr2gz4LgsiUFVR1XE6VDPbULzewv9swGkKpVP3mykTUez55QCsrh+e7wB3lIwwjxNGwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366404; c=relaxed/simple;
	bh=1j6uI++PlvSUmYOscqfKh9cLHd6Tx6e7UzWYpTlVN3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DQtmXF/EGFKhfM9mOkxEstvF1eJAVFCyfXGDyfZqLnRioHwxihMj9RFQ4kBMoFL1EY07a0ca+kl5TznK24BsDvHSfmKedwvS3lodgZlG1vDq4L794xhYKIVs/xIUgK6z9d6O6Svcp9+SDsWwkZllOpezeTzTMrYk6dJ45NbK6Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uqLb7SpE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqLb7SpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01DCC4CEE9;
	Tue, 27 May 2025 17:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366404;
	bh=1j6uI++PlvSUmYOscqfKh9cLHd6Tx6e7UzWYpTlVN3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uqLb7SpEh/ifLdx/aFjbx6ZRqS+TPVTz0G2nSaj5eJBGQ/dOfksT9yRVVFRJ/t6MO
	 u120v//8wQDZ4VDPIadOrZvstFMRc0QgcDLD/LXlhtlbySuedPYMPW2uTNGe/6HFF7
	 wAStLv9fVRy6gG3fz4qyz72IMNManBKt91rZOfc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 049/783] cifs: Fix access_flags_to_smbopen_mode
Date: Tue, 27 May 2025 18:17:26 +0200
Message-ID: <20250527162515.129333820@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 6aa9f1c9cd09c1c39a35da4fe5f43446ec18ce1e ]

When converting access_flags to SMBOPEN mode, check for all possible access
flags, not only GENERIC_READ and GENERIC_WRITE flags.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 4fc9485c5d91a..c2abe79f0dd3b 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1038,15 +1038,31 @@ static __u16 convert_disposition(int disposition)
 static int
 access_flags_to_smbopen_mode(const int access_flags)
 {
-	int masked_flags = access_flags & (GENERIC_READ | GENERIC_WRITE);
-
-	if (masked_flags == GENERIC_READ)
-		return SMBOPEN_READ;
-	else if (masked_flags == GENERIC_WRITE)
+	/*
+	 * SYSTEM_SECURITY grants both read and write access to SACL, treat is as read/write.
+	 * MAXIMUM_ALLOWED grants as many access as possible, so treat it as read/write too.
+	 * SYNCHRONIZE as is does not grant any specific access, so do not check its mask.
+	 * If only SYNCHRONIZE bit is specified then fallback to read access.
+	 */
+	bool with_write_flags = access_flags & (FILE_WRITE_DATA | FILE_APPEND_DATA | FILE_WRITE_EA |
+						FILE_DELETE_CHILD | FILE_WRITE_ATTRIBUTES | DELETE |
+						WRITE_DAC | WRITE_OWNER | SYSTEM_SECURITY |
+						MAXIMUM_ALLOWED | GENERIC_WRITE | GENERIC_ALL);
+	bool with_read_flags = access_flags & (FILE_READ_DATA | FILE_READ_EA | FILE_EXECUTE |
+						FILE_READ_ATTRIBUTES | READ_CONTROL |
+						SYSTEM_SECURITY | MAXIMUM_ALLOWED | GENERIC_ALL |
+						GENERIC_EXECUTE | GENERIC_READ);
+	bool with_execute_flags = access_flags & (FILE_EXECUTE | MAXIMUM_ALLOWED | GENERIC_ALL |
+						GENERIC_EXECUTE);
+
+	if (with_write_flags && with_read_flags)
+		return SMBOPEN_READWRITE;
+	else if (with_write_flags)
 		return SMBOPEN_WRITE;
-
-	/* just go for read/write */
-	return SMBOPEN_READWRITE;
+	else if (with_execute_flags)
+		return SMBOPEN_EXECUTE;
+	else
+		return SMBOPEN_READ;
 }
 
 int
-- 
2.39.5



