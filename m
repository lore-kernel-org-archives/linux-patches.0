Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591055;
	b=Ny1E6//u8S8vNKma3uSt/JfcKyM9Jl6NVpQk3lUnze7XtC4LNgsD2hemrYIZNhNIW7WT
	 c67X6SgjOcqcNN5kDLbffOSE+lwDxorNQZLl8YtbndG3IwyP5wsnB7BC+y1o1LYN/B3OE
	 NLXkirYtF30wnVJFduhbsPv40sRnB/nsnuQa7Z8iyyY1BkyhOozXEGe9li9GJGPzhKIDa
	 Fiy5RP+LiAtNVvWATCvNonzdeVGi1OYwArasilCN6pB/H0cG+pfBGUQGtKK0d8ptfp+lJ
	 3iYIGPrXZ+nyyBIxL0g71pGt+uNxTh4eciT+SEqKumVHD8sJyp+RBgHhaPVluOiN8rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zen1VRN459VLjnlI96CH5nkk83SBTkQ+kbNmMVG1yJU=;
	b=Ops7UVil2JxVfaHsUEXnoSucC+Pkiu/bF+Ocy4eVgh7ENOrmzK5b7pa40678SXlKyg6i
	 SPkNHJkTyvq8txVt/XOjNov+FemW3pbmMFE9nm51706w+AFuQ7GCa6ZnfZhcD+At0raR/
	 KSKVtXU4XidrL+lFN5KT9cr3pX8bDSg6EYHCUME7Uy93ECQQIVE3VZhIEwHAarRTFWwVF
	 plAruPWgpralQlQXKTlQ9oRJFluG1vfB3kOJ3zdR0fJRnAXfk1JWu293cVmzYOdz23XTZ
	 tTwu+ETn4cpqsKOk2dPxkHR2iqHeOHvaBfhcqnTkT79J6WIygapWtXfv4MDDv4g6yvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AFhI/Of+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76701606A8AF;
	Fri, 13 Nov 2026 17:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AFhI/Of+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2227E1F000C5;
	Fri, 13 Nov 2026 17:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591055;
	bh=zen1VRN459VLjnlI96CH5nkk83SBTkQ+kbNmMVG1yJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AFhI/Of+N9TBxbJxZwVmYJvXSQC81mDVAXP9I86bIUXAGLj3NzCGHq2+Tx+lEoD0Q
	 pQ0OnatzPrGshUd1FUuW8sBbMSzjt+JRZf6PEjac+oAjGOJCfGLAfPakdABxhwxPmW
	 C58TaHGMFFVSvVrTtL4MvGRpbZ5XWhD2l1OpfEhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 217/670] ksmbd: require DELETE access for delete-on-close opens
Date: Fri, 13 Nov 2026 10:46:21 -0500
Message-ID: <20261113153819.259827120@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1ed32310c73a5..f7e3d7986c4ca 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3180,6 +3180,14 @@ int smb2_open(struct ksmbd_work *work)
 				req->CreateOptions = ~(FILE_NO_COMPRESSION_LE);
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
@@ -3359,6 +3367,13 @@ int smb2_open(struct ksmbd_work *work)
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



