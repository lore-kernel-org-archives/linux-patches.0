Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E73D1BDE9;
	Wed,  3 Jan 2024 16:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJPLB7D0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8F6C433C7;
	Wed,  3 Jan 2024 16:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704300999;
	bh=3JHHzKlza9vAIpVEG6tgBC+UhrFduPlcTfLW4ySPIbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJPLB7D0VITF1SMkKg28QgOHMwYl+TTxr7SgfhDpjaULKO+PHiRocdz+lzgm4GlqO
	 n7RVad+pcz0/wkR15JkL8NbJkNdc2VT5j/ydEu8ug9QzOO6KuSYxmLCxwMa9u2k+3m
	 DnJUpTsAh28fmfWa09gdNvpTY/tLCgdjm+BNAW6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marios Makassikis <mmakassikis@freebox.fr>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/100] ksmbd: Fix resource leak in smb2_lock()
Date: Wed,  3 Jan 2024 17:53:53 +0100
Message-ID: <20240103164856.876704481@linuxfoundation.org>
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

From: Marios Makassikis <mmakassikis@freebox.fr>

[ Upstream commit 01f6c61bae3d658058ee6322af77acea26a5ee3a ]

"flock" is leaked if an error happens before smb2_lock_init(), as the
lock is not added to the lock_list to be cleaned up.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 554214fca5b78..21d0416f11012 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6951,6 +6951,7 @@ int smb2_lock(struct ksmbd_work *work)
 		if (lock_start > U64_MAX - lock_length) {
 			pr_err("Invalid lock range requested\n");
 			rsp->hdr.Status = STATUS_INVALID_LOCK_RANGE;
+			locks_free_lock(flock);
 			goto out;
 		}
 
@@ -6970,6 +6971,7 @@ int smb2_lock(struct ksmbd_work *work)
 				    "the end offset(%llx) is smaller than the start offset(%llx)\n",
 				    flock->fl_end, flock->fl_start);
 			rsp->hdr.Status = STATUS_INVALID_LOCK_RANGE;
+			locks_free_lock(flock);
 			goto out;
 		}
 
@@ -6981,6 +6983,7 @@ int smb2_lock(struct ksmbd_work *work)
 				    flock->fl_type != F_UNLCK) {
 					pr_err("conflict two locks in one request\n");
 					err = -EINVAL;
+					locks_free_lock(flock);
 					goto out;
 				}
 			}
@@ -6989,6 +6992,7 @@ int smb2_lock(struct ksmbd_work *work)
 		smb_lock = smb2_lock_init(flock, cmd, flags, &lock_list);
 		if (!smb_lock) {
 			err = -EINVAL;
+			locks_free_lock(flock);
 			goto out;
 		}
 	}
-- 
2.43.0



