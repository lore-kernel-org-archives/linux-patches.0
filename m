Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D6F9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290F8C433C8;
	Sun, 13 Aug 2023 21:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691963140;
	bh=qw9STLvFISGBFnU4pQxeQ4qxmkOcs/k/SXu+foGmvk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/vvAgbF1F9KmjHMlksxdIhub1eXDZ/ui1l3lfcC5VePgdcA9+/3wewV91zPbMAgv
	 8LPVCvaZiXLsu5+3XLY3o7cOSP+clfrjPPib7yOOwe+XdBV3ohjO5XngrL6AiHyKD9
	 UlR1/3PhgkGCZP0FsjAM4JUteEC6d5aLadJtldSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Child <nnac123@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 68/89] ibmvnic: Unmap DMA login rsp buffer on send login fail
Date: Sun, 13 Aug 2023 23:19:59 +0200
Message-ID: <20230813211712.819434424@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211710.787645394@linuxfoundation.org>
References: <20230813211710.787645394@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nick Child <nnac123@linux.ibm.com>

commit 411c565b4bc63e9584a8493882bd566e35a90588 upstream.

If the LOGIN CRQ fails to send then we must DMA unmap the response
buffer. Previously, if the CRQ failed then the memory was freed without
DMA unmapping.

Fixes: c98d9cc4170d ("ibmvnic: send_login should check for crq errors")
Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20230809221038.51296-2-nnac123@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4220,11 +4220,14 @@ static int send_login(struct ibmvnic_ada
 	if (rc) {
 		adapter->login_pending = false;
 		netdev_err(adapter->netdev, "Failed to send login, rc=%d\n", rc);
-		goto buf_rsp_map_failed;
+		goto buf_send_failed;
 	}
 
 	return 0;
 
+buf_send_failed:
+	dma_unmap_single(dev, rsp_buffer_token, rsp_buffer_size,
+			 DMA_FROM_DEVICE);
 buf_rsp_map_failed:
 	kfree(login_rsp_buffer);
 	adapter->login_rsp_buf = NULL;


