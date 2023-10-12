Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A068937C98
	for <patches@lists.linux.dev>; Thu, 12 Oct 2023 18:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvZl1b5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E00C433CA;
	Thu, 12 Oct 2023 18:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697133667;
	bh=Jqpb1TRQBHc2DGj7U/u6DlszWV6VX1QhDv+tW/eoovE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvZl1b5uiMbvndGmgWgoqSQvk6ofMXV9U5t1ea6zangC9T/SvfpvvyzDjxyjiMotU
	 iWNcO0OpVr1EwZKjXH0XhffmbTp+e1IuTpuaZk7tBSTbNCgcJFPh0vFipuP/UJMjvY
	 1fp8PXddGok6SLTTimoBtQPek5MSBSQ7Vdkr7Pho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	poester <poester@internetbrands.com>,
	=?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 4/6] Revert "NFS: Fix O_DIRECT locking issues"
Date: Thu, 12 Oct 2023 20:00:46 +0200
Message-ID: <20231012180030.235840718@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231012180030.112560642@linuxfoundation.org>
References: <20231012180030.112560642@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 4d98038e5bd939bd13cc4e602dfe60cd5110efa8 which is
commit 7c6339322ce0c6128acbe36aacc1eeb986dd7bf1 upstream.

There are reported NFS problems in the 6.1.56 release, so revert a set
of NFS patches to hopefully resolve the issue.

Reported-by: poester <poester@internetbrands.com>
Link: https://lore.kernel.org/r/20231012165439.137237-2-kernel@linuxace.com
Reported-by: Daniel Díaz <daniel.diaz@linaro.org>
Link: https://lore.kernel.org/r/2023100755-livestock-barcode-fe41@gregkh
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/direct.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -555,7 +555,7 @@ static void nfs_direct_write_reschedule(
 		/* Bump the transmission count */
 		req->wb_nio++;
 		if (!nfs_pageio_add_request(&desc, req)) {
-			spin_lock(&dreq->lock);
+			spin_lock(&cinfo.inode->i_lock);
 			if (dreq->error < 0) {
 				desc.pg_error = dreq->error;
 			} else if (desc.pg_error != -EAGAIN) {
@@ -565,7 +565,7 @@ static void nfs_direct_write_reschedule(
 				dreq->error = desc.pg_error;
 			} else
 				dreq->flags = NFS_ODIRECT_RESCHED_WRITES;
-			spin_unlock(&dreq->lock);
+			spin_unlock(&cinfo.inode->i_lock);
 			break;
 		}
 		nfs_release_request(req);
@@ -875,9 +875,9 @@ static ssize_t nfs_direct_write_schedule
 
 			/* If the error is soft, defer remaining requests */
 			nfs_init_cinfo_from_dreq(&cinfo, dreq);
-			spin_lock(&dreq->lock);
+			spin_lock(&cinfo.inode->i_lock);
 			dreq->flags = NFS_ODIRECT_RESCHED_WRITES;
-			spin_unlock(&dreq->lock);
+			spin_unlock(&cinfo.inode->i_lock);
 			nfs_unlock_request(req);
 			nfs_mark_request_commit(req, NULL, &cinfo, 0);
 			desc.pg_error = 0;


