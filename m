Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAE025C804;
	Mon, 17 Aug 2026 15:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978936; cv=none; b=QzhNCFIfc2LrpAzckIk941XV5/eqq8cPowfkg7aiMo6xmIHlZJ4FL1WhW3OlVbDFW3WxMmc2qnBUhMX92NODLzQU9ZA7VhvKzfvcbFTQDzcr2psl85qd8WPIBSqdEohTDfi/Efps4xc9EtBpbfDv85T/pyFkIxjczqbDzICTbO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978936; c=relaxed/simple;
	bh=VkEiw9GfqTpJsl2oRCnVX5mw9c/auVAjGJfOXTHGJpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozwnAN5JxV0Z08Piie2sXl3Fs11ezLp6r1gr6Ae87NdIorStOscU/WBCWmxMs738IHjWIfR4QA3TubpM56mBZ0KZtpTGf4h/5tmhi7u8nb3ePb6c4LRl7Sd9+HDuLe7y2xfG8k/aLymF+ZJ30YpH1wHncNBkdDP0ax1158nrXlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnjpM+QM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnjpM+QM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9485F1F000E9;
	Mon, 17 Aug 2026 15:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978935;
	bh=z9Hd5k9qbuIxYoJTOSRFlTjtMvDmb8BlmDypiPRIg98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xnjpM+QMR2TYie3JVyfaQf7Sm8XV8+Lpm6+oos4wpVZZZSmxKQc9YgjfMre17YyDd
	 /gFxsmtt72dOTcG2z/jAB12QvWkrsJdt4lEwtE+xltuSzk6/443V2i3U4SeJCXAJMY
	 +aVCehpZV3mdW+Wpk8wDAfqGPfg8bf7kp3FCo9vU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/609] wifi: brcmfmac: initialize SDIO data work before cleanup
Date: Mon, 17 Aug 2026 15:25:47 +0200
Message-ID: <20260817132545.110016314@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5f6c0afe22d49c..fb09d76ea053cb 100644
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



