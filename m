Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212368;
	b=J65z+kX1RuMfi8Mz6JkJjqJZ3bZzoUDVzvscp1ZiSTKuVOxnu7449egI1fAr1GW/UlFl
	 O+2EujJ86cTpr4pJ2LTn6whUCc7zcIzuRm5nrnPOQrvw5tJQu0fDIQ6uW7+tW2h2z7RtA
	 p4IQtagEnYducnBJmIZUBJx35e3IXYsnTdMW4VbBV6E4/iENzLS2nvktPu57QIjYin1JW
	 ov4Zpyj6gPNkVXCs+05Dyx7SdLISB0X/0YLAPkPq9146XGhMJ8HxxtYE+eO4BZL7mb+z4
	 GBabsaWjgJMXl8BN0yINUKWqgmfzkJ021UOuyAZpBbMpfyc5x8dNxjBRe6lUHRxRtWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O5HtJinMsIWS3IVKK7+CsuaxzVj9mce/a7fhC5zyClE=;
	b=NvJVWe+XZcgj2tZSHqlGno57BVwyrqo2IOmrHzSy81U/JfQS44YUashMjFd1tSgXwLXk
	 6D8Cj0jKtl4CBNp9ypQ+nXQbWt7wsc34yjFjB/sbhHteU4r4ln6ip91RznEaMV+tgyvZ4
	 0mvc+zirtQKhSwpZ0J3CvVrRwqUHUaPy4ITIaepoI0aXaSwBkoyBPGMqoKVohydD8PRHJ
	 oJO0dd9d8zT2GyuQlHf8KRqt6cp0lojG6Wecde978TeJfOIGC6lekDDgZkS1qwPGXYuA2
	 MiXl5bRAqqKqXOd3naExlpiDXg1qHLjzAobGtrEfx2zydKvyV2fPJ9CowQTzKcsgAvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="k/l5NBS5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB0C606A31A;
	Wed, 28 Oct 2026 18:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k/l5NBS5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B17B1F01825;
	Wed, 28 Oct 2026 18:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212367;
	bh=O5HtJinMsIWS3IVKK7+CsuaxzVj9mce/a7fhC5zyClE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k/l5NBS5PK+aM/mjn0vZ9SOly53QcVaMLqqzWWbAMPjlpuFpIgFVVOBV1zipJKsGP
	 tClkpTxr6Z/6Li8Tb8vIKKmWgisQfykhl6KtC0XTn1WK+1q8e2/rKY9RVHW/ahPsPe
	 koMFHWkKbIPpGQLK1f90ZlliQvQVA935EpaNy4jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0129/1887] smb: client: fix cifsFileInfo reference leak in deferred close
Date: Wed, 28 Oct 2026 17:37:05 +0100
Message-ID: <20261028170502.172946241@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit 5520e89a5a4f834bced64cf2ac927001cc513a40 ]

When cifs_close() defers a close, it hands the cifsFileInfo reference
of the closing struct file to the queued work. Each execution of
smb2_deferred_work_close() drops one such reference.

deferred_close_scheduled can be false while the work is pending: the
workqueue clears PENDING when the callback starts to run, before the
callback clears the flag under deferred_lock. A close in that
interval requeues the running work, and the callback then clears the
flag, leaving the requeued work pending with the flag down. A later
cifs_open() can reuse the handle and its cifs_close() reaches the
same branch: queue_delayed_work() fails because the work is still
pending, but cifs_close() returns without dropping the closing file's
reference. The cifsFileInfo count stays pinned and its tlink, dentry
and server handle are leaked.

Check the return value and hand off the reference only when work was
actually queued. Otherwise, use the shared _cifsFileInfo_put(), like
the mod_delayed_work() branch above: the pending execution already
owns its reference.

This issue was found by an in-house static analysis tool.

Fixes: c3f207ab29f7 ("cifs: Deferred close for files")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ Adjusted cifs_close() context due to missing trace_smb3_close_cached(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/file.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 466d25c90a10f..35689e7bb16a7 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1042,11 +1042,18 @@ int cifs_close(struct inode *inode, struct file *file)
 					cifsFileInfo_get(cfile);
 			} else {
 				/* Deferred close for files */
-				queue_delayed_work(deferredclose_wq,
-						&cfile->deferred, cifs_sb->ctx->closetimeo);
-				cfile->deferred_close_scheduled = true;
-				spin_unlock(&cinode->deferred_lock);
-				return 0;
+				/*
+				 * Each queued execution owns one reference.
+				 * If nothing was queued, the reference of
+				 * the closing file is dropped below.
+				 */
+				if (queue_delayed_work(deferredclose_wq,
+						       &cfile->deferred,
+						       cifs_sb->ctx->closetimeo)) {
+					cfile->deferred_close_scheduled = true;
+					spin_unlock(&cinode->deferred_lock);
+					return 0;
+				}
 			}
 			spin_unlock(&cinode->deferred_lock);
 			_cifsFileInfo_put(cfile, true, false);
-- 
2.53.0



