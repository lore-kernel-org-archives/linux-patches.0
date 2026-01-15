Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA5C3A7F43;
	Thu, 15 Jan 2026 16:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496375; cv=none; b=QdBXfPX0Bpb5hdFfJSkxDzRXt7XDXW6eWo6keUacNlUGydJud1M78lKVLxMYZyV2uwLRqWpv7lbPV91ZSMy9gxhwgSB+0rZxNWGwwUNgKfaXVwKV6yqtb0sVmHxkUfyQ8Pc/vmz8ddDDLS8ayeHUmCOhbpUpuUTmid7Trl2IqTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496375; c=relaxed/simple;
	bh=Ax3Iy1fLwctqGtM++9GeqvO6pXlnjihLw4+ZB6LWP1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKbp1EWyqo/8rmDpfqb03Dqvw4qOqcgEArq/NhqXvL4ZFSWjD9+5Tf5swM1lme+GNOkFwWH+V45gnrohPu9WSogTYFJVT+2oxsd+Fe8cxYOuLSEfPVEaLTrzSsKBFn8+SnzrUwoL3oQVJFAvaVTRUCfmiXDU1CprbMb60CaANhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LEudPQ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LEudPQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB88C116D0;
	Thu, 15 Jan 2026 16:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496375;
	bh=Ax3Iy1fLwctqGtM++9GeqvO6pXlnjihLw4+ZB6LWP1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0LEudPQ+1r6Ld+qouP4YGvDX6+dkf9q01Ju8962yWMGA8+CEQHmdPpicuuR65nBwq
	 KKFPmX/8qtf6RWv6mt29FTVA6EubKwLDHgwgRHxnMdLzOyoa4i0avS+7U4yWPphCv9
	 JEwTix2C1qvoWrZmgC8OEUVmeVyotcbyGQEsy48w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 172/181] spi: mt65xx: Use IRQF_ONESHOT with threaded IRQ
Date: Thu, 15 Jan 2026 17:48:29 +0100
Message-ID: <20260115164208.521711532@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Fei Shao <fshao@chromium.org>

[ Upstream commit 8c04b77f87e6e321ae6acd28ce1de5553916153f ]

This driver is migrated to use threaded IRQ since commit 5972eb05ca32
("spi: spi-mt65xx: Use threaded interrupt for non-SPIMEM transfer"), and
we almost always want to disable the interrupt line to avoid excess
interrupts while the threaded handler is processing SPI transfer.
Use IRQF_ONESHOT for that purpose.

In practice, we see MediaTek devices show SPI transfer timeout errors
when communicating with ChromeOS EC in certain scenarios, and with
IRQF_ONESHOT, the issue goes away.

Signed-off-by: Fei Shao <fshao@chromium.org>
Link: https://patch.msgid.link/20251217101131.1975131-1-fshao@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mt65xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-mt65xx.c b/drivers/spi/spi-mt65xx.c
index 4b40985af1eaf..90e5813cfdc33 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -1320,7 +1320,7 @@ static int mtk_spi_probe(struct platform_device *pdev)
 
 	ret = devm_request_threaded_irq(dev, irq, mtk_spi_interrupt,
 					mtk_spi_interrupt_thread,
-					IRQF_TRIGGER_NONE, dev_name(dev), host);
+					IRQF_ONESHOT, dev_name(dev), host);
 	if (ret)
 		return dev_err_probe(dev, ret, "failed to register irq\n");
 
-- 
2.51.0



