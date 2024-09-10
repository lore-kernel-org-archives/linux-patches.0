Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4994E18C932;
	Tue, 10 Sep 2024 09:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961347; cv=none; b=DCa8UB+/2NT7NfeCd/QZ6awLSqVZZY72bvdOymSIkkU/RQEgY9yfgp3VmkhdYxw7EMEpEnQZfUz+xL4jHMsYBUghWig8hRSPAA0GmUP70fZMtgKXcINLUn7NiJmSmCAYMTVbKfHLt1d1u302JUBz2drOEdghIU8nIgVZTtTYCMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961347; c=relaxed/simple;
	bh=fhRenRkTb8wlLdqr4eCRhwcMfNITI1l6BGnOaTof5ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExzTsXHJAwp43Qbsgt/PsLeVrUUUPO9kuhoX2MLun/RQyPXUesWHkvKyT60Nr/uMnkzLhZjPj19BasF46kahGg6PCPOEXOgRY/k+lRgczwyF6OMFxveZW1supHSzW96bgDHVPpITyWm+es5GBYOk1TsvMXzwffAATZxDnmLICVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iYT2hkHT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iYT2hkHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1018C4CEC3;
	Tue, 10 Sep 2024 09:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961347;
	bh=fhRenRkTb8wlLdqr4eCRhwcMfNITI1l6BGnOaTof5ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iYT2hkHTERBJGRXIzY7jfbs1LUmY4jLSmG0o/JwdV+kok5TEW4mPEjOlmmQkF9BhJ
	 Ut/eOAkB3phkTmOG7WPDKaNQ4GwUUFAhXaXkVLmNCdbHUgCEI6CBk7pFExCm+/RoYr
	 1DO9zDeWSJLhZX0rTa573W5HRB8OooEeTMZVNGMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.10 039/375] fuse: check aborted connection before adding requests to pending list for resending
Date: Tue, 10 Sep 2024 11:27:16 +0200
Message-ID: <20240910092623.542849265@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

commit 97f30876c94382d1b01d45c2c76be8911b196527 upstream.

There is a race condition where inflight requests will not be aborted if
they are in the middle of being re-sent when the connection is aborted.

If fuse_resend has already moved all the requests in the fpq->processing
lists to its private queue ("to_queue") and then the connection starts
and finishes aborting, these requests will be added to the pending queue
and remain on it indefinitely.

Fixes: 760eac73f9f6 ("fuse: Introduce a new notification type for resend pending requests")
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Cc: <stable@vger.kernel.org> # v6.9
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -31,6 +31,8 @@ MODULE_ALIAS("devname:fuse");
 
 static struct kmem_cache *fuse_req_cachep;
 
+static void end_requests(struct list_head *head);
+
 static struct fuse_dev *fuse_get_dev(struct file *file)
 {
 	/*
@@ -1822,6 +1824,13 @@ static void fuse_resend(struct fuse_conn
 	}
 
 	spin_lock(&fiq->lock);
+	if (!fiq->connected) {
+		spin_unlock(&fiq->lock);
+		list_for_each_entry(req, &to_queue, list)
+			clear_bit(FR_PENDING, &req->flags);
+		end_requests(&to_queue);
+		return;
+	}
 	/* iq and pq requests are both oldest to newest */
 	list_splice(&to_queue, &fiq->pending);
 	fiq->ops->wake_pending_and_unlock(fiq);


