Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B8F471264;
	Tue, 21 Jul 2026 18:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659349; cv=none; b=ZZWootxyCj6uSKPGHMQkU0semIxlHmn5Tq1GMRhN3ahv+0Qc1RLjl8FeZftMZlASKlUqVb6e6qn1MQlw5Fn1Jj02WAQQsL5KsVDLmhTU8MJVqmTLRUynmBdjlWuwCbdFBiENGSvatyqMZrjSPQmsJDzhKgJ3JSSk0OLf22fsWv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659349; c=relaxed/simple;
	bh=16i2uLuJOZqcSHZoHZTDhhSkrWS+/gye/PNP6VNAuls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OI41kBzqBFJdoJpdXDoSxnEQJ4t0jMpNgGffZPF63Hsjcod47Zx066KASbQI/7ByT2Qx1pdfY+DbPVD+LqEhM0brH2LitGrAJyPwXRB6thIylLv9Trcq4W/WXeLNT7lKBDtNZ1NAmEVCDGMU9hloKfZb1gnylWWYHFlUwgYEHW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVnyG3eb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVnyG3eb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B121F000E9;
	Tue, 21 Jul 2026 18:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659348;
	bh=18cBxlhDgZ+wwNileOEDpjMeXmiyzIGCd7iA6OB4lwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VVnyG3ebrdmY3gOMO5PyTvl3hZht81SI1qkyworcocR29ab7RY1Vfp/g+F81Rqn5G
	 v34y+D4PsAzel3DzeWWOkKFvfVi3M6PrA+ji3FcpSvj7+QUbN6jHaNsiSrKZ1lyCte
	 U78I7I7nS5EyUFBcY8HrUR8/vo90dfg2WG1YhWk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.18 1444/1611] ata: pata_pxa: Fix DMA channel leak on probe error
Date: Tue, 21 Jul 2026 17:26:00 +0200
Message-ID: <20260721152547.929896471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


