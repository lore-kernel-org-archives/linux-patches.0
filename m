Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0039E1EBA1F;
	Tue, 15 Oct 2024 12:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994379; cv=none; b=MyPFwMp4n1y14FnzxRaVUsdyHC9gHkm2va00jDhqj1DHmSOk7+x+I2muOUubaJnIuBdRWvXMrec4Y9KD0pvY+4LHz8yowDkckmrPAS1yJ7GOsDKbi2w7yBfCfc5+UjtGiL/sGZ+dpitvgcTSNGONIvAA7G4qobLlSYA+fe0duHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994379; c=relaxed/simple;
	bh=kF/rFgNEfzSsoH+DWo4omnY1nco4A2xDVGMAPP37NJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImES69DOqN4VM74aRZ/ZmqZTqkM51srw7oskNj25B+7aBgZHu4nV2ZLJyZ9UrnWgioWvT9rPwwwK7cUgL4/wusez8+EXEi7pPBD1YUwm7CsProB52RF+/tFwyaDavipXCdo868FCg/2QR9rrKxEBQp4LVxmQNOmCqz0kYvlZi8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JsYpJRDO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JsYpJRDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696C6C4CEC6;
	Tue, 15 Oct 2024 12:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994378;
	bh=kF/rFgNEfzSsoH+DWo4omnY1nco4A2xDVGMAPP37NJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JsYpJRDOxx/Cg3L4fcGw2l1vPzXcqULPgL5ZUUXW3e1RI/757HK8I5VoDsJ2lQpaX
	 rOQN77FmKRf9m2Nw8otHhHilywhCWRLu8zXY7mInaIhGKaikRKkMh1u1zyKS/+AWgj
	 OzcX4ZukKMwENVCPYT5y6bD03vgiV+IblQDSnyW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Chiu <andy.chiu@sifive.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 689/691] net: axienet: start napi before enabling Rx/Tx
Date: Tue, 15 Oct 2024 13:30:37 +0200
Message-ID: <20241015112507.664584722@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Chiu <andy.chiu@sifive.com>

commit 799a829507506924add8a7620493adc1c3cfda30 upstream.

softirq may get lost if an Rx interrupt comes before we call
napi_enable. Move napi_enable in front of axienet_setoptions(), which
turns on the device, to address the issue.

Link: https://lists.gnu.org/archive/html/qemu-devel/2024-07/msg06160.html
Fixes: cc37610caaf8 ("net: axienet: implement NAPI and GRO receive")
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1912,9 +1912,9 @@ static void axienet_dma_err_handler(stru
 			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
 	axienet_set_mac_address(ndev, NULL);
 	axienet_set_multicast_list(ndev);
-	axienet_setoptions(ndev, lp->options);
 	napi_enable(&lp->napi_rx);
 	napi_enable(&lp->napi_tx);
+	axienet_setoptions(ndev, lp->options);
 }
 
 /**


