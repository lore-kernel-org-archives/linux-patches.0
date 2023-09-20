Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AB8156E5
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307BBC433CD;
	Wed, 20 Sep 2023 12:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213392;
	bh=FNglxMDhYr7sQn10Q8KCUkaHePNLtieMEZZYKOZFTOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eVX3i6wQyo/MIiKBibx7mbuf4AEZnqo1PBqnC1nIfaAnm6p03TiMqLM5I5pQ6/4Ua
	 Apxij6DCXJzoGu2Z8+mdxDHyzPIB0EPjks5gKRMP3tJG/0GxRLr7PbmJZ9QMOBZD3A
	 +qwpf/SpCkRxIy9pBO/jsOqa7IIhDQHxwDBg2wd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Logan Gunthorpe <logang@deltatee.com>,
	renlonglong <ren.longlong@h3c.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 5.4 221/367] ntb: Fix calculation ntb_transport_tx_free_entry()
Date: Wed, 20 Sep 2023 13:29:58 +0200
Message-ID: <20230920112904.314486390@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2431,7 +2431,7 @@ unsigned int ntb_transport_tx_free_entry
 	unsigned int head = qp->tx_index;
 	unsigned int tail = qp->remote_rx_info->entry;
 
-	return tail > head ? tail - head : qp->tx_max_entry + tail - head;
+	return tail >= head ? tail - head : qp->tx_max_entry + tail - head;
 }
 EXPORT_SYMBOL_GPL(ntb_transport_tx_free_entry);
 


