Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B2438910F;
	Tue, 21 Jul 2026 18:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659912; cv=none; b=aFrrRAfmDUd2DAK/51Ub6DObhX7k9tEvCJiR+upIwoY97gvjJuAWyM3+ykYo787iD11EkDviHn5GVeHeQ3hloNWuTaA+xSKwXJezi7baVzUHpUhSWJZxTFhzbzudMOpZSs9Y3lLEfk+QGQ51FscCmf+wjO9+o4LOF1ydXwrKa+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659912; c=relaxed/simple;
	bh=zA7uY+a/Bi7Dntewt6Sfoy/Md5V+cKlRyO2WTZlOucU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4UESIhAfe2TB/pNwfPHwl/fta+tMH/dYEm96yc6FMBEQFU3PD+Kf6X0ESu5DRXan0gWX4gFpKwSHeCi/Zd+rbqzRXS8Zs+5arR8EkAA6sxYDdV8hbpZWLGLioHl8GFvpvV06alLBpOQn3O3LCL1iau+WE7dN0HBgWSIOokQCz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZgpp9vc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZgpp9vc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F041F000E9;
	Tue, 21 Jul 2026 18:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659911;
	bh=qxlm0LhtUIUQsXlFbNFOSt933MCKCeJ0NZTWh3FDKsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cZgpp9vcinXst+e2mEF7JEmmqeRmK/ECWdhF2iVJmWIsLChz3P6CUOfXN0HTNI35c
	 v8tbczVuigaOGKP0seHpTzQAd8suE1OV/Q+mg7qsrEejbSbqXRSXnsZOOqOkSFBU4i
	 IlRUhkr70Rgh7AUFDQQoV0roqffarsC7Z17l9XtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0778/2077] smb/client: always return a value for FS_IOC_GETFLAGS
Date: Tue, 21 Jul 2026 17:07:31 +0200
Message-ID: <20260721152611.148401326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 17408bb8ab65bf..746d70091f3d1d 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -392,13 +392,11 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
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



