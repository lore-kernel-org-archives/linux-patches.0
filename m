Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482F82773F7;
	Mon, 13 Apr 2026 16:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096349; cv=none; b=pdq7ibTUepu3Qv9gfLQFLNacrYzpVpbIBlmCUhvRmCyCLOsgLB89GRPwlgoH2H9+gPIQqGTbhgsaYY7lVs91jQSsvV7mCquHRXYFIXL/zWJ1arKA69i4v+ylSmoPtfCsKwKFixr0K5+IslGLzZRRYAUvbNTdq8H053Pyw4bE1FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096349; c=relaxed/simple;
	bh=csmnprJjWXwAGVwRw0KGnGi6RG2NGwXffDqX2IaHSOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5p/0UpLatSCfM1O0SyK8CmknafvWlW1HFWVvcnOsjV9qeX5nplU02rdM7EXiGmz/Enq2Uk4MxtIyrdbsuAMbJJS3pAq9TMFWY/pxRH4XTa6L8Ys5Vckvw0f/wGm+/xRAJMR1WRJwWYXrZFZWmY0WKsGQ8l07s5CP5Ix0i0e/ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pdlr+jtr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pdlr+jtr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D216FC2BCB0;
	Mon, 13 Apr 2026 16:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096349;
	bh=csmnprJjWXwAGVwRw0KGnGi6RG2NGwXffDqX2IaHSOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pdlr+jtrtimxl5qKhEFyrmJDGhFgjHCIio5wm7dZsbKPMgE6NvlGCJvQ5IpiUbvC+
	 MBwXsUIKMDAy+B98K261oTGojaxxuaSJ4KnFD5IEUwt/hCba0+BV+/k8OHHWmKEXTL
	 LJCCaduhh+TcWHfhiGRo9YUNBuO1kHNL5psK2dF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.19 62/86] net: lan966x: fix page_pool error handling in lan966x_fdma_rx_alloc_page_pool()
Date: Mon, 13 Apr 2026 18:00:09 +0200
Message-ID: <20260413155733.873693615@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 3fd0da4fd8851a7e62d009b7db6c4a05b092bc19 upstream.

page_pool_create() can return an ERR_PTR on failure. The return value
is used unconditionally in the loop that follows, passing the error
pointer through xdp_rxq_info_reg_mem_model() into page_pool_use_xdp_mem(),
which dereferences it, causing a kernel oops.

Add an IS_ERR check after page_pool_create() to return early on failure.

Fixes: 11871aba1974 ("net: lan96x: Use page_pool API")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Link: https://patch.msgid.link/20260405055241.35767-2-devnexen@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -91,6 +91,8 @@ static int lan966x_fdma_rx_alloc_page_po
 		pp_params.dma_dir = DMA_BIDIRECTIONAL;
 
 	rx->page_pool = page_pool_create(&pp_params);
+	if (unlikely(IS_ERR(rx->page_pool)))
+		return PTR_ERR(rx->page_pool);
 
 	for (int i = 0; i < lan966x->num_phys_ports; ++i) {
 		struct lan966x_port *port;


