Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039324;
	b=bq7zjlMIG72zbCgzdYLv0u595w/FR4OcohoBteIeObZhphnJL9NG5fRSewYrQ6EWTbEo
	 MSmCcbvdyLqII7xW/sv32WzWH4VJcrShHTNzUum0WKq2FTBr5VE+ndDNz3cYqKzCAY+0W
	 z15WUfVRo5okHnNN5uLg31Hl3vh4Y0voHtGAofp/MlbAHOBYPTjZbGZ2eLM5a0kCBisbK
	 BngzjpjD3z+78jfQ1CdhCZYg4ji2YYEEISNvy1jSpu/qPIuMWkQBQBZ8hOihNVSFUnsIy
	 PxKXZMuPBc2YT1MBK5foByds8egK7/mcByVLplGre6niv4O1X5WvkciG+73RDdi0/xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039324;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xNxzgwjewfuXOGt7XpUdTFCS6FAw5QdmEyt+WfkBqX8=;
	b=EDZzKVtpi3y6/d5f6w8iH16nRkTE7QD9GUPaAZzriaybP0v8NCiEmH5lulwFzwe4Qwey
	 5DcIIXK92fs3bNxQe6oACJ0qZt1VSIHPFHevvWe0Uegvixa+J9SOrOl6FenWHdX9RIXME
	 /gzy14czxg79K1+gn17EltVL2S04aq7rhgC4nT3dXDorsG2eoja9RtuIZQXne0We8hcg+
	 MOLeyOmnkStV1rY/gsbSyVkasF859DwjO8xA78ib1TEpyO7ynO7t+aRfgaRtreB8CUK/p
	 fLfOCxoYbDauVQKWYPp0uf+U0k0ZcgKKqCx1vUk1J55xRc3pq2asoaoJXCmjQl+51sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gRBpaqfr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E4B606A320;
	Wed, 18 Nov 2026 22:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gRBpaqfr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948521F000C6;
	Wed, 18 Nov 2026 22:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039324;
	bh=xNxzgwjewfuXOGt7XpUdTFCS6FAw5QdmEyt+WfkBqX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gRBpaqfrdtunBQcbquIdGIp7+UJkcWuQTfOccMuaF1bfOG/DCO2s0jcCZkjq/FZKj
	 U5gPUu7IjfAxMUYLaGiFHJkyqOdejo3fqMGnjAqPz5J3/Qdug5nsuGup0xxmTWcutf
	 3kJXJzCNU/tVGrpFZqsqN7BCKxUv6Sl1nHYf0bOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2061/3318] spi: mtk-nor: fix runtime PM usage count leak in probe error path
Date: Wed, 18 Nov 2026 15:44:43 +0100
Message-ID: <20261118150423.898614048@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 4cee1ed13e2687f1a9fec7dd50e31eb179506d75 ]

mtk_nor_probe() takes a runtime PM reference with
pm_runtime_get_noresume() before registering the controller, but the
error path never drops it.

Balance the get with pm_runtime_put_noidle() in the error path.

Fixes: 3bfd9103c7af ("spi: spi-mtk-nor: Add power management support")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260904-mtk-nor-v1-1-cefdca098f83@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mtk-nor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-mtk-nor.c b/drivers/spi/spi-mtk-nor.c
index d20c3984f2a09..0d55bcee5261e 100644
--- a/drivers/spi/spi-mtk-nor.c
+++ b/drivers/spi/spi-mtk-nor.c
@@ -926,6 +926,7 @@ static int mtk_nor_probe(struct platform_device *pdev)
 	return 0;
 
 err_probe:
+	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-- 
2.53.0



