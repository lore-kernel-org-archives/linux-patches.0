Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425D631A7EA;
	Fri,  9 Jan 2026 11:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959718; cv=none; b=RbzcZf0p04PwUkwHDh6tuRFCj6BjjXgj7xXlGSNrQ7AwmFP/wczVKIm34iN8r0YpBk0Ems9BQBqPx+v7v5d9JKBQ1EkQalKICbjIgKGo+z5lVEniAqhiJ8fvKZ51Y3drNYhGluIF3xQBmD5x13lTY3udd3jTCNHzlVw5vht27hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959718; c=relaxed/simple;
	bh=Lzuw8P07qAwBmBdFElgSBP14cSoY/76iVN09HfLIiFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irPuR4YMk7tnkTaplBh3IWvBaetWq0jBhfl7um+HFJzeubv1qMGg7DJXTHgcLLVzDvxB22fzoeGrTaLDM+9yfRnRCdbbOXSmSBm8SpVC64nBaSm5yaIG+wTrIxR5S7UBgEcetDMLy/+uaEQFLpWGwdj/YpvmREpbUVieTWYydDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z0V3J5y3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z0V3J5y3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEEE1C4CEF1;
	Fri,  9 Jan 2026 11:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959718;
	bh=Lzuw8P07qAwBmBdFElgSBP14cSoY/76iVN09HfLIiFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z0V3J5y3nCcY4wbryxf9RfinXWnfqeZ3Ok3Tl7hQTeEJjmWxHuk7OxYyC1EpC2VCr
	 H7IfFaRPGIVXtJNGgDbfMb7dpOciy2qmZFW9T6JbpMUj9myy/JRy9CO5k6KWhvyrYT
	 XDrCLDf8n4NxLpU2yLq5Z+bifhl7up3CX2a8jzTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 151/737] scsi: sim710: Fix resource leak by adding missing ioport_unmap() calls
Date: Fri,  9 Jan 2026 12:34:50 +0100
Message-ID: <20260109112139.678303806@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit acd194d9b5bac419e04968ffa44351afabb50bac ]

The driver calls ioport_map() to map I/O ports in sim710_probe_common()
but never calls ioport_unmap() to release the mapping. This causes
resource leaks in both the error path when request_irq() fails and in
the normal device removal path via sim710_device_remove().

Add ioport_unmap() calls in the out_release error path and in
sim710_device_remove().

Fixes: 56fece20086e ("[PATCH] finally fix 53c700 to use the generic iomem infrastructure")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251029032555.1476-1-vulab@iscas.ac.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sim710.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sim710.c b/drivers/scsi/sim710.c
index e519df68d603d..70c75ab1453a1 100644
--- a/drivers/scsi/sim710.c
+++ b/drivers/scsi/sim710.c
@@ -133,6 +133,7 @@ static int sim710_probe_common(struct device *dev, unsigned long base_addr,
  out_put_host:
 	scsi_host_put(host);
  out_release:
+	ioport_unmap(hostdata->base);
 	release_region(base_addr, 64);
  out_free:
 	kfree(hostdata);
@@ -148,6 +149,7 @@ static int sim710_device_remove(struct device *dev)
 
 	scsi_remove_host(host);
 	NCR_700_release(host);
+	ioport_unmap(hostdata->base);
 	kfree(hostdata);
 	free_irq(host->irq, host);
 	release_region(host->base, 64);
-- 
2.51.0



