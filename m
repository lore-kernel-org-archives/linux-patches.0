Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F8636B13
	for <patches@lists.linux.dev>; Thu, 12 Oct 2023 18:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DEF9CQ3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0500C433C8;
	Thu, 12 Oct 2023 18:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697133653;
	bh=jjgW1Of+8sJ+mB5PIwyM2BvarnzEMHxrjOjlWlHxAcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DEF9CQ3I9YO/TkQWI/ED3T6tSRY9FWAW8Pz0RDP7J5BcNAZgmzoZAKFXMrgPLm/Dw
	 ij78xufoviS3vjZZ7UnljOLopKu7WMs1ic8ny2JLXcWQfny8S20tzv/7KJYzXMAwdm
	 Mma9XfQOY8z71OWzr9pHV3ohE0fNulN6eeP5cCHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	poester <poester@internetbrands.com>,
	=?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1/6] Revert "NFS: More fixes for nfs_direct_write_reschedule_io()"
Date: Thu, 12 Oct 2023 20:00:43 +0200
Message-ID: <20231012180030.165297018@linuxfoundation.org>
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

This reverts commit edd1f06145101dab83497806bb6162641255ef50 which is
commit b11243f720ee5f9376861099019c8542969b6318 upstream.

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
 fs/nfs/direct.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -782,23 +782,18 @@ static void nfs_write_sync_pgio_error(st
 static void nfs_direct_write_reschedule_io(struct nfs_pgio_header *hdr)
 {
 	struct nfs_direct_req *dreq = hdr->dreq;
-	struct nfs_page *req;
-	struct nfs_commit_info cinfo;
 
 	trace_nfs_direct_write_reschedule_io(dreq);
 
-	nfs_init_cinfo_from_dreq(&cinfo, dreq);
 	spin_lock(&dreq->lock);
-	if (dreq->error == 0)
+	if (dreq->error == 0) {
 		dreq->flags = NFS_ODIRECT_RESCHED_WRITES;
-	set_bit(NFS_IOHDR_REDO, &hdr->flags);
-	spin_unlock(&dreq->lock);
-	while (!list_empty(&hdr->pages)) {
-		req = nfs_list_entry(hdr->pages.next);
-		nfs_list_remove_request(req);
-		nfs_unlock_request(req);
-		nfs_mark_request_commit(req, NULL, &cinfo, 0);
+		/* fake unstable write to let common nfs resend pages */
+		hdr->verf.committed = NFS_UNSTABLE;
+		hdr->good_bytes = hdr->args.offset + hdr->args.count -
+			hdr->io_start;
 	}
+	spin_unlock(&dreq->lock);
 }
 
 static const struct nfs_pgio_completion_ops nfs_direct_write_completion_ops = {


