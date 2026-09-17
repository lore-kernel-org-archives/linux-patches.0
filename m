Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC5A4DDB2E;
	Thu, 17 Sep 2026 15:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660560; cv=none; b=V8WmzYHU8jDUUc12sy7k7mn3eQPDBZyQdNDNJ7Wh7rNER02LYHAXR5pQiJKoeiVep2M26aQsyu7pCRyJj4YMg0uTYGoCnFeoAoX5Xd7wjwHoEPr1uduCHMmn+a21nc1bdXERjyJBtXEF8cwDzxNgeAGDCF8NDtROu5bXo0amFHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660560; c=relaxed/simple;
	bh=5F4NbSbqpbysIKpURZhXLOaLwzKl270CMZktmoLpgxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiboI+0QOJX6KWes09gyluO7pXAt4jcYkdSTccxIWsyPWzHYbBkogk51Ot6w/RBQZXK6eMnSek00nupEbk8oGgGQkoALnSwtp/THW+ZGzwoaR1L8Qv60qql2DuRBUwASgwvwCkxYrASacfrWkH58Lo5PAMjYTJ2oNTn47wieUP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSzAFe4+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSzAFe4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1CB1F000FF;
	Thu, 17 Sep 2026 15:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660558;
	bh=gm2JmIBAcT5KzphIZYcLLQR3zzT6Qi/VoCKzOXou8C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PSzAFe4+NFphqbB6qJ7D9+Lv6K4v35rsX/PuVOfYxKgx/qelsUzBUjSpp+naOCF9Z
	 9pwz+J8PxVWnDqp0/JC4l5NS2VzbjpSVVqXQgEV6BVoWM9j7EDWcB+sr4etonzms38
	 ZDV+aRfFtVNkx9OaXqp5EaolgecczSGrR9+5ZzqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 633/733] smb: client: fix cifsFileInfo reference leak in deferred close
Date: Thu, 17 Sep 2026 16:15:41 +0100
Message-ID: <20260917151408.347647619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 5520e89a5a4f834bced64cf2ac927001cc513a40 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1491,11 +1491,18 @@ int cifs_close(struct inode *inode, stru
 				trace_smb3_close_cached(tcon->tid, tcon->ses->Suid,
 						cfile->fid.persistent_fid,
 						cifs_sb->ctx->closetimeo);
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


