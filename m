Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585452;
	b=5RxhC1I+vIajz80X++QQsdBdU3OoyBpTJQtFrhbTw/ySFcI7INMAzxASB/7JcPxM9vz+
	 9w0L/i5jgr3D1k14Yl2y+wBLnO+vQnuqTMxQ1EsqWoeHq0wQg1wLX5ZXmn+eoawuhPOUF
	 BPyort95m0pgqeE3Yeb8SXzyxn25uiEwgHJAnoX9n2NWVeoo2wKJQgqY+87MjJQCBd4vR
	 o31PdxwCqIKTh368cxcowuRclpn/5K+NzyJD0YjKEj+K8Rlk+pbqKmBlNMZ9KmAwOy3d+
	 BzGIBitny71omw/Xv17+5TOmYTOPpmetD94LWBjqzvSypq7/+TIUzRRAkw2c96OTupA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ykhd6fnqspNTObM+C5lUr8+arYHEkVdsxL5oggKbg1o=;
	b=ulqCgGl96iVk8uC+z94/PoXNV+8Zue1wi6thhuuq9tGCE1TlhTVpkwaLZkQ8lzaABot/
	 MjmBtkETbbVb1Gwd0RUezLCxGk4cUkdhIrtFIs4evpOrbLjWtxxaBY2X3w5uUH5B1nHHv
	 2NjIXQ6bto9sKRbAZryr9FUE5ZzJ2mMXefts556wzZdcFPlod4oZQEr8rQfyU5qER7mny
	 7xgB3yx2Z6nSZipGJrrRnBr7wU2W1t2kQ6ACCiKO408TtUZvVc/b5p4rwjRqxJuY/O646
	 JbWj2N9U02uAnF+B9mPXFxwczSM/0hxhIvX4FQKulxh9PIaHvt9DoQGwS2ImYPuRhDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VH3Gy5uT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E4A60A5BFD;
	Fri, 13 Nov 2026 15:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VH3Gy5uT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919541F000C4;
	Fri, 13 Nov 2026 15:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585451;
	bh=ykhd6fnqspNTObM+C5lUr8+arYHEkVdsxL5oggKbg1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VH3Gy5uTyWFGyJSIKMsqhZgET69E20+JbD0djYta936ig9LWxxSG/dAP2/fAprF0h
	 3+GF8WP2kLgfAJtfXFYX650vsX5uOfAJtmViNhK/CL8QwItTPsupagSnVy0meRn7Wz
	 yVIRAKajhZMpzRQE1jPbICydCgwo/dcxWqmJ4aoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 111/507] ksmbd: require DELETE access for delete-on-close opens
Date: Fri, 13 Nov 2026 10:46:55 -0500
Message-ID: <20261113153758.086305427@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit 1dd91081ba3c692565f9c1f884149178d5a06d1e ]

smb2_open() accepts FILE_DELETE_ON_CLOSE on an existing file without
DELETE in DesiredAccess. When the request asks only for
FILE_READ_ATTRIBUTES or READ_CONTROL, it also skips inode_permission()
and the parent directory MAY_WRITE | MAY_EXEC check that delete-on-close
is meant to get. The file is then marked for deletion by a caller who
could not delete it.

The unlink happens later, in __ksmbd_inode_close(), when the last handle
on the inode is closed, and it runs with the credentials of that handle.
If the caller closes last, the unlink fails. If another user who can
write the parent directory, such as the file's owner, still has the file
open, the file is deleted when that user closes it. Until then new opens
of the file fail with STATUS_DELETE_PENDING. So a user with only search
permission on a directory can delete a file in it, or block opens of it,
while the owner has it open.

A MAXIMUM_ALLOWED open that also requests DELETE has the same problem.
The requested access is replaced with the maximal access, which does not
include DELETE when the caller cannot write the parent directory, and the
later permission checks are skipped as already done.

MS-FSA 2.1.5.1 requires an open with FILE_DELETE_ON_CLOSE and without
DELETE in DesiredAccess to fail with STATUS_INVALID_PARAMETER, and Samba
does the same. Add that check to the CreateOptions validation, using
the generic-mapped DesiredAccess so that GENERIC_ALL still qualifies.
This also refuses MAXIMUM_ALLOWED with FILE_DELETE_ON_CLOSE but no
explicit DELETE, as MS-FSA and Samba do. When MAXIMUM_ALLOWED is
requested with DELETE but the maximal access does not include DELETE,
fail with STATUS_ACCESS_DENIED. With DELETE requested, delete-on-close
opens go through the existing parent directory check.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 30549a02ccfb2..b740be1030f57 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4508,6 +4508,14 @@ int smb2_open(struct ksmbd_work *work)
 				goto err_out2;
 			}
 		}
+
+		/* MS-FSA 2.1.5.1: delete-on-close requires DELETE access */
+		if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE &&
+		    !(smb_map_generic_desired_access(req->DesiredAccess) &
+		      FILE_DELETE_LE)) {
+			rc = -EINVAL;
+			goto err_out2;
+		}
 	}
 
 	if (le32_to_cpu(req->CreateDisposition) >
@@ -4777,6 +4785,13 @@ int smb2_open(struct ksmbd_work *work)
 		maximal_access = daccess;
 	}
 
+	/* MAXIMUM_ALLOWED may not have granted the requested DELETE */
+	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE &&
+	    !(daccess & FILE_DELETE_LE)) {
+		rc = -EACCES;
+		goto err_out;
+	}
+
 	open_flags = smb2_create_open_flags(file_present, daccess,
 					    req->CreateDisposition,
 					    &may_flags,
-- 
2.53.0



