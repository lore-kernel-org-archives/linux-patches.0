Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516943E95B7;
	Wed, 21 Jan 2026 18:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020512; cv=none; b=gZ10cRySf60Gg2OvfcJn3Mi2goqAGXzusDogYjA/1ebsHqCcqCgOWSj7ZqiZLYnxzl87p48JsoUkquBelf66SXpM8rRCEHvMVkguWifssqnUqAOxZOQWI9rUUhjPK1ft1q8WuOP0hZQuDGCXmMCZc3mI/MavxNn77Al0LNSfdSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020512; c=relaxed/simple;
	bh=3B8JrZ25XOkAZ+6EJ79g4cuP6zs8wO7trjfqOnMjuxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GO7V2QDXZa6MPylO+9TkB8JYwUAwjlqWGMs6EsKXkQ4TRwaLQsfFCVBpG4i68t67WkKb0lz6ZhfgTuAq7kujTIcEIPd+9DMEMzwdrjvzSvhfxqt6JvJljgnkxB2YrVSaUcPJ2reCIvFqmMP40aKU4PFl7ww0vFsIcdQKajlj3pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4IWMVbG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4IWMVbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFFBC4CEF1;
	Wed, 21 Jan 2026 18:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020511;
	bh=3B8JrZ25XOkAZ+6EJ79g4cuP6zs8wO7trjfqOnMjuxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4IWMVbGtRkM9Zbp4PGBCX3OYavBUnLKSajq8epcmAX13YIzH3nq1+qZykEB/jzE1
	 Z4DSxL+wZ2PL9TOHIIDOrhXBrPMIDPRM930CkodZNir8gioe5VgOVjYOXgOxeIP1KX
	 9aCFmOj2lifwAKLHcBtN1mpziOPAf1RFiGF+cnuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 181/198] dmaengine: ti: dma-crossbar: fix device leak on dra7x route allocation
Date: Wed, 21 Jan 2026 19:16:49 +0100
Message-ID: <20260121181425.064717316@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit dc7e44db01fc2498644e3106db3e62a9883a93d5 upstream.

Make sure to drop the reference taken when looking up the crossbar
platform device during dra7x route allocation.

Note that commit 615a4bfc426e ("dmaengine: ti: Add missing put_device in
ti_dra7_xbar_route_allocate") fixed the leak in the error paths but the
reference is still leaking on successful allocation.

Fixes: a074ae38f859 ("dmaengine: Add driver for TI DMA crossbar on DRA7x")
Fixes: 615a4bfc426e ("dmaengine: ti: Add missing put_device in ti_dra7_xbar_route_allocate")
Cc: stable@vger.kernel.org	# 4.2: 615a4bfc426e
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251117161258.10679-14-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ti/dma-crossbar.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/dma/ti/dma-crossbar.c
+++ b/drivers/dma/ti/dma-crossbar.c
@@ -288,6 +288,8 @@ static void *ti_dra7_xbar_route_allocate
 
 	ti_dra7_xbar_write(xbar->iomem, map->xbar_out, map->xbar_in);
 
+	put_device(&pdev->dev);
+
 	return map;
 }
 


