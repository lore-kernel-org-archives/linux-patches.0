Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5977C1581E4;
	Tue,  9 Jul 2024 11:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524287; cv=none; b=b86JiSDidtIlongZ/4vCSEPgqd0W/Iy5OKu4R0XB5MeRw3wPUZ4QwxPduoukIsNjDza05zzQZpQ8HutfbzLt0NjSf9FBYpeHqY4lKVilZhSyjyJ86lYMT0VPQbfMdiuAVxgZJ+V7yuATz4iwlJeb9fyQyyZCPgkbbkFhXBNcwKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524287; c=relaxed/simple;
	bh=XcEytEf0vKxZWPDbNRdrl5If/jyJzOxd5iB097/IBqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOl/nEiEW8JmHXgV5o4GqGIBfltJsy2XXYzXAsY1eWpazHtte/W8JxO5GGCU3GzwF8ypK2j4yURoT17jDEu9Pu7+GRxZTPLhfEXAwi0u+A/hQDWVuJoPTeZz7IKstvpFC0zqK2qLhcitXB5+NdvtJpC8WCoHhKhiGgFQAiQAV0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQ4vJeAR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQ4vJeAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB167C3277B;
	Tue,  9 Jul 2024 11:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524287;
	bh=XcEytEf0vKxZWPDbNRdrl5If/jyJzOxd5iB097/IBqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQ4vJeARlEprUaPoVe69HiIDWTBb07FpuGrZ0sapIstjKQL4rSS/PNjSjjkA2MzAz
	 aouKqjQxQor4ccxhymB4EYRHegtMIELUbGpOfLA584XlblvScHYAlic131gHXt9q6h
	 EKTPBvD70dW8Z+rQQ2qakK2MgMVAeoDdnWN1IlBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 103/197] net: txgbe: initialize num_q_vectors for MSI/INTx interrupts
Date: Tue,  9 Jul 2024 13:09:17 +0200
Message-ID: <20240709110712.944856000@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit 7c36711a2cd8059c2d24f5e5c1d76e8ea2d5613c ]

When using MSI/INTx interrupts, wx->num_q_vectors is uninitialized.
Thus there will be kernel panic in wx_alloc_q_vectors() to allocate
queue vectors.

Fixes: 3f703186113f ("net: libwx: Add irq flow functions")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 07ba3a270a14f..b62b191cc146a 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1686,6 +1686,7 @@ static int wx_set_interrupt_capability(struct wx *wx)
 	}
 
 	pdev->irq = pci_irq_vector(pdev, 0);
+	wx->num_q_vectors = 1;
 
 	return 0;
 }
-- 
2.43.0



