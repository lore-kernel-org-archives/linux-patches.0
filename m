Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210509;
	b=QpoyoXE3QGFhJnuHREBMevrMhQPeSomx4DqiFnARtTgaRw9QF84rMXJNCJ+awDE6+wMu
	 BmMxV4bOrrSMxXpEsKrFxrYRMB7lOx9UIFpQByuACgl+vwK6A8ccovQlETUKE3Vj/MzIZ
	 NGTI2WhULPt/RViui3DsXXlKkkXoPGMAsbY0NxjMBNRwCCxJISicmFxQMUptVa30+DdDk
	 Q/T6VjItRbpgaKDzC6/VyLssJvgqm1qraJc1SNJLyMp4Qdl8g0QUt97ExnTqqc5Pp0uFA
	 pE8ohhkzlzsM3dfuzbkAbMXdEEb6dUCnW9S+ZsqPwSZSo6UBlSy5WlkbU50uJBnrN3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210509;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B0ydesYXNNmaD/PQEpshz5xSqBApDCBBr48JOA+iNuY=;
	b=wdOT1TIi6UiWveTNcXlu0dvhpto1+Kf7dWXoo8akIuXkczkIMVNlUnohpcIQ3c1PC3pK
	 AMsUcSuBL1hcTGRPNURWRUhKdVDftPbIeHu3s2bnwZ5s4sKUy4HwE2rVFcd4LUqqrBo2r
	 VrGA1arLeTyIObSEv+GbqyzeMXJQoIuC4HK9nEhxXpDj1KVR99FW14ILoy6z5GDSJLFVT
	 BdTaGYRp4cBibi5cl8GMsWp0SYXgOfYCVMWwvV8Vlj63xrZQKYb5zlPKzHg/knsFaQiGL
	 AgDQZc1wFYLA0RaDtFZc42CO7cvhBlq/TJzT5gLFZF+wD2W3AKSk1UE6L6ciUFjfp0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sLh4jBDC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA78606A31A;
	Wed, 28 Oct 2026 18:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sLh4jBDC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9721F01825;
	Wed, 28 Oct 2026 18:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210509;
	bh=B0ydesYXNNmaD/PQEpshz5xSqBApDCBBr48JOA+iNuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sLh4jBDCSQTKvHv0TvYF5+Sgkm2nemkY0jfp8KZEXkRnzXwo/kT2eozStbjnEPWg+
	 jew/d3Er425t/WCn36MjDV0z+Ks+g4BxYi29GdKN2WJ1MWzf1CyyyCjOZHW3fVrILl
	 4wbc/zk6vQ2dP9Pa9GtUfLS1oa3SDwiLi/CHlvHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjoern Doebel <doebel@amazon.de>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/571] smb: client: avoid leaking refcount in cifs_queue_oplock_break()
Date: Wed, 28 Oct 2026 17:53:01 +0100
Message-ID: <20261028170008.834442315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjoern Doebel <doebel@amazon.de>

[ Upstream commit 9f2e63f1b2d5fc5b5423424902c091123e220e7e ]

cifs_queue_oplock_break() unconditionally takes a reference on the
target file before queueing cifs_oplock_break(). Only that work item
decreases the reference counter again.

If another oplock break arrives while that work is still queued,
queue_work() will return false and not queue this second work item. As a
result, we will never reach the point to drop the file reference again
and are leaking this reference. This can be triggered when interacting
with a slow-responding server.

As a result, later unmount operations for this file system will fail with

  BUG: Dentry ... still in use (1) [unmount of cifs cifs]
  VFS: Busy inodes after unmount of cifs (cifs)
  kernel BUG at fs/super.c:777!

Fix this by only incrementing the reference count if the work has been
queued successfully. Taking it after queue_work() is safe because all
three callers hold tcon->open_file_lock across the call and
_cifsFileInfo_put() decrements under that same lock, so a worker that
starts the handler in the window cannot drop the reference before it has
been taken.

Fixes: b98749cac4a69 ("CIFS: keep FileInfo handle live during oplock break")
Cc: stable@vger.kernel.org
Assisted-by: Kiro:claude-opus-5
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ Adjusted the patch path from fs/smb/client/misc.c to fs/cifs/misc.c. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/misc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index cb7fb2c4ea71f..c7f846e50fc59 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -620,10 +620,11 @@ void cifs_queue_oplock_break(struct cifsFileInfo *cfile)
 	 * open_file_lock to enforce the validity of it for the oplock
 	 * break handler. The matching put is done at the end of the
 	 * handler.
+	 *
+	 * Only take a reference if the work is actually queued.
 	 */
-	cifsFileInfo_get(cfile);
-
-	queue_work(cifsoplockd_wq, &cfile->oplock_break);
+	if (queue_work(cifsoplockd_wq, &cfile->oplock_break))
+		cifsFileInfo_get(cfile);
 }
 
 void cifs_done_oplock_break(struct cifsInodeInfo *cinode)
-- 
2.53.0



