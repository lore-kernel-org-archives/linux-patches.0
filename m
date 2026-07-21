Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A15F472F8A;
	Tue, 21 Jul 2026 21:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667685; cv=none; b=OwJ7q2fWlS5CF5hxenx1CzEH1t/lHy41xBtlgSQV4C85u3rU1QU4cCDtEIclu3n1t4i7N4vQBB5L0NRVbSRiPF1hjOXTfgwUM5dOo9ps7VTPJ4M4Rl2vsguWBYBPdzODHM019Db7IkfkwmJang5+kMFa+dnASh/Tmt3OkBWcAUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667685; c=relaxed/simple;
	bh=bHj3ITdfMLEV/ohAGedaZVdTu0s5XCUuXOrFSThqOZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tm1DxUDuKrviZ0/wfp36yjs9rfzL5kKq0CevLt/i9tnpX5evrI1HBS9NJyS+5zxdXekonMEXr9iyu4Auv1uKiRk7Qv1a/PfagWHzd72OsI9NCD5sBc38KwhZhhHKq4zFfhzVsxXUY+NonnH3GkrxDzAWtTcigu2EalsHLDaH1lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWVLcNuO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWVLcNuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA3F1F000E9;
	Tue, 21 Jul 2026 21:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667684;
	bh=k919DC5IRBu7Xtmtk0BGzvGpX90IMpziPE0MBpAA+mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NWVLcNuOU7LQw+WfG7EgwVvkj2MvuAenfa6mO8CieTt85xUxeeC+wlo5N/CBAlqwt
	 XBlS3jsEuFniVOyFyiXneY7ZEisim92ArKmCNOxvvh6V3nH+cSdaMg121qISKdbUWk
	 wkpxT7QaZeI45I+2bDP/I+DCj20R+dWc12kpFEOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.6 1111/1266] ata: pata_pxa: Fix DMA channel leak on probe error
Date: Tue, 21 Jul 2026 17:25:48 +0200
Message-ID: <20260721152506.663127541@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
 


