Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F25F47CC96;
	Tue, 25 Aug 2026 13:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665497; cv=none; b=KsBpv2iJFpyL+UA/XaZw8IBjFKcotUiRxwohMmQF5UgDWI4eYd8OuVLgsWR6PqMdYyOJ8NTKrYe0dmAZLdjUUZtzSMULDx0AL9mBha21CtV1eTlBQaeeJ/ouvCi4eTUrxzvwLQ6bvobq0C2w03m5xXJ8AuJzPHS58BXIV+aCWsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665497; c=relaxed/simple;
	bh=G1omGN+gyDIAxsmBOiNs+ScBmQRyVV+/H2j85eXPoNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmR2gMuywLz0QbUCn27scNOIdt4L0sXx/9e61B1iH/ggtQDRSlugy6pd0DDlpnsHuERr8gYvmgP4tnGI0JDoAW+kZsLvyTKHIVWMm8bwKxq8FuuM3QbZN/HjP1BoSWLDXw4Qr1P/HnAr3VQ+t0LLmy50t/beEfzrB/0zoO5gQmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAh40eGx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAh40eGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B661F00A3A;
	Tue, 25 Aug 2026 13:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665496;
	bh=UKmTmmCIiOVwT/MqmT4LP2YW5CQdSLBSFvmQ3nL6gbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SAh40eGxWdC8lDFyq2Fl13Ev1qVw+Whs2r2KYJoAuuuYItmDcZz7UtVAV+NDXuqgs
	 6g+OCE5XOD4qsQHCtS7bdyKw26vBrdV3NvCqR1NUKOO/Lcb3T3YqQ/YUsso/GWasei
	 FFuJFu2ucazQ/wNu9Q6swq1/e19UEtO0ayugQgiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 6.12 44/77] nfc: nci: free destination parameters when closing a connection
Date: Tue, 25 Aug 2026 15:26:06 +0200
Message-ID: <20260825132543.285495540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


