Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18DF44237E;
	Mon, 17 Aug 2026 14:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976104; cv=none; b=fU+vjOOx9jruTQ+I4zbVa9rzsKiqqZo2rQzl1R/qLeCl8OJKBM5NJ2vdJVuqdZh6jbgwj/Z5FNmwSqls3czo0DTwQOj5/JuvVGn+QD9MPtKL7iGVx9TDo7ii1WOEvAJDpTanPlPjcz+O2qBtB92hN0aYGWF6gB1CE1JTpwgp6vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976104; c=relaxed/simple;
	bh=q5FHQ6SmmbU3hh6VHujcJdlDRTzxSd39vNm/D8RHAuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cbn5t42Cj/M6T4gmy7EZd5s16opnMin+kgvIa4kD9Rt0wjMj2wtrHO7eTdW4tMBZmAHi5RIVRFZAkF8mZHBjt+0WLxqJ6WrXVqITDcBImSdFDevGsDpPhjUjM6tq+cKphLlijkGRUC8KOv0SUXOqtvkoheJkDrSw7bVx9Mlaxpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKlw5pKp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKlw5pKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C2A1F000E9;
	Mon, 17 Aug 2026 14:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976102;
	bh=wsptmkEeHErqfriBYQClCpJqVYyRGsIT9yfA+qWl15Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nKlw5pKptyAJ3fH6xlrfxL6Ii0vaEuz6Nir6vZhJSHaHntLnwQzBMLCuzt0itxfJr
	 2Z3tVld6x1wODz+7RRpp244thD2n+bFDYt4SYLwzt8siQG3gGvMprCmsEHO6HZhNI3
	 Rt+CkQqKOJA+SdffHQdnybREzhCNJ+33wRVGnWQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Dima Ruinskiy <dima.ruinskiy@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 258/389] e1000: fix memory leak in e1000_probe()
Date: Mon, 17 Aug 2026 15:31:37 +0200
Message-ID: <20260817132549.273079861@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


