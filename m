Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC80423A85;
	Tue, 25 Aug 2026 13:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666207; cv=none; b=ESu0RKuk4vu2RCvgLXKLF1F+Q25Em+8cl/Df9yXOANU1DL9zCaNXo0Vajz7PmB9p9/5Y65Vp8iRdfvFh5VdH5NMOCs6Y2IYpOb/h+jAHe0IJzooVFQ5u8IhZ/ddDoTZyUOuOUQYDgwqIv+RYi50bMNHYMeuuumrLGYzQsVBKc8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666207; c=relaxed/simple;
	bh=zKs2U7gxtSMHBdpVtr8FYb7I7PqmJ5qXhPLQ3PKotjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHZcDlYq+YtK1kBPaKXXrmKZs9RXPT6Hw6ZkPxsFxdST3+LqjAWlAFat2NobZrGALqEffiqWQt2wct6f72wALi3fwevQRyt3cGF1trx8JMH7Jjxsuk3nnutWFEevxUbZ+S6SEZY4folKFYYWdaXxQjb/G/QsMoUHA/fMOKhHd0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZDGx9RF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZDGx9RF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC38F1F000E9;
	Tue, 25 Aug 2026 13:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666206;
	bh=Qpq+UepHgK7WSFcvwyxZHQW8eMxs9/dlfp1oKtKvvm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CZDGx9RF1piO30C+TwVgzijQ5i85layKG5UefMbi9hS3VoyEy3kQHt/LmIM/rrMiZ
	 jSl1JaP37vF7lRp2JJeGmbQeqp8xoUsl7LHtU3UMu/r1qKup5mFztcCOsx+qNlMhYa
	 BVEaW04REqFSu/qfOhl8jV97bvWBaSeHxL8mrLL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 5.15 39/76] nfc: nci: free destination parameters when closing a connection
Date: Tue, 25 Aug 2026 15:26:32 +0200
Message-ID: <20260825132543.103125775@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

commit 2e65bafdfd3a8bba972b3d17b6a57816557530fc upstream.

When a connection is closed, nci_core_conn_close_rsp_packet() frees
conn_info but not conn_info->dest_params, which is a separate devm
allocation. Each connect/close cycle leaks one dest_params until the
NFC device is removed. Free dest_params along with conn_info.

Fixes: 9b8d1a4cf2aa ("nfc: nci: Add an additional parameter to identify a connection id")
Cc: stable@vger.kernel.org
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260721023518.1697625-1-lilinmao@kylinos.cn
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/nci/rsp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -336,6 +336,7 @@ static void nci_core_conn_close_rsp_pack
 			list_del(&conn_info->list);
 			if (conn_info == ndev->rf_conn_info)
 				ndev->rf_conn_info = NULL;
+			devm_kfree(&ndev->nfc_dev->dev, conn_info->dest_params);
 			devm_kfree(&ndev->nfc_dev->dev, conn_info);
 		}
 	}


