Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215783;
	b=G3XU7ISNsBMks8r9aMg4dbRRYteFLI4rVKOiW4STVIdwkzgn7TWot9g2PuZnVGwb4nWs
	 +BUr4NjGJTy284EncfnosWiVwsJDquJGCA54EtF9WIa5rJLissRC6Off2gvsD1wW5Mvf/
	 4ebkqF/v4jdu6plvnqkSmalKtZsg63au0SCrxStCwKIBp1IIP0EwwonZW0UPMDoxMKHMU
	 gX9sKstiM/MHapSF47TyZhi+g/ybpOExpJVXzPqMHT5O8fSlgVvqKjyT+Y5s1mbOMm1Yc
	 2O9RAkFkOU3+eq9ntcgITQHs5CRpO5iJetO4i545wrub6RsdCpXnaW1tk7dIIQa6M+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yw1F06A3DceixhU3XrUIt3ebJYMiXoOlFxw4zu7QmfY=;
	b=v/f0ao8XYaadTgBl4skD2iIN0eyvXXUO18S3A4czCbOYcPcfSdhzFrBhUp5msD2hvkPy
	 Rfa0NZmAdCB+2NMWi7khD0lHg7FskBwz2TYeZ819ktul+OA41zqfDIJUwADeHIuu6jnc9
	 Uu1NdVk4Nc6069jREeVKsWnmN97UQZWKoWEqS7xIzCaJyzLWE0VB6Qupz1f3tiduJw41f
	 wF1ZsjHui242rS50RqS1R1OLntW3q+fJfiPHPfgGyphF9LUoTxKu5d9Ym81NWHbb6ugKQ
	 7Z8EhUlUqRGVX+DdYTexAw7bt4DDgFICsjELwJiio3jaCxxGwA9TPNssw0HvIXFm7ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zpyVRG26;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632CF606A327;
	Wed, 28 Oct 2026 19:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zpyVRG26
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED551F01825;
	Wed, 28 Oct 2026 19:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215783;
	bh=yw1F06A3DceixhU3XrUIt3ebJYMiXoOlFxw4zu7QmfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zpyVRG26442eTnSyK8Bh7AObvsRIaVzupwrmb2WdLYcS1LIVgLay5Sys0TkqtWCZS
	 3doj5jqcXnJ+LrVPK0FuiSeIwrJLXeFHPqtN/kXbMmxVX0RggiBnq/L2hFd2Wbocvs
	 NDR+prTT9y2iVSsJmIUuEypX9M174DIyuij94pkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1332/1887] soc: xilinx: Shutdown and free rx mailbox channel
Date: Wed, 28 Oct 2026 17:57:08 +0100
Message-ID: <20261028170529.745749415@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prasanna Kumar T S M <ptsm@linux.microsoft.com>

[ Upstream commit fdee7c66c0d7b6869c36b9f9a915abf29ab5b550 ]

A mbox rx channel is requested using mbox_request_channel_byname() in
probe. In remove callback, the rx mailbox channel is cleaned up when the
rx_chan is NULL due to incorrect condition check. The mailbox channel is
not shutdown and it can receive messages even after the device removal.
This leads to use after free. Also the channel resources are not freed.
Fix this by checking the rx_chan correctly.

Fixes: ffdbae28d9d1a ("drivers: soc: xilinx: Use mailbox IPI callback")
Signed-off-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Signed-off-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/20260320060445.1541017-1-ptsm@linux.microsoft.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/xilinx/zynqmp_power.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/xilinx/zynqmp_power.c b/drivers/soc/xilinx/zynqmp_power.c
index f50fc8bf67e9e..b2e36a06921f2 100644
--- a/drivers/soc/xilinx/zynqmp_power.c
+++ b/drivers/soc/xilinx/zynqmp_power.c
@@ -282,8 +282,10 @@ static void zynqmp_pm_remove(struct platform_device *pdev)
 	if (event_registered)
 		xlnx_unregister_event(PM_INIT_SUSPEND_CB, 0, 0, suspend_event_callback, NULL);
 
-	if (!rx_chan)
+	if (rx_chan) {
 		mbox_free_channel(rx_chan);
+		rx_chan = NULL;
+	}
 }
 
 static const struct of_device_id pm_of_match[] = {
-- 
2.53.0



