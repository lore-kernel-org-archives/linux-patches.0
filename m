Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66F411711
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AD5C433C8;
	Mon, 11 Sep 2023 14:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442223;
	bh=Y4+aJ5PmgftjWzii6n/OgUFdev48pubt1Gye0kubpDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7KP1795jWld7zTu41gU2ZcYw2/NCMrojK59M7hx05lVYaW39dFZdrXoGgJCy0zZN
	 xD+JCxs3DCEplrbl9Njpdr8DbMrb8dA/L8Z5GYZs627KuaFO1SSpdeQk6GbSFTY1ga
	 I2GqCOv1NXQOApS8ShC9iOSSDIvhpsYo9jjpeh60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Y Lu <yuan.y.lu@intel.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 6.5 689/739] ntb: Clean up tx tail index on link down
Date: Mon, 11 Sep 2023 15:48:08 +0200
Message-ID: <20230911134710.344135198@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

commit cc79bd2738c2d40aba58b2be6ce47dc0e471df0e upstream.

The tx tail index is not reset when the link goes down. This causes the
tail index to go out of sync when the link goes down and comes back up.
Refactor the ntb_qp_link_down_reset() and reset the tail index as well.

Fixes: 2849b5d70641 ("NTB: Reset transport QP link stats on down")
Reported-by: Yuan Y Lu <yuan.y.lu@intel.com>
Tested-by: Yuan Y Lu <yuan.y.lu@intel.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ntb/ntb_transport.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -909,7 +909,7 @@ static int ntb_set_mw(struct ntb_transpo
 	return 0;
 }
 
-static void ntb_qp_link_down_reset(struct ntb_transport_qp *qp)
+static void ntb_qp_link_context_reset(struct ntb_transport_qp *qp)
 {
 	qp->link_is_up = false;
 	qp->active = false;
@@ -932,6 +932,13 @@ static void ntb_qp_link_down_reset(struc
 	qp->tx_async = 0;
 }
 
+static void ntb_qp_link_down_reset(struct ntb_transport_qp *qp)
+{
+	ntb_qp_link_context_reset(qp);
+	if (qp->remote_rx_info)
+		qp->remote_rx_info->entry = qp->rx_max_entry - 1;
+}
+
 static void ntb_qp_link_cleanup(struct ntb_transport_qp *qp)
 {
 	struct ntb_transport_ctx *nt = qp->transport;
@@ -1174,7 +1181,7 @@ static int ntb_transport_init_queue(stru
 	qp->ndev = nt->ndev;
 	qp->client_ready = false;
 	qp->event_handler = NULL;
-	ntb_qp_link_down_reset(qp);
+	ntb_qp_link_context_reset(qp);
 
 	if (mw_num < qp_count % mw_count)
 		num_qps_mw = qp_count / mw_count + 1;


