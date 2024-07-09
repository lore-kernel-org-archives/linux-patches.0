Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79EB1581EB;
	Tue,  9 Jul 2024 11:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523693; cv=none; b=jaGR12T+sSNvC2qbYvRkmfpH5/cOiKdgBgwSeOXb8z1e349Ytp+D0pi5LkxIEyHTTQBO4hOFFmmc2mYoIEzfoazp+h2AjEXB2uLU498oXaYB8Ie2PViUCA7ZydHEDPSippfhJg0fILqMfNCgwo+fjEteDjTF1rPUZoESDGuzHoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523693; c=relaxed/simple;
	bh=s+RDvs3DZHtfqTXunkn4azV1+4G/Wy9y7AlNzBofH+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+Ye7OBh3FYGRIGC5mot8Qxxgk70/edwV5eSF0Mp2NGUOrS1A+N/mjV7GxF/yh7o4GJPoRG4fleyW8da6x4QNmiLzoIbODGRpvvFz9JTkD3Nkm8xBbGBPsp1HOdiyKf/Zx4b0pwdXiQC5sxNzxBWm6T2Cu/txd8M3u7hYy7LBls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JWb2VILn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JWb2VILn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02141C3277B;
	Tue,  9 Jul 2024 11:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523692;
	bh=s+RDvs3DZHtfqTXunkn4azV1+4G/Wy9y7AlNzBofH+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JWb2VILn0of2x/FCcExWnjt19UqsTVAmzht2wnIbASkghUktUipDYUfrTDsI34App
	 sYBGD5fx9mg2UxOADiarCE5fu/37uLvhajfZvFWN4r8hhPnyL228LMOt3/wmOOGu7w
	 EQ/xzts6ALa5aO4bHkFzklO/vskuMNopPAkT936c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/139] net: txgbe: initialize num_q_vectors for MSI/INTx interrupts
Date: Tue,  9 Jul 2024 13:09:35 +0200
Message-ID: <20240709110701.074047620@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e9310d9ca67c9..bba44ff0e2872 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1657,6 +1657,7 @@ static int wx_set_interrupt_capability(struct wx *wx)
 	}
 
 	pdev->irq = pci_irq_vector(pdev, 0);
+	wx->num_q_vectors = 1;
 
 	return 0;
 }
-- 
2.43.0



