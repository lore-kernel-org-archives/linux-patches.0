Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005B01DE2A5;
	Tue,  8 Oct 2024 13:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392524; cv=none; b=ADr/wbaKtkdsu6PVIE3ffGc+Jm67cijZGJtbfNsYTzLTJ41ih3qtqBAw3eCCsGoIwkgr209VkdeiOvHad336L/xY7qvoBy1v4ZCH1jwG1fWNckjTLwBrD0oqidAhkZjhHEgD9oxFE3RT/IzUnmblcxUD3+r6nK6iX28jKMjoMEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392524; c=relaxed/simple;
	bh=WLwRj/HquwQhS9vPeul50MmUzuudxyZRZs0yQu5A3+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YURNRMFY3YZbyqk0gjvu5IkIWZ0+JVBm4Iz3PZABjmD51OE2E3fVQRy0OyT1lMCLp4705PhZZs94dIyqLn+53UM6Q6kgBbJbr9zMc3DjNucUe8kKSPprGoY1Mhh39QISZGeOevuiaBliUkSzrLUK7w6pSxAicrweUmVOEfba0oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJJ4Rku7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJJ4Rku7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D88C4CEC7;
	Tue,  8 Oct 2024 13:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392523;
	bh=WLwRj/HquwQhS9vPeul50MmUzuudxyZRZs0yQu5A3+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJJ4Rku7EEgxLdWNrlQxwnz5avOJSB4B/WmZi9w/ql5/T/iX28qgy3dFHFWjWbA2q
	 y9x6aAhx9ixoQbndwPeM9Nvu7a12nmQSRcj4PXOR3L951daxMwRPUMM5uG6nU7JCsu
	 K/8BWUi5XW4JnMHdMuJLMtZFu3GPUtjdlWXdlddA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.11 439/558] RDMA/mana_ib: use the correct page table index based on hardware page size
Date: Tue,  8 Oct 2024 14:07:49 +0200
Message-ID: <20241008115719.545092588@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

commit 9e517a8e9d9a303bf9bde35e5c5374795544c152 upstream.

MANA hardware uses 4k page size. When calculating the page table index,
it should use the hardware page size, not the system page size.

Cc: stable@vger.kernel.org
Fixes: 0266a177631d ("RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter")
Signed-off-by: Long Li <longli@microsoft.com>
Link: https://patch.msgid.link/1725030993-16213-1-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mana/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -383,7 +383,7 @@ static int mana_ib_gd_create_dma_region(
 
 	create_req->length = umem->length;
 	create_req->offset_in_page = ib_umem_dma_offset(umem, page_sz);
-	create_req->gdma_page_type = order_base_2(page_sz) - PAGE_SHIFT;
+	create_req->gdma_page_type = order_base_2(page_sz) - MANA_PAGE_SHIFT;
 	create_req->page_count = num_pages_total;
 
 	ibdev_dbg(&dev->ib_dev, "size_dma_region %lu num_pages_total %lu\n",


