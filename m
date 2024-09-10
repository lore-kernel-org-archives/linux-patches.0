Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE6818C32F;
	Tue, 10 Sep 2024 10:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962849; cv=none; b=vCxyJ+wtNv+NIwK/TLzaJexb3tO+3s0bZEl92Z7YFPNFZuQOksM1b9MZItALTyoRr01YhW0ybkZpL2eMGXBSN0H8sY8LvIYi+JnA72rW7kVH1RmvjiMBfQluSF2dyCLfN6jGsP2AIxydh8Fm/HTGIgWaCu5k7rWtflcLiagk4Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962849; c=relaxed/simple;
	bh=k1mHl/Rwy40bU1F7FRKKpLIZ+WeUQJGLyKxJXD3z184=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrGlsWRJycSyWTNtqb5+lU5pbNO2zB5dTnj0Qcv/3taLwBn9xUzbSSy6qgJlA2gPysgKnapDqvdYRgMOcGUz8iQsc0GK41st768acvmGSxloRQ+UwpXRcKcvpQ69rnVhGuOGAzJhhEa69C1QO/C2yBKfIFNCCNncbE9503XWWG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFoHcWz1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFoHcWz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E0EC4CEC3;
	Tue, 10 Sep 2024 10:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962848;
	bh=k1mHl/Rwy40bU1F7FRKKpLIZ+WeUQJGLyKxJXD3z184=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFoHcWz1+n6gDpmM1x6uwTYoq2794uUiOMBDnIV4sJAa5WQ7mDZRDu7mONtuGpf1t
	 Ctjm6XtcdqGQT9I48hf5q4oJnjL3ZJXSZN4Xn5jigcsLAFW9mJxegaPCkkyDys0qo8
	 milrMKGpaIWaOyc0ivy1WJsm/TJAL5ukFPaHRrR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.1 024/192] fuse: update stats for pages in dropped aux writeback list
Date: Tue, 10 Sep 2024 11:30:48 +0200
Message-ID: <20240910092558.951450738@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

commit f7790d67785302b3116bbbfda62a5a44524601a3 upstream.

In the case where the aux writeback list is dropped (e.g. the pages
have been truncated or the connection is broken), the stats for
its pages and backing device info need to be updated as well.

Fixes: e2653bd53a98 ("fuse: fix leaked aux requests")
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Cc: <stable@vger.kernel.org> # v5.1
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1703,10 +1703,16 @@ __acquires(fi->lock)
 	fuse_writepage_finish(fm, wpa);
 	spin_unlock(&fi->lock);
 
-	/* After fuse_writepage_finish() aux request list is private */
+	/* After rb_erase() aux request list is private */
 	for (aux = wpa->next; aux; aux = next) {
+		struct backing_dev_info *bdi = inode_to_bdi(aux->inode);
+
 		next = aux->next;
 		aux->next = NULL;
+
+		dec_wb_stat(&bdi->wb, WB_WRITEBACK);
+		dec_node_page_state(aux->ia.ap.pages[0], NR_WRITEBACK_TEMP);
+		wb_writeout_inc(&bdi->wb);
 		fuse_writepage_free(aux);
 	}
 


