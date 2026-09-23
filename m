Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F673B52E6;
	Wed, 23 Sep 2026 14:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175291; cv=none; b=W879ZNuXrEIybcAOXtY0G+6LRaJ/G3KJgk6peIYouF+GMgWmv51QNpgAm1FLg8FBcVVOtUI7mtTwH0y7C7tz5gOlevErUrSMkpe5JOJAjikGnRajXN1Sk66TAwhaueuhhhgkhn91HPip4o1YJwoIk+Om3BS6bkUYIa9R8Zi/HLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175291; c=relaxed/simple;
	bh=fgdi7z2NuU8ZW6I7saP+AXX2lvyfI56DyMxXA4wXbtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPMHPpyFbdnOvZWX1iezX54yotc26k830uZnCljrhyVMlCT4D3YkXWedVivQAL7sUzKw3oTrvm+s3/30ZxNe98CjaxjPLDcobjAzgSGpv4nZmhbCu+frSWkqSBRQ3odbaAvwlQtigXh8higJt9tK8kpJZUGkJYhN2ljOTyP+gFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xwYGIF9w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xwYGIF9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677CC1F000FF;
	Wed, 23 Sep 2026 14:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175289;
	bh=QabtGHCXTuW5nYxAZ7IODllH9bmCf+nKt4pWiKwtWyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xwYGIF9w5wUSBvk4Dq6cJrnQiM4ekUGE1kmBj/AnO8YpcSut+Ia/or90+AORisDox
	 HypKSErHwdS0BbtzahFU0ao6/raAOHzEgn/RGQpPviBBzQjw31bq3LFAK9MPryNnC8
	 0qWfouId52diRPP5CN59STPas1cYGuJmeEyS5HsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 380/398] smb: client: fix cifsFileInfo reference leak in deferred close
Date: Wed, 23 Sep 2026 16:07:34 +0200
Message-ID: <20260923140653.308570238@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1467,11 +1467,18 @@ int cifs_close(struct inode *inode, stru
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


