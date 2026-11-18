Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048205;
	b=hXrl4LnyIT2D40IKeOdy5ER6gkVNZbQp+/ReoKsxSLH034VWS7qq0nTWC/ZQJtcjYQUz
	 umdPuTqj0uOv1OWrwFs0IFVpwo3JmTHQqUt+BVcKg7KVgpzJxF8CBD5iRxEzh0pL/ochy
	 /mjfsS4ipQI67D5enO0akYbO+5FnSmXbjXJ7fdFKRX1Olchy9HpezYDsscLghshGwrI7z
	 MMU4M3RjbhrHSryU9n+BBOsq+4LUzI0xpRDBgXiE/lOH402ve8dWeytutfY2eM9X10oTc
	 7PJLtpZ8jByh5O2h5eq/tjxvoZwyS3IK+ZdvFfjXDSbCy5dJtlx+/O/qwgUvPhRvyKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bbu4cBXpPyno0TK1PoN3j1/wNhmYaQKwv1vb29cPCSc=;
	b=BUABKsp3W9M+S6isYpYKtBlBj0mOgFFTQlS0IlCuOuLnwXDFBkg7JGNPyoVSN550rzXO
	 OnX0+uiCyGwH6wPiZ7/nZp1uQpnlUYbwybLYmDv0LU29CzZjIyCk1PeNpaqUB665/w3tW
	 5rszPN6rhXbp4JzkGZfwHrRtkOn+UM8411E5Aq2wbhaZiNdOIxmv2UKl148YRmocVQ+u2
	 GPEDjUTwVb6vxt/IRF+JeFEzZalGOx3KurX9CP4kC48oUI2U6SyfuX0+9ZpSB8LZsq7VJ
	 3QKpoqGgU6mQvgaiyQJMKUNqtT5J8pLhrvEFDDcZ4Owii4lxPbCQyVNF3JhYj4YrugA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xZ8WyJoD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4394606A32C;
	Thu, 19 Nov 2026 00:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xZ8WyJoD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAF41F000C4;
	Thu, 19 Nov 2026 00:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048205;
	bh=bbu4cBXpPyno0TK1PoN3j1/wNhmYaQKwv1vb29cPCSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xZ8WyJoD+P6DeROqbD1wsr1uX+2fdx8j+wUuAC7AR+nOLiV3425xkGA/NT8UnQcso
	 tOT9wkbOZFu2ks23ksMI5v8Sr3yEbtd/9BCfc4OM+2s43lZ9DA8k4VCzgoaXN3wWmn
	 nMoi+FbUXu50+ceTXzHARxHhmdfkZDiGKGdd0ZQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1913/2857] virtio: synchronize callbacks after device reset
Date: Wed, 18 Nov 2026 15:49:07 +0100
Message-ID: <20261118150310.096686434@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit dd75508e6fe77116589c49658d0d18897688dc0b ]

virtio_reset_device says:
	Note: this guarantees that vq callbacks are not in progress
but in practice, only virtio pci correctly synchronizes the cbs.

On other transports, a callback that is already executing, keeps running
while the driver tears down the state it uses.

Add virtio_synchronize_cbs to virtio_reset_device fixing this for all
transports that correctly implement synchronize_cbs().

Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://lore.kernel.org/all/20260818040433.66986-1-kmehltretter@gmail.com/
Fixes: c46eccdaadab ("virtio: document virtio_reset_device")
Tested-by: Karl Mehltretter <kmehltretter@gmail.com>
Acked-by: Karl Mehltretter <kmehltretter@gmail.com>
Assisted-by: LLM
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <8ae2995ee649adcfe1398f7f1c4fc9f7028c3db1.1789204858.git.mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 0d3481250fb98..0856ea73e83a8 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -231,6 +231,8 @@ void virtio_reset_device(struct virtio_device *dev)
 #endif
 
 	dev->config->reset(dev);
+	/* Flush pending VQ/configuration callbacks. */
+	virtio_synchronize_cbs(dev);
 }
 EXPORT_SYMBOL_GPL(virtio_reset_device);
 
-- 
2.53.0



