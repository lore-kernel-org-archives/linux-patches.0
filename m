Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8AA258EC2;
	Thu, 15 Jan 2026 17:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497598; cv=none; b=OzwMjFtDNSGdctcwB3k9T/383sitWxIiNBT3RmfnfwlIMUzsMs2cPtIken3dWqZNj8rHX2kDJ5TChrLCenlvsXxOkyq9oWF4tTM262U+widXsxXMKDwN5V9MNxUkrHTXsBUcZUi8G6YTjZGGDtoYIxubzebrSnRXlO4IHrHYO5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497598; c=relaxed/simple;
	bh=QpDvYsu45gDF/SFLwhVjGYBQFo0W3CkHjZ+C8MXg9zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTd3QzHvGPSADVMWl6NWftlIhyfkQbiLT80hlQ8+LPlbP4Xea0MYrJohmc1xn7roH0PmPVPoaI7tHs3bZJc0hpppGwumZkdRTDgPyAfoeeg/o9ZrPvau5OIIsY/BpUESN5bYqTJB+oaA14LmclEu8o+aGG+iVXoii/A53tAf1Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g75AZFlL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g75AZFlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE11C116D0;
	Thu, 15 Jan 2026 17:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497598;
	bh=QpDvYsu45gDF/SFLwhVjGYBQFo0W3CkHjZ+C8MXg9zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g75AZFlLhd/bXsB6Pvm3tGks273qPN8g+K/kvXehoAy5pW5Vu2IzvhUwmR3B3hwdm
	 51o1q+GFlbkQD62b7R71L8iZDSVDgFQ2ju3ngvXX+zUFTM0/qjTefOSQPCh0tpitCp
	 HKk77nqKw2mnJ3EjSGZBci9BRhaAho/nX/nPRbek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/554] scsi: sim710: Fix resource leak by adding missing ioport_unmap() calls
Date: Thu, 15 Jan 2026 17:42:50 +0100
Message-ID: <20260115164250.019231732@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



