Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216394;
	b=fEbMsTroZou7YsanYF7zkzWnEzO/B8fxD9yycbVZU9TTIO5I69PAMnU171kTOnDlBAUX
	 06ZLG5BhruJTl3baN18DOXEIc2GmWPqMpQjB+t0ctNUuIWSqcxYE1hfrI7f8TQQ7iqIOU
	 aTwXCvdzIZBZzCBQZHp75R1plhZSc4g1eIRkSQpKGoqKYvST9YEL5CSW6K8+UAZw/RYbu
	 ilU7a1HL1FccdGJAMuBR0N1T+DrXN6pnF62HC2L3iRQypk09eP0winBXn9b7p3GYaonfi
	 1Zwo+dbpK/93+V3JrlD42qTCZutLfi5WeltpyYI1pMQtitIMWzghoGQzQmXo7i27ZIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f09du9c+f6ECFPFQYV4hJKZmvKErpMNi1DvrsdmZbC4=;
	b=v9EDzLylFx9RawU+7cbNIaiD9WVF4QZfXLD6s2Xewl9KRp70+7e+4UHgPhahDF713wo8
	 ffdRgfMLSNz6Gq3r9ux7Wfd2+L9ZXFNra/5o1UjPWBIvxViA17v3KR5A4XT01TF/Cl10k
	 HINbr07p5kXbbnqXgRClhfFQCNNKiMguB8iy7eAwTpP+XTLcIOwszgOMKa6F7MdNReRQW
	 BVTXwc3BcCKUTbJ7EQeE8ydOknCU8tVdWt9+WGbLH7NOX8vz2wo6epWOIh8IUyuCKDgL8
	 6E81XuSQYnapggQJgYL6jQw+uAVQ73/oiQQ4xpiPD0PASFZCuKVIz0obdbVrJnNa8lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ON/yucbH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E097606A31A;
	Wed, 28 Oct 2026 19:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ON/yucbH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99FC1F01825;
	Wed, 28 Oct 2026 19:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216393;
	bh=f09du9c+f6ECFPFQYV4hJKZmvKErpMNi1DvrsdmZbC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ON/yucbHTGcGePX9u8lncElUa2+yAFS2Ln0vDS3yncnQ+93+pseRhunhup8Hi7hA+
	 wkAHKKNgKnw+E4TciIvxFgldsdfE5+dkM50VxzqzJ8pWiq4dxvfE3PDhjGYirSUzSQ
	 SPzD3N6fr8AIYV2y8tFdMBq08rHGXsWSydM0ljAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Dudnik <ilan.dudnik@safebreach.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1540/1887] ksmbd: defer publishing granted locks to prevent UAF/double-free race
Date: Wed, 28 Oct 2026 18:00:36 +0100
Message-ID: <20261028170534.510891925@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Dudnik <ilan.dudnik@safebreach.com>

[ Upstream commit 29f74f0f2e6df3b393b7b66e810136d0c64e3c59 ]

In smb2_lock(), mid-batch granted locks are published to connection-wide
(conn->lock_list) and file-wide (fp->lock_list) lists immediately upon
vfs_lock_file() success, while also remaining tracked on the stack-local
rollback_list.

If a subsequent element in the same SMB2_LOCK request array fails
validation or execution, the thread jumps to out: and walks
rollback_list to undo previously granted locks. However, because the
granted lock was already published to conn->lock_list, a concurrent
UNLOCK request on the same connection can find the lock object and
kfree() it before the rollback loop executes.

When the granting thread subsequently walks rollback_list, it
dereferences and frees the already-freed ksmbd_lock structure, resulting
in a Use-After-Free and Double-Free (on both ksmbd_lock and struct
file_lock).

Fix this by deferring the publication of granted locks to
conn->lock_list and fp->lock_list until after the entire array of lock
elements has been processed without error. Mid-batch grants remain
tracked exclusively on the request-local rollback_list until the whole
batch succeeds, eliminating the race window.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Ilan Dudnik <ilan.dudnik@safebreach.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 5acfa540f8f9b..ea28cc5524c7c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7389,16 +7389,10 @@ int smb2_lock(struct ksmbd_work *work)
 				rsp->hdr.Status =
 					STATUS_RANGE_NOT_LOCKED;
 				kfree(smb_lock);
-				goto out2;
+				/* rollback_list may still hold earlier grants */
+				goto out;
 			} else if (!rc) {
 				list_add(&smb_lock->llist, &rollback_list);
-				smb_lock->conn = ksmbd_conn_get(work->conn);
-				spin_lock(&work->conn->llist_lock);
-				list_add_tail(&smb_lock->clist,
-					      &work->conn->lock_list);
-				list_add_tail(&smb_lock->flist,
-					      &fp->lock_list);
-				spin_unlock(&work->conn->llist_lock);
 				ksmbd_debug(SMB, "successful in taking lock\n");
 			} else {
 				locks_free_lock(flock);
@@ -7420,6 +7414,19 @@ int smb2_lock(struct ksmbd_work *work)
 	if (err)
 		goto out;
 
+	/* publish only once the whole batch has committed */
+	if (!list_empty(&rollback_list)) {
+		spin_lock(&work->conn->llist_lock);
+		list_for_each_entry(smb_lock, &rollback_list, llist) {
+			smb_lock->conn = ksmbd_conn_get(work->conn);
+			list_add_tail(&smb_lock->clist,
+				      &work->conn->lock_list);
+			list_add_tail(&smb_lock->flist,
+				      &fp->lock_list);
+		}
+		spin_unlock(&work->conn->llist_lock);
+	}
+
 	ksmbd_fd_put(work, fp);
 	return 0;
 
@@ -7447,15 +7454,6 @@ int smb2_lock(struct ksmbd_work *work)
 		}
 
 		list_del(&smb_lock->llist);
-		conn = smb_lock->conn;
-		spin_lock(&conn->llist_lock);
-		if (!list_empty(&smb_lock->flist))
-			list_del(&smb_lock->flist);
-		list_del(&smb_lock->clist);
-		smb_lock->conn = NULL;
-		spin_unlock(&conn->llist_lock);
-		ksmbd_conn_put(conn);
-
 		smb2_free_lock(smb_lock->fl);
 		if (rlock)
 			locks_free_lock(rlock);
-- 
2.53.0



