Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBDF9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E32AC433C8;
	Sun, 13 Aug 2023 21:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962955;
	bh=8hx8A8Q+DaD0IzHdOx+c7EzYr9TfgGLcgjIapBCtGWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aidASGcOyik6hREVyndDDOWkU7KCQuZiEluF9yi+G2thogf/juKSOUh4vQNv8gQUU
	 B4ovA7hRL4S6AC85eKRhO7rPCmWYNYrvid6+GTEnGpQ8jdDlmrdw4snPkW9lOnO+t6
	 Nho9TAXqCRCddvMAttiD+RrCpV3hADVm++Lm7/wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Child <nnac123@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 54/68] ibmvnic: Handle DMA unmapping of login buffs in release functions
Date: Sun, 13 Aug 2023 23:19:55 +0200
Message-ID: <20230813211709.787159569@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211708.149630011@linuxfoundation.org>
References: <20230813211708.149630011@linuxfoundation.org>
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

commit d78a671eb8996af19d6311ecdee9790d2fa479f0 upstream.

Rather than leaving the DMA unmapping of the login buffers to the
login response handler, move this work into the login release functions.
Previously, these functions were only used for freeing the allocated
buffers. This could lead to issues if there are more than one
outstanding login buffer requests, which is possible if a login request
times out.

If a login request times out, then there is another call to send login.
The send login function makes a call to the login buffer release
function. In the past, this freed the buffers but did not DMA unmap.
Therefore, the VIOS could still write to the old login (now freed)
buffer. It is for this reason that it is a good idea to leave the DMA
unmap call to the login buffers release function.

Since the login buffer release functions now handle DMA unmapping,
remove the duplicate DMA unmapping in handle_login_rsp().

Fixes: dff515a3e71d ("ibmvnic: Harden device login requests")
Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20230809221038.51296-3-nnac123@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -929,12 +929,22 @@ static int ibmvnic_login(struct net_devi
 
 static void release_login_buffer(struct ibmvnic_adapter *adapter)
 {
+	if (!adapter->login_buf)
+		return;
+
+	dma_unmap_single(&adapter->vdev->dev, adapter->login_buf_token,
+			 adapter->login_buf_sz, DMA_TO_DEVICE);
 	kfree(adapter->login_buf);
 	adapter->login_buf = NULL;
 }
 
 static void release_login_rsp_buffer(struct ibmvnic_adapter *adapter)
 {
+	if (!adapter->login_rsp_buf)
+		return;
+
+	dma_unmap_single(&adapter->vdev->dev, adapter->login_rsp_buf_token,
+			 adapter->login_rsp_buf_sz, DMA_FROM_DEVICE);
 	kfree(adapter->login_rsp_buf);
 	adapter->login_rsp_buf = NULL;
 }
@@ -4445,11 +4455,6 @@ static int handle_login_rsp(union ibmvni
 	}
 	adapter->login_pending = false;
 
-	dma_unmap_single(dev, adapter->login_buf_token, adapter->login_buf_sz,
-			 DMA_TO_DEVICE);
-	dma_unmap_single(dev, adapter->login_rsp_buf_token,
-			 adapter->login_rsp_buf_sz, DMA_FROM_DEVICE);
-
 	/* If the number of queues requested can't be allocated by the
 	 * server, the login response will return with code 1. We will need
 	 * to resend the login buffer with fewer queues requested.


