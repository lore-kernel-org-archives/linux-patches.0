Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E6E1607B7;
	Wed,  5 Feb 2025 14:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766914; cv=none; b=FY9wSygmuhVWmomXeHweuNUOINP/i8EDTzYpxjT/346l/XEMCeDhVwn7XH3IwbV26yE2f1TTUUASM4pCMmnkrLlilncrTcaNK2rmxpdy7+tGr+tldBaWQ6bAGZcXeb+Fzv8ZPJIQ2Cd2HrGGziMLfm3gxJb8ZFQl6WvxFjF1jnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766914; c=relaxed/simple;
	bh=/GeyDP+vAZI2hgD5Q83v85JgQ2F8DnxNhyzQ0ViRBjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IdT8QPdUiIk2gGs9LLZHDH9Y3xDKTTGARILSFGgE5r50+wwozrfRuvwDLGBErJDNHx1K/OdjstbkOpaoUNZdoymrm5SUmIf3faXaUbyEFpsDe5J1cwnRNWg9bMvkJsVMnSUwPBWSdxOHLEd0/YWFHoQuFdI4ugUNxVvFWt0EaN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRVwGNTF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRVwGNTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F5EC4CED1;
	Wed,  5 Feb 2025 14:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766914;
	bh=/GeyDP+vAZI2hgD5Q83v85JgQ2F8DnxNhyzQ0ViRBjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PRVwGNTFmuULLKLnKbR/M7gWuSbQ7RFCDo49AgQr5h3L/1ZxC0kuIRHdj7165Lwcp
	 vR/aTFFWDOVXWxCeqyT1p2msNCoWnj60WufsFg1uawZbZuM8G+oM2h6fvlLtXqhMDh
	 +Umu43C31AfxQvzg95mTcEZdaLXgs8eCfUjZjNew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 328/623] cifs: Use cifs_autodisable_serverino() for disabling CIFS_MOUNT_SERVER_INUM in readdir.c
Date: Wed,  5 Feb 2025 14:41:10 +0100
Message-ID: <20250205134508.772530929@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 015683d4ed0d23698c71f2194f09bd17dbfad044 ]

In all other places is used function cifs_autodisable_serverino() for
disabling CIFS_MOUNT_SERVER_INUM mount flag. So use is also in readir.c
_initiate_cifs_search() function. Benefit of cifs_autodisable_serverino()
is that it also prints dmesg message that server inode numbers are being
disabled.

Fixes: ec06aedd4454 ("cifs: clean up handling when server doesn't consistently support inode numbers")
Fixes: f534dc994397 ("cifs: clear server inode number flag while autodisabling")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/readdir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 273358d20a46c..50f96259d9adc 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -413,7 +413,7 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 		cifsFile->invalidHandle = false;
 	} else if ((rc == -EOPNOTSUPP) &&
 		   (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SERVER_INUM;
+		cifs_autodisable_serverino(cifs_sb);
 		goto ffirst_retry;
 	}
 error_exit:
-- 
2.39.5



