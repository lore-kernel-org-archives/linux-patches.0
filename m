Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1742A2EAE6;
	Mon, 23 Dec 2024 16:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969878; cv=none; b=oCVRU4xCs7ZlzrXDHRBtdgs+kh8NaEDXldMOEli1RNh6eB5XC00BTNna5HIJP1NAJ1ZQr+lDgKGksXGJTSBp3ZP6ygAbYVFdClh3kWe13Eszm330M9Ye4w8tRDA+NDcdP7AGs3mftKSL723ketgWQJgSEYvYWXiKUxxFvqSGshs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969878; c=relaxed/simple;
	bh=JRbsqXEFsaptyDOdy92ocPr5CfJxyhbN2qLWbZu9KVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpVKGrbtJw4kcOOW9Ese7/UUTRUEJh6bn89uNM/k7xeuBSpBthS39L2NnrQgSjFyUdxgV2EueCYNyg9aqfhFWhOxakmdWcJvs9INc1mF5SmwwpRqSqKDy/ZlD5wb17DdUtqA1szb2H8cYxIDjZUFLZvuUjBW5YAq+swmYckaeOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yn4ktlzy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yn4ktlzy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8121BC4CED3;
	Mon, 23 Dec 2024 16:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969877;
	bh=JRbsqXEFsaptyDOdy92ocPr5CfJxyhbN2qLWbZu9KVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yn4ktlzyoJ+8K8WM4Xcq08OuK/SdERE+vgUR0k+UaP8F+v8OwmSTbGUp6W7XtOARA
	 q8eGMFlizWsyOS+x1Kjwn+Y1w+QYJ8lMJ10L7TZ1VmqjjGGqe6VykjSNUegPJ3t4U0
	 aeTx17i0Bw/4Blm0spiv1+/G/hW1fPGr6rfr7UbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Parthiban Veerasooran <parthiban.veerasooran@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/160] net: ethernet: oa_tc6: fix infinite loop error when tx credits becomes 0
Date: Mon, 23 Dec 2024 16:57:41 +0100
Message-ID: <20241223155410.617950328@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parthiban Veerasooran <parthiban.veerasooran@microchip.com>

[ Upstream commit 7d2f320e12744e5906a4fab40381060a81d22c12 ]

SPI thread wakes up to perform SPI transfer whenever there is an TX skb
from n/w stack or interrupt from MAC-PHY. Ethernet frame from TX skb is
transferred based on the availability tx credits in the MAC-PHY which is
reported from the previous SPI transfer. Sometimes there is a possibility
that TX skb is available to transmit but there is no tx credits from
MAC-PHY. In this case, there will not be any SPI transfer but the thread
will be running in an endless loop until tx credits available again.

So checking the availability of tx credits along with TX skb will prevent
the above infinite loop. When the tx credits available again that will be
notified through interrupt which will trigger the SPI transfer to get the
available tx credits.

Fixes: 53fbde8ab21e ("net: ethernet: oa_tc6: implement transmit path to transfer tx ethernet frames")
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Parthiban Veerasooran <parthiban.veerasooran@microchip.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/oa_tc6.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/oa_tc6.c b/drivers/net/ethernet/oa_tc6.c
index f9c0dcd965c2..4c8b0ca922b7 100644
--- a/drivers/net/ethernet/oa_tc6.c
+++ b/drivers/net/ethernet/oa_tc6.c
@@ -1111,8 +1111,9 @@ static int oa_tc6_spi_thread_handler(void *data)
 		/* This kthread will be waken up if there is a tx skb or mac-phy
 		 * interrupt to perform spi transfer with tx chunks.
 		 */
-		wait_event_interruptible(tc6->spi_wq, tc6->waiting_tx_skb ||
-					 tc6->int_flag ||
+		wait_event_interruptible(tc6->spi_wq, tc6->int_flag ||
+					 (tc6->waiting_tx_skb &&
+					 tc6->tx_credits) ||
 					 kthread_should_stop());
 
 		if (kthread_should_stop())
-- 
2.39.5



