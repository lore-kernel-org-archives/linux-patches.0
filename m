Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F597374CC;
	Wed,  7 Aug 2024 15:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043650; cv=none; b=u1zK8/BU711FoijwnNpnKB0l1otdG7vfKeZXEEYLrn0T2gRuimegrCDdi/2WZh/yvExUikVhtyPy7fLDi0Gvn8BYXGNlAxqedywuzD+239EP7ZEo9To+fuegok4AiRX8eav4eWEk9FRJZDWqVX7ZyUylAL9/bDAoqGFzE+fOUgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043650; c=relaxed/simple;
	bh=F7OpvfJQPrbGIvuc5aiPbMz/6WUGgZlEdpE5lBh+vO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1zSbBBEFCj/mPHRNOyVWJXTOjXkqLWKliJU0PUVpMutAQF9EAGXT9p4rFw71MpExKOKpOQEH81c4tZzTu2OeurDDxN7YtC9PflHa6411uy7bdD4txyzZ05AuDr6mG/jBydKI2wr70JEP091I0QSwosCW2oiKE9LPVMwFRX8GjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2rJVLC+e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2rJVLC+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21211C32781;
	Wed,  7 Aug 2024 15:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043650;
	bh=F7OpvfJQPrbGIvuc5aiPbMz/6WUGgZlEdpE5lBh+vO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2rJVLC+e66bCHRRnho0UcNyCL/yrtBTuraPtWwbh9V5dgesZ4j3JLMUb8NwhSvUXU
	 ctE9VIA/6qR5AFt5wzTYOf/Yy2Z6a+Vltfif2LznE9b+L7M0/xoc3C+Fj7DeDn+QgN
	 L1i3ZtPH2HRphH6aORjX5mNI9uFBcLZfDAav66+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Chiu <andy.chiu@sifive.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 48/86] net: axienet: start napi before enabling Rx/Tx
Date: Wed,  7 Aug 2024 17:00:27 +0200
Message-ID: <20240807150040.825802611@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5ea9dc251dd9a..ff777735be66b 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1825,9 +1825,9 @@ static void axienet_dma_err_handler(struct work_struct *work)
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



