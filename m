Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CD0377A92;
	Sat, 17 Oct 2026 16:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254963; cv=none; b=FEw2F/pu/6yDyqaAX5p2gu+khhkH9oLQLBtnmeQ/KgHlFVsGmyRPdZANrBhrGvfn6bjAWyhmLnDQGh3YFGxf7LW0cm78achLFcBI7UBAUpvaRMsXCpClS/+IWD9bMEz2IDSmZ9ktnhXzpUIJ5nBdSGkJUXXfaf7w9SOB/0jU3oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254963; c=relaxed/simple;
	bh=KLavV9dhZKSaFBMsdw+diUEe/xH6/ETSapbDempsvUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/HFvNzExbsIyKf5/6uMP7wYZCvf/SSDTdgAHNBmxWD/q92a2TSDsExYtm80DgaPwcChOt5O/l6/odG9hkcjKryYQA1T7w9gMbQ7eT05Twn19bBhO07C42Yk1ynmLTWB/ZC5Bak+3RKOY9mYtuffMMoieNeTqAzHyiAoH+T8TZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zx0wLKDu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zx0wLKDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9061F1F000C4;
	Sat, 17 Oct 2026 16:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254962;
	bh=INwejEWkOc3pnnyFS57XWYq6opZRTAI9Vl2sfmnr60E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zx0wLKDuDrgxx9E3YcjVnz2IGTjBxf9m4ZIwKsGrJQ5PqFzIYdzIHpIx1FJ6c+iKz
	 8AtBr0zBKMNkFW2ZzpvohcAFuYSFVURlq7I+cM83bS0fQnp3PNa3rZBCfeZjBRNYfs
	 j++Xf94bo+TAL3qd2r6gO2sycqbHJDRoIQMM4fuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 620/869] ksmbd: safely discard unregistered deferred locks
Date: Sat, 17 Oct 2026 17:57:41 +0200
Message-ID: <20261017160052.926957323@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 054bcca4cd9f00719b01f7108b51a2168fb94f15 ]

When vfs_lock_file() defers a lock, smb2_lock() puts its ksmbd_lock on
rollback_list before allocating and registering the asynchronous work.
If either operation fails, rollback assumes that smb_lock->conn is
initialized and dereferences NULL. The deferred file_lock also remains
linked into the VFS blocked-lock state while it is freed.

Keep the lock off rollback_list until async setup succeeds. On setup
failures, explicitly unblock and wake the deferred lock before freeing it
and its ksmbd wrapper.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b2d4c30571d6c..951d3c4f861c4 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7772,11 +7772,12 @@ int smb2_lock(struct ksmbd_work *work)
 
 				ksmbd_debug(SMB,
 					    "would have to wait for getting lock\n");
-				list_add(&smb_lock->llist, &rollback_list);
 
 				argv = kmalloc(sizeof(void *), KSMBD_DEFAULT_GFP);
 				if (!argv) {
 					err = -ENOMEM;
+					smb2_free_lock(flock);
+					kfree(smb_lock);
 					goto out;
 				}
 				argv[0] = flock;
@@ -7787,8 +7788,11 @@ int smb2_lock(struct ksmbd_work *work)
 				if (rc) {
 					kfree(argv);
 					err = -ENOMEM;
+					smb2_free_lock(flock);
+					kfree(smb_lock);
 					goto out;
 				}
+				list_add(&smb_lock->llist, &rollback_list);
 				spin_lock(&fp->f_lock);
 				list_add(&work->fp_entry, &fp->blocked_works);
 				spin_unlock(&fp->f_lock);
-- 
2.53.0



