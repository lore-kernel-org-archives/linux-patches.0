Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A789134676C;
	Tue, 16 Dec 2025 12:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887563; cv=none; b=IiXnG2K/9ei+lWOxhyvahAB3qhVIbPXdfF9u6I+xS2sl5ENA4bbWPbsJZ9udieNwyRG5kUr5Gj1rhc7/xcDNqPzxo0rTz43G49msQxuZUS3IXdGxxnjB5XM1cfb4SZGqqGTrzHx11KlHc5W70hRxd1z/+/NiHJ2unTQ2p8Ck8ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887563; c=relaxed/simple;
	bh=txldcZ3Wv02VA9WTEN8mKTqJeRDEYI840xhziEXg50E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TO1h9tTCzNnxQin9K4wFaZwJ/CTcDCjDSzUfBhLROKqHt8OICw/npq0nHct0Nwn3sv6waz3G5kzc5x5Q6wGQnV+yrt4YFQBp8Ti2V9cYW95JqkKdoXtdIPCkG1fRuha9Spxlp966mhSCE/lNEwI3oof2Jg5eYtAfOrJyLxbBZw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BD7cbpnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BD7cbpnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC823C4CEF5;
	Tue, 16 Dec 2025 12:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887563;
	bh=txldcZ3Wv02VA9WTEN8mKTqJeRDEYI840xhziEXg50E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BD7cbpnLAPgnhYTaLz+3ksNisfKha6UCbJj8OUVINMnRQzgZmCKfE+i76O6H10dX4
	 cfVbBi0ojO75b5vcSMPvoVTJzNJ+ZtnRK6g3jqQN+lH9YBbc5IOs1Xfajbfq34m4Ou
	 SBDimKQP/Gj8GHnbbM0aSo9v4mjUgQp5vK8CNxOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 268/614] scsi: sim710: Fix resource leak by adding missing ioport_unmap() calls
Date: Tue, 16 Dec 2025 12:10:35 +0100
Message-ID: <20251216111411.084582530@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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



