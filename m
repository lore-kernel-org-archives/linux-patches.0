Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C1F53B4
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF82C433C9;
	Sun, 17 Sep 2023 19:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979353;
	bh=f6nZeCjZ4BNTKRE5EmJogPnxQOtMpRTwZs7E5VY2wyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JShghRM8D/Jqz/rrUQDBUvhxv+1yjiuwmf9KjLZZdOzJ9IVnPWTfr4mHFYEGAB1sE
	 7hXpB9U5PBimCyfGAsaanremE8acFuf8qFEJ1rJEwQho1cjDwzYtFl03kvzTZrbPFM
	 8ol19X+af7DUZEqM4+8R+vMzjbcqK5yCaumEHquM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Y Lu <yuan.y.lu@intel.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 5.10 288/406] ntb: Drop packets when qp link is down
Date: Sun, 17 Sep 2023 21:12:22 +0200
Message-ID: <20230917191108.911170522@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

commit f195a1a6fe416882984f8bd6c61afc1383171860 upstream.

Currently when the transport receive packets after netdev has closed the
transport returns error and triggers tx errors to be incremented and
carrier to be stopped. There is no reason to return error if the device is
already closed. Drop the packet and return 0.

Fixes: e26a5843f7f5 ("NTB: Split ntb_hw_intel and ntb_transport drivers")
Reported-by: Yuan Y Lu <yuan.y.lu@intel.com>
Tested-by: Yuan Y Lu <yuan.y.lu@intel.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ntb/ntb_transport.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -2278,9 +2278,13 @@ int ntb_transport_tx_enqueue(struct ntb_
 	struct ntb_queue_entry *entry;
 	int rc;
 
-	if (!qp || !qp->link_is_up || !len)
+	if (!qp || !len)
 		return -EINVAL;
 
+	/* If the qp link is down already, just ignore. */
+	if (!qp->link_is_up)
+		return 0;
+
 	entry = ntb_list_rm(&qp->ntb_tx_free_q_lock, &qp->tx_free_q);
 	if (!entry) {
 		qp->tx_err_no_buf++;


