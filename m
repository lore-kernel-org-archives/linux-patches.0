Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036134;
	b=PwdGzyHpTr56IKmcH3JJePFzV7zQfzoo1nxObXSCfjGx5zj8k7t/uCFZ1/C4vTkF2MQ3
	 nSvhdu7s2/ejvWNYK/zjN7CZ5AwUGhuSz+5c/qjkPxyt72znfEmdn3LMQfxg5VyZ40N8u
	 WvTO8DbazrJT1DzDF9bl/Vf+oXpMIZZkNqzsrk0Q+tu6ho7rIeJy6qqrl2sO+LBU+SA9S
	 fvx9rAaHFYGf1j/di7rV6yKd+MmiYzbWrDgy4ZayGRUeDU3D+Nv+WRZj5U8eDojl/Z03W
	 X1Vatw1lrQPZRAJls/VUMcwoCVyw8M7Usd51wfWnWeAdD4eyAwlJgzYL1Lw6gorpQVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gtS3XB1OqFh3Hn0CPlE1oRcFP3wZkA8Y91rPb1NTBlQ=;
	b=LOO2ibn9al83lBwfkjklNEQAqp3mTXwtimTxWhGhTAAJh80m/vRItPFViP8nNFH+BLh0
	 xbBnrH5XP3tEduEUiVRfY9zKsX4RUOrRrcaqIiLwQlvLi1xc/YVQ2g9RyimqtIjRVnfCk
	 Xi+VARZZaUxkGbpx0uzV/GTKwM3YUbaQF2SZbcZoXkIrLpDSeuT5VNOoTXOwSih9w7fHG
	 esn/0TDqOuPra1i1D47Pf98rh3/pBZ5I+8AoSaJ366ETzY7wWLcEeU1ZdmAXl2ryQnHJW
	 KhaaPL6bVtzgaLnd+bN7CfTA6xxQiFhyzSCGTn3usoKSF39RfI5j6MI2+AvSIExp69Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GliixjTo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586D6606A320;
	Wed, 18 Nov 2026 21:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GliixjTo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A772E1F000C4;
	Wed, 18 Nov 2026 21:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036134;
	bh=gtS3XB1OqFh3Hn0CPlE1oRcFP3wZkA8Y91rPb1NTBlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GliixjToONk3dxSKH/NCHcgvA8EWz893g6SnXksNdZ8wii1u+QG0ULthEecDW134t
	 QKggmqHqADVuQ6b1exUs3qZOS7K5sQDtJ26Foc2hJ+LfAX6d4Ymgp75OfCVYvowou+
	 9j+BTEHv6l4/XDD4sgIiktoy4IrU6cNRG79EzrhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0924/3318] media: vpif_display: Fix i2c adapter reference leak in vpif_probe()
Date: Wed, 18 Nov 2026 15:25:46 +0100
Message-ID: <20261118150347.257782402@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit f5863ea3f99265e5e297e3dcf0f47432fee2b8ac ]

vpif_probe() takes a reference to the i2c adapter with
i2c_get_adapter() and passes it to v4l2_i2c_new_subdev_board(),
which does not consume it, but the reference is never released, so
it is leaked both when the probe succeeds and when it fails after
the adapter has been acquired.

Release the reference with i2c_put_adapter() on the success path and
in the probe_subdev_out cleanup.

Fixes: e7332e3a552f ("V4L/DVB (12176): davinci/vpif_display: Add VPIF display driver")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti/davinci/vpif_display.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/ti/davinci/vpif_display.c b/drivers/media/platform/ti/davinci/vpif_display.c
index 70c8e32398ab9..6e37d046d9673 100644
--- a/drivers/media/platform/ti/davinci/vpif_display.c
+++ b/drivers/media/platform/ti/davinci/vpif_display.c
@@ -1290,9 +1290,12 @@ static int vpif_probe(struct platform_device *pdev)
 	if (err)
 		goto probe_subdev_out;
 
+	i2c_put_adapter(i2c_adap);
+
 	return 0;
 
 probe_subdev_out:
+	i2c_put_adapter(i2c_adap);
 	kfree(vpif_obj.sd);
 vpif_unregister:
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
-- 
2.53.0



