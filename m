Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9043191466;
	Tue, 10 Sep 2024 10:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962514; cv=none; b=ODs25pmqvTNhFdqhjYVrZD1Ylmb97h5TuPIVIu/G7T6HrSTJHfjBlKTyyyA4Id1dOjo35vhbir3HwdgjqLkI3ts5lFdUFQ3DlDGlKYs7tWqfwRo5Nn88SJiVv9/QblVCjsM2WX47Qhuhuz/F4v4rn0Csb+Gt6kf4v7eMzL3PmoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962514; c=relaxed/simple;
	bh=4UP5G+46T8a7qv7ROjr8ddivijneM3Hzrqb0IBopqzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/QboGZo3bbZxHFDlb+c9Ot+en2iRxjHzdnEjjdAS5UkrhiAQM2C/1hmRY0SG3CD1NW57ejbQNk//2NNEpYPtRTVl/wkda48a7ppeA4eCk9v6kebYOqZ51lXPTVQ2X6sQK56nl85Quqh+GAEZG0CZU/emhuMy8zEFILkZbEmbMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnH+meTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnH+meTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF54C4CEC6;
	Tue, 10 Sep 2024 10:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962513;
	bh=4UP5G+46T8a7qv7ROjr8ddivijneM3Hzrqb0IBopqzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pnH+meTYwJu4fjPBW7noiojFQFIxunS2VmAswWGlr3elIE8DitZ5953Xe455+a48D
	 ZCI0aX77mgWP/Z7x4HVhk16OePfLFzLOgkjr4YiwI3avWZyz2g871nl3q9PCZgr3dg
	 eBLOFvkK/xHYv/F4ns3ZUeVrJp8VptGrqUfaHI6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 033/121] fuse: update stats for pages in dropped aux writeback list
Date: Tue, 10 Sep 2024 11:31:48 +0200
Message-ID: <20240910092547.299706499@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1694,10 +1694,16 @@ __acquires(fi->lock)
 	fuse_writepage_finish(fc, wpa);
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
 


