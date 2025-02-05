Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985E77DA6A;
	Wed,  5 Feb 2025 14:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766234; cv=none; b=r6IvRstFp0P45/xPwZ8srGKBEbD9JLO2vWbsOWlW2SzSOQgFZpFEfOqnjRaGjn/SeBCIK39TAAH2rxgU1n4M34XVZHByX+O99mvqOIMu036/JPU8QzOrb5WZpvjcwj3/8RS6rzLDTXkTZ7sQRe8grD15QuWjUwc9fFP/R8LZvDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766234; c=relaxed/simple;
	bh=aaRHTCQ/sI5zEOiCiq7Sx511z8OKP19ATsFG4XZ4NJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jv5I7T/MVmjk7p1o2R2CW5Gxx1+k3UBgKsSz27fSvpYGPaO9uSvhxcMb0zgcdN9UMRzMuGnLisn5tagtGdbyDxq2jD3vfdlhWgOxRBStKHZUHEPVw3/ipZ2V/8TOV0ss12g5WMd4vYZi5IaFxgRK8oDKiEInUamg1S+wdpGfYgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gKQu1XrK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gKQu1XrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079F2C4CED1;
	Wed,  5 Feb 2025 14:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766234;
	bh=aaRHTCQ/sI5zEOiCiq7Sx511z8OKP19ATsFG4XZ4NJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gKQu1XrK+tVq4py/eyBulWCG7b43DvhlzfdxvY0IDBn1/YmxER+z8IY9h12vgLCC4
	 2RycjoozGvHrLD/tQcojUuleXwdzAY8iiRPHMaQsR75XpLDsTqtm4/rUEk2uvCrNXI
	 LA4/ULr4KP9CH3fehrK0esOYLWyGV3delD2rrux8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 299/590] cifs: Use cifs_autodisable_serverino() for disabling CIFS_MOUNT_SERVER_INUM in readdir.c
Date: Wed,  5 Feb 2025 14:40:54 +0100
Message-ID: <20250205134506.716201861@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



