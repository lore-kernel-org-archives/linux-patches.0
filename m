Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463CF46525;
	Wed, 20 Dec 2023 16:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgoIXW+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB44C433C7;
	Wed, 20 Dec 2023 16:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088893;
	bh=MsG8Cbiw5/DMWa3I5pY/L1ynV2/2TtW8i4NFf504vMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgoIXW+EQsCqUJoaHHBLG/WJTg2Ht9nj70zWN45SZLl/+H7yIkkdb4GgKghcCa4zv
	 oOLvtYpqn7lgOOuRTsPlH3e7AfDV1rHrSRLul47UWNirxkLDM74fJiFCYJc+cPfTV+
	 eyFDRF9XYF3NBinIBaXleMsUHC1p+hdqGX5Wbai4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marios Makassikis <mmakassikis@freebox.fr>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 067/159] ksmbd: Fix resource leak in smb2_lock()
Date: Wed, 20 Dec 2023 17:08:52 +0100
Message-ID: <20231220160934.489973485@linuxfoundation.org>
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

[ Upstream commit 01f6c61bae3d658058ee6322af77acea26a5ee3a ]

"flock" is leaked if an error happens before smb2_lock_init(), as the
lock is not added to the lock_list to be cleaned up.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6907,6 +6907,7 @@ int smb2_lock(struct ksmbd_work *work)
 		if (lock_start > U64_MAX - lock_length) {
 			pr_err("Invalid lock range requested\n");
 			rsp->hdr.Status = STATUS_INVALID_LOCK_RANGE;
+			locks_free_lock(flock);
 			goto out;
 		}
 
@@ -6926,6 +6927,7 @@ int smb2_lock(struct ksmbd_work *work)
 				    "the end offset(%llx) is smaller than the start offset(%llx)\n",
 				    flock->fl_end, flock->fl_start);
 			rsp->hdr.Status = STATUS_INVALID_LOCK_RANGE;
+			locks_free_lock(flock);
 			goto out;
 		}
 
@@ -6937,6 +6939,7 @@ int smb2_lock(struct ksmbd_work *work)
 				    flock->fl_type != F_UNLCK) {
 					pr_err("conflict two locks in one request\n");
 					err = -EINVAL;
+					locks_free_lock(flock);
 					goto out;
 				}
 			}
@@ -6945,6 +6948,7 @@ int smb2_lock(struct ksmbd_work *work)
 		smb_lock = smb2_lock_init(flock, cmd, flags, &lock_list);
 		if (!smb_lock) {
 			err = -EINVAL;
+			locks_free_lock(flock);
 			goto out;
 		}
 	}


