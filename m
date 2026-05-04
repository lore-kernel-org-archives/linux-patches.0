Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6643DFC6F;
	Mon,  4 May 2026 14:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904729; cv=none; b=dXQYH3KbTawpHbvvDZjntEgow05p0lGEDm/TuTzdl3ZBr0XhUgiZQEmz17P+hGD0Rc7L0mV9ZL4Ze6qvFuqkQ32DcX7whrRd9zvE/sYOzWUiFvzO/ndlGeHP34S6Id8tsA1iQtwKo4idvFBR+hiFrfSBZxBdDy1k+j7knWZ+CC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904729; c=relaxed/simple;
	bh=SbhXsHt9zy0ussgqfBv7f74jZE8uGr7sPITA51gM5zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIp8fB9H0AONMkjGh0cCfWguOVxsBtA3igPhXAHIIyEkth6LHIpgFaGuJOn3Jz5i5bpunD8ZADJPLkpw30WdVdY5VSBbr58AvB+zuG98UQSZ7BfoOECXQwSNvZEIa/9nXWF+s1fbGbXyrIAHGDFGxsaIP1Gs5ZbefFpjVYwY8l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=inHk6COb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="inHk6COb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB8FC2BCB8;
	Mon,  4 May 2026 14:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904728;
	bh=SbhXsHt9zy0ussgqfBv7f74jZE8uGr7sPITA51gM5zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inHk6CObOaQd5RZgLm6nHyuG8tA8TIrZuhphhz5UNa9jOlXVNqnV4yu26SdTeuUFP
	 hp0OQxiJfVLUKfm6DhFSy9eKfU+yLcExo1lkmwV1AhEPlu3cH6JW1eBFOLzitxf0et
	 cZ2Y1MJQb9m5fvY58lyspwDRJMdeEY13McleGzCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Yu <qiang.yu@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: [PATCH 6.12 152/215] bus: mhi: host: pci_generic: Switch to async power up to avoid boot delays
Date: Mon,  4 May 2026 15:52:51 +0200
Message-ID: <20260504135135.719859599@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

From: Qiang Yu <qiang.yu@oss.qualcomm.com>

commit cfdb41adf1c2822ad1b1791d4d11093edb5582b6 upstream.

Some modem devices can take significant time (up to 20 secs for sdx75) to
enter mission mode during initialization. Currently, mhi_sync_power_up()
waits for this entire process to complete, blocking other driver probes
and delaying system boot.

Switch to mhi_async_power_up() so probe can return immediately while MHI
initialization continues in the background. This eliminates lengthy boot
delays and allows other drivers to probe in parallel, improving overall
system boot performance.

Fixes: 5571519009d0 ("bus: mhi: host: pci_generic: Add SDX75 based modem support")
Signed-off-by: Qiang Yu <qiang.yu@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260303-b4-async_power_on-v2-1-d3db81eb457d@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/pci_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -1235,7 +1235,7 @@ static int mhi_pci_probe(struct pci_dev
 		goto err_unregister;
 	}
 
-	err = mhi_sync_power_up(mhi_cntrl);
+	err = mhi_async_power_up(mhi_cntrl);
 	if (err) {
 		dev_err(&pdev->dev, "failed to power up MHI controller\n");
 		goto err_unprepare;


