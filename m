Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802DD15E8B;
	Mon, 30 Dec 2024 15:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573901; cv=none; b=sXzUjxr4T6GR1ITkkrmXQCPEdzqZOaO5m2XehRdEcIaknRnK1pPyPc8cWiyjbsGuVysxoHyA7km9/3GLw4+/c5kfAWwiYQRy4sfOHeqmEnTb7Mu4XQT4h/lK0RJ0kDlEt2KZfSxVevNBx35eLCg28JP44aG9cEhc8ynmDvEf4uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573901; c=relaxed/simple;
	bh=Djx5T+ERGgFhRWkVII2P3YwBM05wNRf6/H7yk1LjG4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBEWyg67QB5K8lW0veebK5fAo21z1HFGN+sTz5HSdqcDJIhuD3I3KizXWBaybiPxKvxv481bbR3A2caChSYvWINVzq7vizSlfHnEFD9ouas+RC/kjK1WXWNRc7tiJ22/s11a9LDHRkH46JmtLrZaXPycbqmzeFsIRlyfhpDDZUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ngTd0NQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ngTd0NQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36CDC4CED0;
	Mon, 30 Dec 2024 15:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573901;
	bh=Djx5T+ERGgFhRWkVII2P3YwBM05wNRf6/H7yk1LjG4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngTd0NQ6ycSOrmDU0Mw9IoDtCxZ1pg4ML5Tu3TQP6DEWykPMvoez37Gbs62ZKTUOK
	 XjjrjYnZGNxqraI690mf3qTZo2OsHHPXUYZBL4+lsm5lEyp/uP0NtuKCFiU3LvZvws
	 KYAuJ71vCrzV5CR6B+xHegYhtGL8EI55O7BsSSSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 27/86] dmaengine: at_xdmac: avoid null_prt_deref in at_xdmac_prep_dma_memset
Date: Mon, 30 Dec 2024 16:42:35 +0100
Message-ID: <20241230154212.751299677@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

commit c43ec96e8d34399bd9dab2f2dc316b904892133f upstream.

The at_xdmac_memset_create_desc may return NULL, which will lead to a
null pointer dereference. For example, the len input is error, or the
atchan->free_descs_list is empty and memory is exhausted. Therefore, add
check to avoid this.

Fixes: b206d9a23ac7 ("dmaengine: xdmac: Add memset support")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Link: https://lore.kernel.org/r/20241029082845.1185380-1-chenridong@huaweicloud.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_xdmac.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1363,6 +1363,8 @@ at_xdmac_prep_dma_memset(struct dma_chan
 		return NULL;
 
 	desc = at_xdmac_memset_create_desc(chan, atchan, dest, len, value);
+	if (!desc)
+		return NULL;
 	list_add_tail(&desc->desc_node, &desc->descs_list);
 
 	desc->tx_dma_desc.cookie = -EBUSY;


