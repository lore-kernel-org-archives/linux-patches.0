Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E2A368972;
	Tue, 12 May 2026 18:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609538; cv=none; b=iUUz1CjUmziqwihwFXRbJ4J2mIkUQTd50tc1JWVH5xN14wtCJZBQU5+S1Fdzls9ntIhOXgvm8/+WnQU6VA+iMIKSPWAu1RzgCOdaOPDrtcYcDF9otMuqIqw4tzi8jcHgs2N25mmNBvzN/3jMkmxGujpjRQ+/JUWt+XQx7/5Oxo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609538; c=relaxed/simple;
	bh=EFRSjb4Wqz/+flabh0CoOzMZ2EjUtpAj7E4m5jf2Bwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O09a2nyTQzUpwT+sz8pJHBsjKEdvuSw87SLj7xEbKv/+x8bx/iVOxNuinEUagOApwxZDAdR+ciUe1to/+UZj9u62SK+A5khndFNN+Q70Aq3JexpBzd73q4W0lkk7mxHNX/ZMpbY3lia+84FDI5tqxQvrACArY12LthXwjq1yiWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=prDM4SJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="prDM4SJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB8AC2BCB0;
	Tue, 12 May 2026 18:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609538;
	bh=EFRSjb4Wqz/+flabh0CoOzMZ2EjUtpAj7E4m5jf2Bwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=prDM4SJnk6iDONVlf0k1vJm1kDtdYlWRkl7/LVD7eNtxtq/bOeZ0DrluxbWs3tUD8
	 5NmTG2gHcw6mB/Y0p+sEKPU8S+u7U3C2zXJYIZXXC92VmFi2qKK0E26HfZZtLv+k6z
	 AecctvSVnxKZq1OoP5UWJ/LV7xchuGyEVPhms8JA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.0 233/307] RDMA/mana: Fix error unwind in mana_ib_create_qp_rss()
Date: Tue, 12 May 2026 19:40:28 +0200
Message-ID: <20260512173945.038917962@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

commit 6aaa978c6b6218cfac15fe1dab17c76fe229ce3f upstream.

Sashiko points out that mana_ib_cfg_vport_steering() is leaked, the normal
destroy path cleans it up.

Cc: stable@vger.kernel.org
Fixes: 0266a177631d ("RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter")
Link: https://sashiko.dev/#/patchset/0-v1-e911b76a94d1%2B65d95-rdma_udata_rep_jgg%40nvidia.com?part=4
Link: https://patch.msgid.link/r/7-v1-41f3135e5565+9d2-rdma_ai_fixes1_jgg@nvidia.com
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mana/qp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -235,13 +235,15 @@ static int mana_ib_create_qp_rss(struct
 		ibdev_dbg(&mdev->ib_dev,
 			  "Failed to copy to udata create rss-qp, %d\n",
 			  ret);
-		goto fail;
+		goto err_disable_vport_rx;
 	}
 
 	kfree(mana_ind_table);
 
 	return 0;
 
+err_disable_vport_rx:
+	mana_disable_vport_rx(mpc);
 fail:
 	while (i-- > 0) {
 		ibwq = ind_tbl->ind_tbl[i];


