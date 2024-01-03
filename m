Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2431BDE9;
	Wed,  3 Jan 2024 17:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BiTUyPJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4273C433C8;
	Wed,  3 Jan 2024 17:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301250;
	bh=HDpA83TgHifyQkuwCSXjNBvWRm63IxEi3RvcIAmCx24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BiTUyPJed7TJObFwzA6RyFcVnRszq90qsTyCis7EMFyCPnFu6jT/EVjiXD4vMe67L
	 P/ERxtsUBR2Boi+MaKFvt7BbUoj07Jx70qWWJxHGQOwbp2HNf14A3zkp+0jB2UozRQ
	 n2QHYzi+Ytxe4KImk8HJ9fkoI9qIwnbTcwCoyAxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Coverity Scan <scan-admin@coverity.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/100] ksmbd: fix Null pointer dereferences in ksmbd_update_fstate()
Date: Wed,  3 Jan 2024 17:54:39 +0100
Message-ID: <20240103164903.586640025@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 414849040fcf11d45025b8ae26c9fd91da1465da ]

Coverity Scan report the following one. This report is a false alarm.
Because fp is never NULL when rc is zero. This patch add null check for fp
in ksmbd_update_fstate to make alarm silence.

*** CID 1568583:  Null pointer dereferences  (FORWARD_NULL)
/fs/smb/server/smb2pdu.c: 3408 in smb2_open()
3402                    path_put(&path);
3403                    path_put(&parent_path);
3404            }
3405            ksmbd_revert_fsids(work);
3406     err_out1:
3407            if (!rc) {
>>>     CID 1568583:  Null pointer dereferences  (FORWARD_NULL)
>>>     Passing null pointer "fp" to "ksmbd_update_fstate", which dereferences it.
3408                    ksmbd_update_fstate(&work->sess->file_table, fp, FP_INITED);
3409                    rc = ksmbd_iov_pin_rsp(work, (void *)rsp, iov_len);
3410            }
3411            if (rc) {
3412                    if (rc == -EINVAL)
3413                            rsp->hdr.Status = STATUS_INVALID_PARAMETER;

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Reported-by: Coverity Scan <scan-admin@coverity.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs_cache.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index f600279b0a9ee..38f414e803adb 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -602,6 +602,9 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 void ksmbd_update_fstate(struct ksmbd_file_table *ft, struct ksmbd_file *fp,
 			 unsigned int state)
 {
+	if (!fp)
+		return;
+
 	write_lock(&ft->lock);
 	fp->f_state = state;
 	write_unlock(&ft->lock);
-- 
2.43.0



