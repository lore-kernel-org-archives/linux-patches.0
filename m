Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C51537757A;
	Sat, 12 Sep 2026 09:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204420; cv=none; b=mcUyDh7XyIRDTR4zj94Mrsi2VB2XtE/0PkSjQdPuhxNQeeTQIjSSYHGFtbw2A+43P3ndfG1P1oBw/HVF5Yl6FReTCIYdzlc6Ep6/XQcj2BQFs0RrtGv13dT3PXQVNu52gjOwt0xhALWXjdDIkeMpKh9aRws2CGf6HygGPhI3Mww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204420; c=relaxed/simple;
	bh=DBFmxOzKVQOjSZCVk18d8xbOyD74KJqZoRZGKDnRK4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYIdd0csjqssWqZftU3PS+kEHpRBRSGZOPlXFjqyP7P+J1D6ncB5pKft/jUy3vrxAGZUd2YT6XdPlN80MCPbmBjPFnnHZ8IMoWOP2r8o+M4z/m/FlJpR71fKXYjXzpKmUXG1SR5ndZTs33MozJzWDM/xBmIbbZlnyvP5myOpyDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sMFYMZlz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sMFYMZlz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBFB1F000FF;
	Sat, 12 Sep 2026 09:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204419;
	bh=EomYtZd8eY9kFbn24DnXC5arS/d5uc+OC6p7xz/qPus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sMFYMZlzkl3xTRO7DMymoXWNuZHuyCDTUFxlTFAylVjJRzUIwkAPt+wozt6TKygK3
	 tf5GlHSDWOa0JMB4ujpv0Ql2je0o5wGgL9HV3ZLyWvu8wavyV4NVZvGAMaUDJmFshb
	 467lvBkCT4A7Ccl5JEUKPDeB6GX2ghSUZvzMfiBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1610/1815] ntfs: apply Windows name checks only with windows_names
Date: Sat, 12 Sep 2026 08:56:00 +0200
Message-ID: <20260912065726.789197762@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 71feaa7686fb9cc08fc81c8a09d120b6204b51a0 ]

The windows_names mount option is documented to reject names containing
characters forbidden by Windows. However, ntfs_check_bad_windows_name()
unconditionally rejects those characters before checking the mount option.

Move the character validation after the option check so a default NTFS
mount accepts POSIX names such as names containing ':'. Mounts using
windows_names retain the existing Windows-compatible validation, including
reserved device names and trailing spaces or dots.

Fixes: af0db57d4293 ("ntfs: update inode operations")
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/namei.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
index cd403b1d99eed..aee7aabaf0598 100644
--- a/fs/ntfs/namei.c
+++ b/fs/ntfs/namei.c
@@ -61,12 +61,12 @@ static int ntfs_check_bad_windows_name(struct ntfs_volume *vol,
 				       const __le16 *wc,
 				       unsigned int wc_len)
 {
-	if (ntfs_check_bad_char(wc, wc_len))
-		return -EINVAL;
-
 	if (!NVolCheckWindowsNames(vol))
 		return 0;
 
+	if (ntfs_check_bad_char(wc, wc_len))
+		return -EINVAL;
+
 	/* Check for trailing space or dot. */
 	if (wc_len > 0 &&
 	    (wc[wc_len - 1] == cpu_to_le16(' ') ||
-- 
2.53.0



