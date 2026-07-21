Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3935F3BE641;
	Tue, 21 Jul 2026 21:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670366; cv=none; b=Z8cLTkRVe0TCCP8sxwA6CIs/KK28D6BaWDC8p7t2xakwWdPYejfcw00DPbjbMLORrMIoZxZI8+eFm+6nmGhG5QYdPSHZqq7+6HaN99baHpJeniApj/ulspsYSH+WrY3VuigOn5JhAsiozZEtl1ieS+xV2GVZt959Kycw3zVA6KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670366; c=relaxed/simple;
	bh=rmoUlgMGWhTexM+qAbIt3kii+O8V+E81FbnTvPoEJNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtY6MtrvjujztWPoG867XDhkvN58MzIOCzsrJDlgMIom/7cHpltFj3IUhDVPMkAhnOzR2FvpccLha8UjpJHW61ffhfGzHfT3FJkHFeFFBvASG3oxAO+B8bfPUR7lPDjPKsfXJSXcUwi6eJDYrbpNYos9wXJoCBJxlSeqOmx4QQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EE58Etp5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EE58Etp5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE431F000E9;
	Tue, 21 Jul 2026 21:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670365;
	bh=JkQ94bobiwfl7+raYvJy8Van+NWdOvLFbyXlEegNzTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EE58Etp5XsgMHEUSNpDpEEQ24vpB5bglW7O7QV+eambecva9WFkY/vbsGXuccDzNs
	 wLYYr7bFtczhMUlxAuwKHpHvBTIUDg/C/0stZvXM+BAgDevx5wcehjZP7ZWqlcvvfm
	 cxrrTR77w4j8IjB6NyaRa+Xr/XcGCrDbIcRU80IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.1 0905/1067] ata: pata_pxa: Fix DMA channel leak on probe error
Date: Tue, 21 Jul 2026 17:25:06 +0200
Message-ID: <20260721152444.784055862@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


