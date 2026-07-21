Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A520C2D7DF1;
	Tue, 21 Jul 2026 22:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674576; cv=none; b=oD7IpfmnzvVWnyZDLJdPfjXupFDJW70LRoObMeO+HJpg1/qUTQEFQb8JSHsbGospR59b1Xse0wFJj/f5F/f5VcvazNGEXu9N6q71c+7ixeRFVRiqo7KXDzRnP1IYfGO+k1SRVIYhWZWxhvYPQdS/DENM4uqlVS6tF/JRAw0bZGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674576; c=relaxed/simple;
	bh=uRSMGwwypcZVaX98A2EGNDtHAZiukGmWkzxBCAyX3OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2IWogNOZKhhHOIQlylOikN0mcmm288/0kvPVCXrJWEyV0/BGlP7wSIYGgGPR9lfTOEmsCIJA8M9DvUIhMSsR+3MmA2TzyQawLtu76KZLIC1kEX4CrWPzbLXtxTMDmMvjS9kNqaZGhcki1x4YdjfZZZ8PMPGhBUVmZA7LqtVW6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eaeXKdm9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eaeXKdm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173EB1F00A3A;
	Tue, 21 Jul 2026 22:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674575;
	bh=rOkyrbxOOhFZKD32MOPYaKvuS4vGfaIeHOTz0iI9TJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eaeXKdm94GSIHAv6TgwacmrW5g70jXFGM1cDgwQX4pXul5ajzdQbxeaLvz+joCG2s
	 wZPGTyDaA1dis1GGSVgE8IxE6xoBRnqtzMi5ESaX/u7YcYlVoHOD4ADo0gSmzVw3vL
	 lwsZd2hPFFZwHembIqvwGw6RUYQfVjq6hfGN1HAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 5.10 550/699] ata: pata_pxa: Fix DMA channel leak on probe error
Date: Tue, 21 Jul 2026 17:25:09 +0200
Message-ID: <20260721152408.108412843@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -287,6 +287,7 @@ static int pxa_ata_probe(struct platform
 	ret = dmaengine_slave_config(data->dma_chan, &config);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "dma configuration failed: %d\n", ret);
+		dma_release_channel(data->dma_chan);
 		return ret;
 	}
 


