Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E321E39EF1F;
	Sat, 12 Sep 2026 18:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238409; cv=none; b=teGfu5V1CJe+O1mJzBWOLLcMbQerLbsO1fBpYHW5bno/HYd7fh+KPDmq/WsVbyrREmc16fKbQba6WpcvqQ/rGRGXN749pyu+ZR9dY7olHpNcWCN7kydiVGueCT2NWoSbOFM9G4dbmwC1j0ommIamKlyOfVLuaDU5vaOYB5tDjf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238409; c=relaxed/simple;
	bh=Iv+WAHY3MzA5psizpYcUL70+PGX8DrHYxwtc5VMi9t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FaUas3nc8a9UTbR8ydJ3/RbDnhu8S9MskK71lQQr3LkiOODv32xZMPdPtcwQJj7sMd0sjJjqnA+dSVHBTnjBcvnIAD6lFHJ5JfuxNTnxoK2uRZUA4b7C5Xo35uh6mT+eSQwekE6fjSvnHmBuP1XYxqIi+cy3EU3mLwUGyUHXSPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CjfSzzXK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CjfSzzXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6581F00893;
	Sat, 12 Sep 2026 18:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238404;
	bh=fvdePoLNk3uktG/u4T7IdX9TqSVWvmsB5aABQHPLMBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CjfSzzXK/PJsJx3w47jWV9hy8jJKx4GL5nTlliKeyMn0N+XG7kU6K2wiQQdjhb+cp
	 bxb1bBkjVDdpismlnYwHdN4Du9uFbdVXevTXuGE8x7eL8ZIaiqQJmph+kSccZxaLTX
	 /1Be1LZ5q0fHMTInNs9AbNbJQ9Cd101y0DZTItuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuvraj Singh Chauhan <ysinghcin@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 456/935] staging: octeon: fix free_irq dev_id mismatch in cvm_oct_rx_shutdown
Date: Sat, 12 Sep 2026 08:58:06 +0200
Message-ID: <20260912065537.286536124@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Yuvraj Singh Chauhan <ysinghcin@gmail.com>

[ Upstream commit 41db5b76eeb4cc11a1097384caba7cfc659f7293 ]

In cvm_oct_rx_initialize(), request_irq() is called with
&oct_rx_group[i].napi as the dev_id:

	request_irq(oct_rx_group[i].irq, cvm_oct_do_interrupt, 0, "Ethernet",
							&oct_rx_group[i].napi);

However, cvm_oct_rx_shutdown() passes cvm_oct_device (an array of
struct net_device pointers) as the dev_id to free_irq():

  free_irq(oct_rx_group[i].irq, cvm_oct_device);

Since __free_irq() matches the action to remove by comparing
dev_id pointers, the mismatched cookie means the IRQ handler is
never found, triggering a WARN and leaving the IRQ line permanently
allocated. This prevents proper driver cleanup on module removal.

Fix the mismatch by passing &oct_rx_group[i].napi as the dev_id
to free_irq(), matching what was used during request_irq().

Signed-off-by: Yuvraj Singh Chauhan <ysinghcin@gmail.com>
Link: https://patch.msgid.link/20260212171903.1417804-1-ysinghcin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: c0a9a8586a63 ("staging: octeon: add missing napi_disable in cvm_oct_rx_shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/octeon/ethernet-rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 965330eec80a8..d0b43d50b83ce 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -535,7 +535,7 @@ void cvm_oct_rx_shutdown(void)
 			cvmx_write_csr(CVMX_POW_WQ_INT_THRX(i), 0);
 
 		/* Free the interrupt handler */
-		free_irq(oct_rx_group[i].irq, cvm_oct_device);
+		free_irq(oct_rx_group[i].irq, &oct_rx_group[i].napi);
 
 		netif_napi_del(&oct_rx_group[i].napi);
 	}
-- 
2.53.0



