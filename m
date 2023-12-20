Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8D74D12C;
	Wed, 20 Dec 2023 16:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NzKMB4mK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EDEEC433CB;
	Wed, 20 Dec 2023 16:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088814;
	bh=2oV9YntNQK1HmueDpUfK0OEVvYS/YN9B78zvTUGyIog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NzKMB4mK7eTfIO94W1AXkVQICEqY6IFGXqoNtZFFzl/G5HazjxT2yCkn9Q1AkC2hF
	 ZmCN4Gxbb9QaZw/Z6jVyPe8/zwm+F55JNl7L1T0+FX6+ruCa57bjNDNshrM9okHm4Z
	 ljqgZywFEqiRQZl39PqvYAEmKkG5jumCAFXnIamI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marios Makassikis <mmakassikis@freebox.fr>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 069/159] ksmbd: send proper error response in smb2_tree_connect()
Date: Wed, 20 Dec 2023 17:08:54 +0100
Message-ID: <20231220160934.586666574@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marios Makassikis <mmakassikis@freebox.fr>

[ Upstream commit cdfb2fef522d0c3f9cf293db51de88e9b3d46846 ]

Currently, smb2_tree_connect doesn't send an error response packet on
error.

This causes libsmb2 to skip the specific error code and fail with the
following:
 smb2_service failed with : Failed to parse fixed part of command
 payload. Unexpected size of Error reply. Expected 9, got 8

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1969,13 +1969,13 @@ int smb2_tree_connect(struct ksmbd_work
 	if (conn->posix_ext_supported)
 		status.tree_conn->posix_extensions = true;
 
-out_err1:
 	rsp->StructureSize = cpu_to_le16(16);
+	inc_rfc1001_len(work->response_buf, 16);
+out_err1:
 	rsp->Capabilities = 0;
 	rsp->Reserved = 0;
 	/* default manual caching */
 	rsp->ShareFlags = SMB2_SHAREFLAG_MANUAL_CACHING;
-	inc_rfc1001_len(work->response_buf, 16);
 
 	if (!IS_ERR(treename))
 		kfree(treename);
@@ -2008,6 +2008,9 @@ out_err1:
 		rsp->hdr.Status = STATUS_ACCESS_DENIED;
 	}
 
+	if (status.ret != KSMBD_TREE_CONN_STATUS_OK)
+		smb2_set_err_rsp(work);
+
 	return rc;
 }
 


