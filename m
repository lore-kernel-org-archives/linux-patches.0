Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06725470454;
	Tue, 21 Jul 2026 20:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664128; cv=none; b=MFoAKMrQ3w1vWLi/EPHO4SoAqCz0a8p2YtzEyw6J+MgRCe1cy8GmiPVvVMWz+QuzSJhXzJGo9BAn/nD77SqDp159J78CBn0CDTPUgp0UaKMiFbIYjACIr9FubsLkizotu9XbqWTGfzDLqhscJ8YoUqdK5jjGkbXFthGUvU5NI1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664128; c=relaxed/simple;
	bh=OSMSFctLcbByDxeNU7JmVnahsHgPxTrMMGX3tMlMuJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTa045L/9GcVDpyuYzd3aSSBfxI7HSEkPSmJDSpAk7Xz5DLveKbPsNLuTFSxf19WM0gmZZxj+Wp2A10w346cTmKvnDoIi5vWD6OX0f6rVDm0Ug8sDBrIaiaEeEehB4QqCMjk8pl2uuSxHiBY1wB+xhI+w51bP+6sfahvMcfPIJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pxy883Rm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pxy883Rm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3811F000E9;
	Tue, 21 Jul 2026 20:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664125;
	bh=N1gtkm0mER5ybBIpapjR2r8G9pWo0BMCqXTgdXnbryQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pxy883RmUxouX1EwkAr7zI2c0rqlemVyTfZb7d4b190LbIWit7vk3b0D8k1Jv2ZK8
	 LyoQwUVVKcl0RG2jTeP55r8Mr5fswsXquWKjVtaC3MvJoZmkw8qId07OD9DgEIr2DY
	 Pl6HSbzwsn6hUIPzilqyUm6DUYGaGpITuOJOVX/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.12 1082/1276] ata: pata_pxa: Fix DMA channel leak on probe error
Date: Tue, 21 Jul 2026 17:25:25 +0200
Message-ID: <20260721152510.197847581@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit fcaf242e7fc406e78f444a35441e3b58f5e28781 upstream.

When dmaengine_slave_config() fails, the DMA channel acquired by
dma_request_chan() is not released before returning the error,
leaking the channel reference.

Fix by adding dma_release_channel() in the error path.

The ata_host_activate() error path already correctly releases the
DMA channel.

Cc: stable@vger.kernel.org
Fixes: 88622d80af82 ("ata: pata_pxa: dmaengine conversion")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/pata_pxa.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/pata_pxa.c
+++ b/drivers/ata/pata_pxa.c
@@ -286,6 +286,7 @@ static int pxa_ata_probe(struct platform
 	ret = dmaengine_slave_config(data->dma_chan, &config);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "dma configuration failed: %d\n", ret);
+		dma_release_channel(data->dma_chan);
 		return ret;
 	}
 


