Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CCF6FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DA7C433C8;
	Sun, 17 Sep 2023 20:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982872;
	bh=l0uu5h+IgnQds6lP0lbGaOtDE25cZhlu0BLQoB7FfLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVbYn+Ttc12Yf0pFyr7js7n/wZ44tPfq2IxXGEOLh9Unrin+nOmUgmqDxFuM/DCeD
	 xqzj5h28dDd8o2lGRUvpdRSfiuMuNaDlNtEomKt04CPBy6A1CySKmke3QD4X3JYKzV
	 Tx36hEFdXdoWQ7QAsAztDD2BBTgnfGQSnPvFxJcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Logan Gunthorpe <logang@deltatee.com>,
	renlonglong <ren.longlong@h3c.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 5.15 344/511] ntb: Fix calculation ntb_transport_tx_free_entry()
Date: Sun, 17 Sep 2023 21:12:51 +0200
Message-ID: <20230917191122.114891096@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

commit 5a7693e6bbf19b22fd6c1d2c4b7beb0a03969e2c upstream.

ntb_transport_tx_free_entry() never returns 0 with the current
calculation. If head == tail, then it would return qp->tx_max_entry.
Change compare to tail >= head and when they are equal, a 0 would be
returned.

Fixes: e74bfeedad08 ("NTB: Add flow control to the ntb_netdev")
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: renlonglong <ren.longlong@h3c.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ntb/ntb_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -2429,7 +2429,7 @@ unsigned int ntb_transport_tx_free_entry
 	unsigned int head = qp->tx_index;
 	unsigned int tail = qp->remote_rx_info->entry;
 
-	return tail > head ? tail - head : qp->tx_max_entry + tail - head;
+	return tail >= head ? tail - head : qp->tx_max_entry + tail - head;
 }
 EXPORT_SYMBOL_GPL(ntb_transport_tx_free_entry);
 


