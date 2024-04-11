Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7D51474C2;
	Thu, 11 Apr 2024 10:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831386; cv=none; b=f6rckhdVahyTxg0oe7uJLUdNOF2GZ9VxqKS7ZYJrBXEAFoXlxS4kagSTYFcmou2Ooh1vpKUuz1xlPUr5a6Q5Fe0D1JFdPatF5OEPHRvUVDjvr7H1KYCxA6rpMM2pX8hTpLLxV5POSHOo+WbOcMgqZPZ2GRdLIXHoCOWzFLebMSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831386; c=relaxed/simple;
	bh=RrONRC/82n3FeBKBGFnQdwg76arPikVI1dzJS4A6/KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOZBROH9XsIZTrtXX4Tji1tGHajvdtQF9Gug0mdnuxWBE3+gmQQSH/c1Q0b2ucjTdZJLP9bgSdyt4qtpqr8jLZsCzp0Pcb5PzJVnU3tJe32g45wLQ+zGwduyl3QQ2Kv1D0ZYnnnRGdPcnZFpZejlxWCAYNctJztNgLVwT95Ebr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ua13dUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ua13dUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27342C43330;
	Thu, 11 Apr 2024 10:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831386;
	bh=RrONRC/82n3FeBKBGFnQdwg76arPikVI1dzJS4A6/KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ua13dUoREYteeWQSpcEirNfuyYhJ6ncd4DbFMFS7vKVTJeyZZJPFjgP4QeoPS6g8
	 klKJ3GyMciXDw+uVj9uVUJh1gYQJp/1UID1+tOvVVcXVrDxTYSx9W1IfQy30jwIdZ9
	 1RxHj7CCqGJH2BTNn98uZqQRwqhTSwTIoAOgWfyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/114] i2c: designware: Fix RX FIFO depth define on Wangxun 10Gb NIC
Date: Thu, 11 Apr 2024 11:56:33 +0200
Message-ID: <20240411095418.877801192@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit c94612a72ac87b0337a0d85b9263266776ed4190 ]

I believe RX FIFO depth define 0 is incorrect on Wangxun 10Gb NIC. It
must be at least 1 since code is able to read received data from the
DW_IC_DATA_CMD register.

For now this define is irrelevant since the txgbe_i2c_dw_xfer_quirk()
doesn't use the rx_fifo_depth member variable of struct dw_i2c_dev but
is needed when converting code into generic polling mode implementation.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Tested-by: Jiawen Wu <jiawenwu@trustnetic.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index a7f6f3eafad7d..ae835000fd32a 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -318,7 +318,7 @@ struct dw_i2c_dev {
 #define AMD_UCSI_INTR_EN			0xd
 
 #define TXGBE_TX_FIFO_DEPTH			4
-#define TXGBE_RX_FIFO_DEPTH			0
+#define TXGBE_RX_FIFO_DEPTH			1
 
 struct i2c_dw_semaphore_callbacks {
 	int	(*probe)(struct dw_i2c_dev *dev);
-- 
2.43.0



