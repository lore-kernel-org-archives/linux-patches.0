Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F934C63B;
	Wed, 20 Dec 2023 16:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVbPkQpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6DBC433C8;
	Wed, 20 Dec 2023 16:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088757;
	bh=l6AdyH8qUnkqDP8fQSTmen5SBC16zGolF+62xq9Lzco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVbPkQpb8COnjDU4X5tpS7M6g7M59pAmSuSxSolMjaiaOocSNUXfXEM9C+aZlMeJE
	 cuWreMwa79nGHptV/SqBN0i7rjiVTJEh/u2cRSK8LmaJLM3WEDI88ufg6DIR8HMb4l
	 kRy2ZwxxxJlXSxvrwHflxITStLa4vbgeIaDr5aj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 047/159] ksmbd: remove unnecessary generic_fillattr in smb2_open
Date: Wed, 20 Dec 2023 17:08:32 +0100
Message-ID: <20231220160933.515662291@linuxfoundation.org>
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

[ Upstream commit c90b31eaf9e77269d3803ed9223a2e0168b519ac ]

Remove unnecessary generic_fillattr to fix wrong
AllocationSize of SMB2_CREATE response, And
Move the call of ksmbd_vfs_getattr above the place
where stat is needed because of truncate.

This patch fixes wrong AllocationSize of SMB2_CREATE
response. Because ext4 updates inode->i_blocks only
when disk space is allocated, generic_fillattr does
not set stat.blocks properly for delayed allocation.
But ext4 returns the blocks that include the delayed
allocation blocks when getattr is called.

The issue can be reproduced with commands below:

touch ${FILENAME}
xfs_io -c "pwrite -S 0xAB 0 40k" ${FILENAME}
xfs_io -c "stat" ${FILENAME}

40KB are written, but the count of blocks is 8.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3095,12 +3095,6 @@ int smb2_open(struct ksmbd_work *work)
 	list_add(&fp->node, &fp->f_ci->m_fp_list);
 	write_unlock(&fp->f_ci->m_lock);
 
-	rc = ksmbd_vfs_getattr(&path, &stat);
-	if (rc) {
-		generic_fillattr(user_ns, d_inode(path.dentry), &stat);
-		rc = 0;
-	}
-
 	/* Check delete pending among previous fp before oplock break */
 	if (ksmbd_inode_pending_delete(fp)) {
 		rc = -EBUSY;
@@ -3187,6 +3181,10 @@ int smb2_open(struct ksmbd_work *work)
 		}
 	}
 
+	rc = ksmbd_vfs_getattr(&path, &stat);
+	if (rc)
+		goto err_out;
+
 	if (stat.result_mask & STATX_BTIME)
 		fp->create_time = ksmbd_UnixTimeToNT(stat.btime);
 	else
@@ -3202,9 +3200,6 @@ int smb2_open(struct ksmbd_work *work)
 
 	memcpy(fp->client_guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
 
-	generic_fillattr(user_ns, file_inode(fp->filp),
-			 &stat);
-
 	rsp->StructureSize = cpu_to_le16(89);
 	rcu_read_lock();
 	opinfo = rcu_dereference(fp->f_opinfo);


