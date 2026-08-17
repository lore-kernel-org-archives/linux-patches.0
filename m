Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F793D9531;
	Mon, 17 Aug 2026 14:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977524; cv=none; b=XxpjBFaD9yJp+4w0mEtSWLRavrjtJ3mwgGVbV2Q6hDxQuBHw1i4/JlADERqZsj6xhcEN2WFg/845q7kbY/NRxa5MyHgdo7r2GcOYP9zTgVxpE1x1HKAHqQ8X1c94jS0p+fRgy8Xr5zy8goPdLxaeslBQmJ4b3KwcaqS70rf/rtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977524; c=relaxed/simple;
	bh=GGMm50RrXAQuxPlZM2pPPoizkOvCEf8bIElqvJL5a6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIDTqfW/8aJNnArGuXXoiZZLYQy61kWPtp3DoYwmztlEW9au5PCUvr0WMfUiLRmK7wQF06PxSnj1E+VrpxHj46oljVIxtQVnBcau1ONF5Cu3RQyZsYkezsy7UmdMrDw0YConkWoknrllRKY9Xa2a9RP+tP2Oo8o+8ED7JVAuCeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3ihsmhp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3ihsmhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C591F000E9;
	Mon, 17 Aug 2026 14:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977523;
	bh=tcLnQS6HnGjjv0F2DZfvGJR+uBUeIXCZiycre94YXlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G3ihsmhpI38alh+ga3RnjLC38TmPsA5ZH/OgXgThVS8WZzTVBoh4KU56bGgKTKhRq
	 vtayWflY5CctciUoErOqudSUv9JMdCdkRw8mtsbcnM4MPuPmM1jcrtDBam8518pUcs
	 j4A4KUuxx+gI2P4dEAPgdDNZMX7JyHuqFUt230Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Dima Ruinskiy <dima.ruinskiy@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.15 310/456] e1000: fix memory leak in e1000_probe()
Date: Mon, 17 Aug 2026 15:31:40 +0200
Message-ID: <20260817132551.882863577@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Dawei Feng <dawei.feng@seu.edu.cn>

commit 816419dfea5c88126f35eb7a1b429a1bf546665e upstream.

In the e1000_probe() path, e1000_sw_init() allocates adapter->tx_ring and
adapter->rx_ring. If the subsequent CE4100-specific MDIO BAR mapping
fails, the error handling jumps past the ring cleanup code, leaking both
allocations.

Fix this leak by moving the err_mdio_ioremap label above the ring
deallocation logic. This guarantees the proper release of these resources
and prevents the memory leak.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1-rc6.

An x86_64 allyesconfig build showed no new warnings. As we do not have a
CE4100 reference platform to test with, no runtime testing was able to
be performed.

Fixes: 5377a4160bb65 ("e1000: Add support for the CE4100 reference platform")
Cc: stable@vger.kernel.org
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Reviewed-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -1228,11 +1228,11 @@ err_eeprom:
 
 	if (hw->flash_address)
 		iounmap(hw->flash_address);
+err_mdio_ioremap:
 	kfree(adapter->tx_ring);
 	kfree(adapter->rx_ring);
 err_dma:
 err_sw_init:
-err_mdio_ioremap:
 	iounmap(hw->ce4100_gbe_mdio_base_virt);
 	iounmap(hw->hw_addr);
 err_ioremap:


