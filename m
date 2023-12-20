Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCF64A9B6;
	Wed, 20 Dec 2023 16:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyEZuLPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862C7C433C8;
	Wed, 20 Dec 2023 16:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088743;
	bh=/W/RdHLWN699GX9ok1lpYYe1v/7qqZU7qG5Y4ds+RXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IyEZuLPvD3h+EyNbbj1EOUlA36kQnpzMe7MajzURWflrg7+VKTjuaW7IYYG5XXI2Q
	 AstfL6XQiOFLKxB5gMnRn/4/qkhagIItDpslaG/aJdDtcgDwgu1B9uFja6iTz1i1qH
	 kqgs6Soo2Ub+Y7V9Lo11O9dhJqa289wXxDSj56vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 043/159] ksmbd: remove duplicate flag set in smb2_write
Date: Wed, 20 Dec 2023 17:08:28 +0100
Message-ID: <20231220160933.318317744@linuxfoundation.org>
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

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 745bbc0995c25917dfafb645b8efb29813ef9e0b ]

The writethrough flag is set again if is_rdma_channel is false.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6564,6 +6564,7 @@ int smb2_write(struct ksmbd_work *work)
 		goto out;
 	}
 
+	ksmbd_debug(SMB, "flags %u\n", le32_to_cpu(req->Flags));
 	if (le32_to_cpu(req->Flags) & SMB2_WRITEFLAG_WRITE_THROUGH)
 		writethrough = true;
 
@@ -6577,10 +6578,6 @@ int smb2_write(struct ksmbd_work *work)
 		data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
 				    le16_to_cpu(req->DataOffset));
 
-		ksmbd_debug(SMB, "flags %u\n", le32_to_cpu(req->Flags));
-		if (le32_to_cpu(req->Flags) & SMB2_WRITEFLAG_WRITE_THROUGH)
-			writethrough = true;
-
 		ksmbd_debug(SMB, "filename %pd, offset %lld, len %zu\n",
 			    fp->filp->f_path.dentry, offset, length);
 		err = ksmbd_vfs_write(work, fp, data_buf, length, &offset,


