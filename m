Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6FE78C92;
	Wed,  7 Aug 2024 15:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043371; cv=none; b=moNxWH3yFyvYMlXymhv1PzhDElf1EIFUzNmT2hGSPH1huP3OrkV2oDAv2uo6402n0Y+lfAHtE3qHVoyApl7T7oXYsc6mrfLAF7EZp7apkIG8yyGzCxljJI7EA2bD4JhMGkjJaOMb7Q1O/p7swnd6HOQLBNGLUUwe+DNyXem2yqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043371; c=relaxed/simple;
	bh=QXKaZC3ZWzY8JWXji2VWeDs0HXR4ymfKCR9iRPhp4Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrtOGjGi1fQrvbGFkq7WTAaN4s+AQTXc2IuLRezxQ3ucPP/NMryNun5WzRzUtFNyrg7tE7yg9oezWAwdWBdB09BUFEKTYWhTCTjIK1BQCbYqv3uqE8s8jVO7TFKwWfL2PvEIqTK9tH/2yfRyFyctSGnTVIqFzzQMYLhE4lL9B3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+YVkqR5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+YVkqR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0D0C32781;
	Wed,  7 Aug 2024 15:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043370;
	bh=QXKaZC3ZWzY8JWXji2VWeDs0HXR4ymfKCR9iRPhp4Ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+YVkqR5O7xatGmVF2KGRH4rNsiysMk2X5+RJ6hGJYNJZ51yRrTWIqxgi21kNIw+D
	 ulgkFw4ySGDRNkAfngg1n4QubijCWA+XF1zbXZgDLi7spm6wwzUftFw+zNUoBfiSN8
	 gxbSdRWIJh3LsDmCZ4mW7cxiUrcPoyGb3ByU0+B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Chiu <andy.chiu@sifive.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/121] net: axienet: start napi before enabling Rx/Tx
Date: Wed,  7 Aug 2024 16:59:58 +0200
Message-ID: <20240807150021.561330184@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

From: Andy Chiu <andy.chiu@sifive.com>

[ Upstream commit 799a829507506924add8a7620493adc1c3cfda30 ]

softirq may get lost if an Rx interrupt comes before we call
napi_enable. Move napi_enable in front of axienet_setoptions(), which
turns on the device, to address the issue.

Link: https://lists.gnu.org/archive/html/qemu-devel/2024-07/msg06160.html
Fixes: cc37610caaf8 ("net: axienet: implement NAPI and GRO receive")
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 3297aff969c80..11e08cb8d3c3e 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1826,9 +1826,9 @@ static void axienet_dma_err_handler(struct work_struct *work)
 			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
 	axienet_set_mac_address(ndev, NULL);
 	axienet_set_multicast_list(ndev);
-	axienet_setoptions(ndev, lp->options);
 	napi_enable(&lp->napi_rx);
 	napi_enable(&lp->napi_tx);
+	axienet_setoptions(ndev, lp->options);
 }
 
 /**
-- 
2.43.0



