Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4137D3B47E5;
	Tue, 21 Jul 2026 20:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666189; cv=none; b=TL6ZECfbG8EeTCExRTK8PxzDN7aZPM4MJ/HCoaEKz+ax1gGPsu7ICgtfrZ02t6iYE6G+KtZx/vA5werSCrKhHHMC8m07NWp1as5DnqIEqedR5qzrT0Ms0sEDJxhCcaQivdtRbapGGvfkCEevoYiqJvveTGNL8h2ILOZfjqhLA3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666189; c=relaxed/simple;
	bh=IaFT373W2QwRz7zlivnELc2eOcSreOMgJOaN5x5JzhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myUe10cJ1+n99Ekkjmyj9ndJtvWfah6jAeD1No8N7AQ5gUnJ3hK5YeZpUuOhKLL9e4AtHKP1PWtBEydfV2UYgE+Nw7D/4AZLX1Q0TXL1F8nzU9wGYcoTwrY3ThI7NnYGFVFtixV7bG58NsiJl/RHJWtppqwzIb2zV43xNPEgfWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGf26+1Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGf26+1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EB61F000E9;
	Tue, 21 Jul 2026 20:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666188;
	bh=Y1n7MRdX/mjKZ29fR6uUdjcry833MRkV0Zn352MKjTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uGf26+1YsGxGumjg/4M3QKhnMCfcwCFqmPygLr/56K/3PBJqd7r6EHywFECpzcfo+
	 Hk1DEEeTkN5iPzNZ2qReXn4X8aKJ9Arnkt0AvoITQrYRcxaq820eDOWKHAGDV+g/P2
	 b80vS59QtZKWT8gkz0I8B/0FsvdXv9mrtfkxMyYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0587/1266] smb/client: always return a value for FS_IOC_GETFLAGS
Date: Tue, 21 Jul 2026 17:17:04 +0200
Message-ID: <20260721152455.000330954@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huiwen He <hehuiwen@kylinos.cn>

[ Upstream commit 7acbaa16b99edaf8ef432229d4b7a6f3b666767d ]

Currently, repeated lsattr calls on a regular CIFS file without the
compressed attribute may show random flags:

	$ touch test.bin
	$ lsattr test.bin
	s-S-ia-A-EjI---------m test.bin
	$ lsattr test.bin
	------d-cEjI---------m test.bin

The lsattr reproducer depends on the previous contents of its userspace
buffer, so it may not reproduce on every setup. A deterministic
reproducer is to initialize the ioctl argument before FS_IOC_GETFLAGS
on a file without the compressed attribute:

        int flags = 0x7fffffff;
        ioctl(fd, FS_IOC_GETFLAGS, &flags);

On an affected kernel, flags remains 0x7fffffff. With the fix, it is
set to 0.

This happens because when the cached inode does not have the compressed
bit set, the CIFS fallback path in FS_IOC_GETFLAGS returns success
without calling put_user() to write the zero flags value into the user
buffer. As a result, the caller observes stale contents from its own
buffer.

Fix this by always writing the visible flags value back to the user
buffer before returning success, even when the value is zero.

Fixes: 64a5cfa6db94 ("Allow setting per-file compression via SMB2/3")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/ioctl.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index 8ea532cdc4302b..8a668b827570a4 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -376,13 +376,11 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 			}
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 #endif /* CONFIG_CIFS_POSIX */
-			rc = 0;
-			if (CIFS_I(inode)->cifsAttrs & ATTR_COMPRESSED) {
-				/* add in the compressed bit */
-				ExtAttrBits = FS_COMPR_FL;
-				rc = put_user(ExtAttrBits & FS_FL_USER_VISIBLE,
-					      (int __user *)arg);
-			}
+			if (CIFS_I(inode)->cifsAttrs & FILE_ATTRIBUTE_COMPRESSED)
+				ExtAttrBits |= FS_COMPR_FL;
+
+			rc = put_user(ExtAttrBits & FS_FL_USER_VISIBLE,
+				      (int __user *)arg);
 			break;
 		case FS_IOC_SETFLAGS:
 			if (pSMBFile == NULL)
-- 
2.53.0



