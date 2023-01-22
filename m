Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F292590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADA8C433D2;
	Sun, 22 Jan 2023 15:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400755;
	bh=AgAeoDIRkrViumwFCf5hYMbJYksxHuu283QcEKrU1R4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTqN2tdwTeHqotI7C62LYWQ0whsC5yJ8w5pDCeg1swMauHqqVXqKWESIBRkjxnM1J
	 SAb5zBAALFtZqTFGdsko73F/IGHhwASdrKxA6i7vGJeDB5zJaSm/tnDeDmDZbd4ki/
	 5dOTirZXLArqmmkk1DJQE0cERpesRQqCa0NBMVho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enzo Matsumiya <ematsumiya@suse.de>,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 067/117] cifs: do not include page data when checking signature
Date: Sun, 22 Jan 2023 16:04:17 +0100
Message-Id: <20230122150235.566041591@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Enzo Matsumiya <ematsumiya@suse.de>

commit 30b2b2196d6e4cc24cbec633535a2404f258ce69 upstream.

On async reads, page data is allocated before sending.  When the
response is received but it has no data to fill (e.g.
STATUS_END_OF_FILE), __calc_signature() will still include the pages in
its computation, leading to an invalid signature check.

This patch fixes this by not setting the async read smb_rqst page data
(zeroed by default) if its got_bytes is 0.

This can be reproduced/verified with xfstests generic/465.

Cc: <stable@vger.kernel.org>
Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3999,12 +3999,15 @@ smb2_readv_callback(struct mid_q_entry *
 				(struct smb2_sync_hdr *)rdata->iov[0].iov_base;
 	struct cifs_credits credits = { .value = 0, .instance = 0 };
 	struct smb_rqst rqst = { .rq_iov = &rdata->iov[1],
-				 .rq_nvec = 1,
-				 .rq_pages = rdata->pages,
-				 .rq_offset = rdata->page_offset,
-				 .rq_npages = rdata->nr_pages,
-				 .rq_pagesz = rdata->pagesz,
-				 .rq_tailsz = rdata->tailsz };
+				 .rq_nvec = 1, };
+
+	if (rdata->got_bytes) {
+		rqst.rq_pages = rdata->pages;
+		rqst.rq_offset = rdata->page_offset;
+		rqst.rq_npages = rdata->nr_pages;
+		rqst.rq_pagesz = rdata->pagesz;
+		rqst.rq_tailsz = rdata->tailsz;
+	}
 
 	WARN_ONCE(rdata->server != mid->server,
 		  "rdata server %p != mid server %p",


