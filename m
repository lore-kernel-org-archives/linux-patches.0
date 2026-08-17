Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70248153BE9;
	Mon, 17 Aug 2026 14:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976578; cv=none; b=lBJ+4AgGsCMosQ39LSo9gHgfw76FTcCwBxOm+CNloXENBAKZQv46dw5lvznjGT6MIzXAJJv0GSDxodSTaT4xo24EhQbe9WBTc1RwbGvJxhW1SwP1b2PLZeSQ1FUhlwnFWvmU0L9rYnWriK8Pk/UR5bni0FZ+AnWN+0QAa6ycKGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976578; c=relaxed/simple;
	bh=l7W5QGaPnwQ8CwK7QAs9nYGmVtibNG3Nezo1MlI2R68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A801L5LjGQ9/OBbU6O97FpjHy2STAZvNZNukhflI3SKjIbjWbtv2mMx1i2rVt9Axt7aPeiVHSsNrCmKV6cqumIZ6vL1NKa6IqBjjxdhTVwJskclgi7Ib28KXpIAEEYZ5NsfFXIJe8rixlsreaEIhit62RYSXsBQKczTrE5wQqPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pKm6H+Ae; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pKm6H+Ae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6611F000E9;
	Mon, 17 Aug 2026 14:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976577;
	bh=fX2OKHCPNWm2Z+dqZehspetP89kwWKyaZNBq2/JOXZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pKm6H+AevOYxX7Ty4ftm9ae4r/00d++cbHE7tJuAPnovWoLp9+9hXvq5ZGYvQABUO
	 g0qSoGPAxHEDNXp31B1crHNlaVywumQ2/IwG4JLE1JFiAqrY+jL+P/y/VAl7PzkvS9
	 Hjv9Bwzl0ob74cZUvr1LSEL4oesSYUu7zWFje3UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/456] wifi: brcmfmac: initialize SDIO data work before cleanup
Date: Mon, 17 Aug 2026 15:27:02 +0200
Message-ID: <20260817132541.267539114@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 2a665946e0407a05a3f81bd56a08553c446498e0 ]

brcmf_sdio_probe() stores the newly allocated bus in sdiodev->bus before
allocating the ordered workqueue. If that allocation fails, the function
jumps to fail and calls brcmf_sdio_remove().

brcmf_sdio_remove() unconditionally cancels bus->datawork. Initialize the
work item before the first failure path that can reach brcmf_sdio_remove(),
so the cleanup path always observes a valid work object.

This issue was found by our static analysis tool and then confirmed by
manual review of the probe error path and the remove-time work drain. The
problem pattern is an early setup failure that reaches a cleanup helper
which cancels an embedded work item before its initializer has run.

A QEMU PoC forced alloc_ordered_workqueue() to fail at the same point in
brcmf_sdio_probe(), before INIT_WORK(&bus->datawork) is reached. The
resulting fail path calls brcmf_sdio_remove(), and DEBUG_OBJECTS reports
the invalid work drain with brcmf_sdio_probe() and brcmf_sdio_remove() in
the stack.

Fixes: 9982464379e8 ("brcmfmac: make sdio suspend wait for threads to freeze")
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260619064401.1048976-1-runyu.xiao@seu.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 76b2953725c2d0..696f3aa32adcff 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4451,6 +4451,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	bus->sdiodev = sdiodev;
 	sdiodev->bus = bus;
 	skb_queue_head_init(&bus->glom);
+	INIT_WORK(&bus->datawork, brcmf_sdio_dataworker);
 	bus->txbound = BRCMF_TXBOUND;
 	bus->rxbound = BRCMF_RXBOUND;
 	bus->txminmax = BRCMF_TXMINMAX;
@@ -4464,7 +4465,6 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 		goto fail;
 	}
 	brcmf_sdiod_freezer_count(sdiodev);
-	INIT_WORK(&bus->datawork, brcmf_sdio_dataworker);
 	bus->brcmf_wq = wq;
 
 	/* attempt to attach to the dongle */
-- 
2.53.0



