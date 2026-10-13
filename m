Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302D83A16AE;
	Tue, 13 Oct 2026 12:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894678; cv=none; b=WLCa2YUYea9XeSgvzmJmcyytRPgnHEOSYkz3lDQZTaxKXC/4JJPFHYjtvkodX5Pi5qpVNRVgRYl9Ys4zaKjwqHROk+qON72ZJufwHU4AcGrNtZ53nbJRTSETtKHltXJlr2AFrW641Ix8pbojhIwZuFVk7XlbZKOjdHXCMwWL87c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894678; c=relaxed/simple;
	bh=ds5owjw2mnWbgQzsO/88j2XZs3ezG9X1B+e9GiNENas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmcVUjk5qJ2ViHSFs3tL7MmHZpFdIl5/pMghjNY+5qwH8NjHBQN2LQv7ep0kJHy7vRusPsjNVhwMxDXrBqx09E/m2av0ymFcZC4auC+gNPedP48LWQWpKlYNbTxjghLtahSd5H665rEeZjF21hlIUxBK6zMfqc5XtwaNFzqACqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8CQuvcA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8CQuvcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CA11F000FF;
	Tue, 13 Oct 2026 12:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894677;
	bh=/vBHwRVqv6PDljXWdTFJqfHse5geVlmFEsJN6qrAJOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H8CQuvcAtBsXBKYUdn3vNL0faB6XFADX7oMMzXnUv7+VRBSfZ/hr6gJCwMLGDBX2N
	 0dK9kmnDdaCj/cPItuWMwP73bQkyKjDJVhwvnnoWGqFL5uZZcGaKF3ACJzWBxGNOT9
	 1/ZUZP4oxkgbeDoJkOh7QjWQmFnTZHa4PFHn54nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 002/497] smb: client: fix cifsFileInfo reference leak in deferred close
Date: Tue, 13 Oct 2026 13:32:49 +0200
Message-ID: <20261013112907.931364147@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
index afe00c0cc696a..ee3cc2b2fda41 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1378,11 +1378,18 @@ int cifs_close(struct inode *inode, struct file *file)
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



