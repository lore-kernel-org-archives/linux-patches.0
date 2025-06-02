Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFD6225791;
	Mon,  2 Jun 2025 15:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877437; cv=none; b=e3ZmtinlUTnoa+C9kxdw/J/d0Iclzl6BNr+uLoQkHOFXprPNLzUNgWu00IFTF3i1Js5/vwgrBHBcTWS0brckYoZBSZTA3jnpmeivf2R0H8VUVNC2j5fQPdiI3NrEBuf2MQrEZBsAGhkcXI9qiBKO9YNDEb6U0wiZd87NgeqMEuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877437; c=relaxed/simple;
	bh=YSS5d3cjVWAI58Vg9ddrk3uNTfNq7avB5EI21uxFfSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFUE4YAEx0d3G8m3LHX6vg/1D3VqKqKMugm67wj1A05+ClDE8pK3okPt97RpStZvvhgtXijnt5WffgkMsnid4GWwrEVPT826AVma7I9UYTWE2QRRgDnZaUVStXQKCaIhI46sUUJ2Dzs3V7XBN+VNWAt1ULlNhYtS6wKEHLFAHj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MgiWfgrO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MgiWfgrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED943C4CEEB;
	Mon,  2 Jun 2025 15:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877437;
	bh=YSS5d3cjVWAI58Vg9ddrk3uNTfNq7avB5EI21uxFfSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MgiWfgrO+d2IA1z6ka8wFLpRKdb0ViGSY+oPcLjYf9P9YX78X4h+WzsBmzECBQolt
	 YsuT74FKBGTMJOM3AVSurs7t3h7SXCRZa2ToSoMwi/Vo/OIWABXjayb0SPdMbiak/2
	 EaccVKs4IZRmwCfhQc5fC22p0WBeZR2mOOsQebg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 237/325] dmaengine: idxd: Fix ->poll() return value
Date: Mon,  2 Jun 2025 15:48:33 +0200
Message-ID: <20250602134329.414155224@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit ae74cd15ade833adc289279b5c6f12e78f64d4d7 ]

The fix to block access from different address space did not return a
correct value for ->poll() change.  kernel test bot reported that a
return value of type __poll_t is expected rather than int. Fix to return
POLLNVAL to indicate invalid request.

Fixes: 8dfa57aabff6 ("dmaengine: idxd: Fix allowing write() from different address spaces")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505081851.rwD7jVxg-lkp@intel.com/
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20250508170548.2747425-1-dave.jiang@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/cdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index 186f005bfa8fd..d736ab15ade24 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -333,7 +333,7 @@ static __poll_t idxd_cdev_poll(struct file *filp,
 	__poll_t out = 0;
 
 	if (current->mm != ctx->mm)
-		return -EPERM;
+		return POLLNVAL;
 
 	poll_wait(filp, &wq->err_queue, wait);
 	spin_lock(&idxd->dev_lock);
-- 
2.39.5



