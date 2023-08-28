Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96095469F
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182F0C433C8;
	Mon, 28 Aug 2023 10:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218761;
	bh=l0iagpYJLZ2KgCZ0EhOf+8gWUE1Ud8Ke9qzexdecicA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOQ17X2SDW/wXna2e0KycGg5+Gia/ycXKodsfQ1nDjm6wT8yaUGqzVKjP75Jv/SG8
	 HsQmBUfyPUwRJr4yu+lNfv35096O2Lp8IjOhjKM+xgatAQIqCR5dGmpfO4d8aK97PF
	 AWHcYWAKw5wCj7UvmMNy+XMtqxBDQjKAQYB04Bf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@fb.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.1 074/122] NFS: Fix a use after free in nfs_direct_join_group()
Date: Mon, 28 Aug 2023 12:13:09 +0200
Message-ID: <20230828101158.891219576@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

commit be2fd1560eb57b7298aa3c258ddcca0d53ecdea3 upstream.

Be more careful when tearing down the subrequests of an O_DIRECT write
as part of a retransmission.

Reported-by: Chris Mason <clm@fb.com>
Fixes: ed5d588fe47f ("NFS: Try to join page groups before an O_DIRECT retransmission")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/direct.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -474,20 +474,26 @@ out:
 	return result;
 }
 
-static void
-nfs_direct_join_group(struct list_head *list, struct inode *inode)
+static void nfs_direct_join_group(struct list_head *list, struct inode *inode)
 {
-	struct nfs_page *req, *next;
+	struct nfs_page *req, *subreq;
 
 	list_for_each_entry(req, list, wb_list) {
-		if (req->wb_head != req || req->wb_this_page == req)
+		if (req->wb_head != req)
 			continue;
-		for (next = req->wb_this_page;
-				next != req->wb_head;
-				next = next->wb_this_page) {
-			nfs_list_remove_request(next);
-			nfs_release_request(next);
-		}
+		subreq = req->wb_this_page;
+		if (subreq == req)
+			continue;
+		do {
+			/*
+			 * Remove subrequests from this list before freeing
+			 * them in the call to nfs_join_page_group().
+			 */
+			if (!list_empty(&subreq->wb_list)) {
+				nfs_list_remove_request(subreq);
+				nfs_release_request(subreq);
+			}
+		} while ((subreq = subreq->wb_this_page) != req);
 		nfs_join_page_group(req, inode);
 	}
 }


