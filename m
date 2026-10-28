Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210635;
	b=fpSWFvJh/c/Xw7wM3UM0DsOwDYnTj/vQ+WqKTsNSE4xxDa5JXSVwoV0SF/6w0dCX8zXo
	 pJykBBvpzwiIlr8xRz3Terq1bAz4YWj/nbTXKFHKtP1Hedlbgpq2BpcIofrCGv0Jrwqu4
	 IK9h7el2m6GrdA34++UTG/MkI9owJ7hE8bFxTaIe+9c0GV2Jn5Nwybb1wYTysImDC5s7C
	 6gwVETS20l3Pa4Byx70gDW2Oh1uFJtG9h07sw1DfgdgzhG10quttoZWZCFvUnypA0k/Nm
	 SWV+zmqeaHwPEQWtgCINBvGtqc2q4MwHCY99K6mvsHM/sJ++ovGs30GJVwmOxgVvDMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VVC9LYX44MG++f8RVfhsf+UFVNZ0TLtxlmIZQlAaUKM=;
	b=0PhjtYUUDlKe7PGwE11oHL+kbjwDj5clcHgxchmBuM0kB2umTA/demdWZNox6bPr09cf
	 +zkcMOCLbbwgXDPnKmCnJcsMSA7jpreB/LvC39fsdHI4yHf9KxY+aB2EAbM8q21fzaa4H
	 o/Uu9iT70HL90ZZQseAtM2e6CVdBRQj8LBVdyRi9u1zuIN0FibGH2YZPL7zIJY48DPCZ0
	 XFay533uFtPoPpaS6bWri9HkGrV8b3YBKH42a+LcP8h+lV5DW3P13MWHUcVEvP57hOnxM
	 rGtdVp31t+7fFseuU/kgs32TbQtZwHOSRJwE4nfajmsOOcQJTBSWyLPwERnOyKHD4wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="C7WbC/tN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F217606A31C;
	Wed, 28 Oct 2026 18:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C7WbC/tN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF7D1F01825;
	Wed, 28 Oct 2026 18:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210635;
	bh=VVC9LYX44MG++f8RVfhsf+UFVNZ0TLtxlmIZQlAaUKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C7WbC/tNQ/t61+lL1zi13r/8zfzkUG+9qxq6jcTeztc/rO+H+hQW+TaO/XNjF6QZc
	 ER+t7eWCSrbmNSE1Yii799WEX3u+/sKcAhvy/+oZbKfxEkgJA0ZzqvaZ9OvMsfGcp+
	 de9UkgJxj7PkNC4P5m+rUphnNMHWGm3C8XbtQcsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/571] smb: client: fix cifsFileInfo reference leak in deferred close
Date: Wed, 28 Oct 2026 17:54:03 +0100
Message-ID: <20261028170010.300085175@linuxfoundation.org>
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
 fs/cifs/file.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 71f585a41d456..b776fb2989df9 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -901,11 +901,18 @@ int cifs_close(struct inode *inode, struct file *file)
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



