Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B466FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89533C433D9;
	Sun, 17 Sep 2023 20:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980934;
	bh=YMNrfYwfGcHibjtNZ5QK0sKA7Yj+7seU83m51hanu3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2nJ/Pu1yACHDpqJyD0rz/elmKRAjLcAhxCTmBajmCQ/kZ3enndj/RKQ5saC2mpA3
	 Z/RtJ7OMdZqnkbgvUoKHejLGk45C47AmweIcjtztDE45wY9gHEJkutVd92yGN1KEKp
	 eMcqr4T3wbRgQ0TgMTxD+Cf4KePzexShFxabRwGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 6.1 049/219] NFS: Fix a potential data corruption
Date: Sun, 17 Sep 2023 21:12:56 +0200
Message-ID: <20230917191042.778246848@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 88975a55969e11f26fe3846bf4fbf8e7dc8cbbd4 upstream.

We must ensure that the subrequests are joined back into the head before
we can retransmit a request. If the head was not on the commit lists,
because the server wrote it synchronously, we still need to add it back
to the retransmission list.
Add a call that mirrors the effect of nfs_cancel_remove_inode() for
O_DIRECT.

Fixes: ed5d588fe47f ("NFS: Try to join page groups before an O_DIRECT retransmission")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/direct.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -474,13 +474,31 @@ out:
 	return result;
 }
 
+static void nfs_direct_add_page_head(struct list_head *list,
+				     struct nfs_page *req)
+{
+	struct nfs_page *head = req->wb_head;
+
+	if (!list_empty(&head->wb_list) || !nfs_lock_request(head))
+		return;
+	if (!list_empty(&head->wb_list)) {
+		nfs_unlock_request(head);
+		return;
+	}
+	list_add(&head->wb_list, list);
+	kref_get(&head->wb_kref);
+	kref_get(&head->wb_kref);
+}
+
 static void nfs_direct_join_group(struct list_head *list, struct inode *inode)
 {
 	struct nfs_page *req, *subreq;
 
 	list_for_each_entry(req, list, wb_list) {
-		if (req->wb_head != req)
+		if (req->wb_head != req) {
+			nfs_direct_add_page_head(&req->wb_list, req);
 			continue;
+		}
 		subreq = req->wb_this_page;
 		if (subreq == req)
 			continue;


