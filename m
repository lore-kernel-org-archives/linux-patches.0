Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC1C19AD93;
	Tue, 16 Jul 2024 15:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145144; cv=none; b=BtHk4y5K8JuhEX2fzpA8zCGcM/FZDALYnGVUqO31zYjHLT2lnSXTQbslulMprnfTF6l+JWM4PG+xCE6gDFOQh5Szf3x0IpCYqGMxYoMJxHxxTFkmV5MKuX/Z7/bkhIGtgjUOX15wccEcqBUjqtE6sgBgNCgjnBxfAER1OkGfIjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145144; c=relaxed/simple;
	bh=2EmdUJVLAoOB9Mw3sZYN0oXDUipcDzBFBfKGnHXkUNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCkXiwQVj0VmDb2RvIBlDI924hUV2MZfB5Pcg8PnagkQQasNJUsnPy/yjDwyEJU3Z5AsmsVqMbdTNWw7HA9oRHCStJ5QML3/a8b66S7lEKdHZ5K4oP2u7RzdiK8OxK7tIihflrD23Ejh9ttwObmE1WTai3Gb5rKueqMxpV3ccyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IERq6nTD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IERq6nTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41E1C116B1;
	Tue, 16 Jul 2024 15:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145144;
	bh=2EmdUJVLAoOB9Mw3sZYN0oXDUipcDzBFBfKGnHXkUNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IERq6nTDBZSyFgCIdlp/0ktLoJlQEpI4CbNYvLXN5zQQlbcH/DKxKUfg3T55sEron
	 /+sUfjJ5goVWWjjKjPRY+uvLHQFqTEFxnOK5LFmP7OA5qIKTu/mEu5i2qzeVixQTSm
	 wgv2GW0/IcDVz+1hJL0BkpSSHtrJ68KLj2kqHrqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Christoph Hellwig <hch@lst.de>,
	Jon Hunter <jonathanh@nvidia.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.9 113/143] mmc: sdhci: Fix max_seg_size for 64KiB PAGE_SIZE
Date: Tue, 16 Jul 2024 17:31:49 +0200
Message-ID: <20240716152800.325543625@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit 63d20a94f24fc1cbaf44d0e7c0e0a8077fde0aef upstream.

blk_queue_max_segment_size() ensured:

	if (max_size < PAGE_SIZE)
		max_size = PAGE_SIZE;

whereas:

blk_validate_limits() makes it an error:

	if (WARN_ON_ONCE(lim->max_segment_size < PAGE_SIZE))
		return -EINVAL;

The change from one to the other, exposed sdhci which was setting maximum
segment size too low in some circumstances.

Fix the maximum segment size when it is too low.

Fixes: 616f87661792 ("mmc: pass queue_limits to blk_mq_alloc_disk")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20240710180737.142504-1-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 112584aa0772..fbf7a91bed35 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -4727,6 +4727,21 @@ int sdhci_setup_host(struct sdhci_host *host)
 		if (host->quirks & SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC) {
 			host->max_adma = 65532; /* 32-bit alignment */
 			mmc->max_seg_size = 65535;
+			/*
+			 * sdhci_adma_table_pre() expects to define 1 DMA
+			 * descriptor per segment, so the maximum segment size
+			 * is set accordingly. SDHCI allows up to 64KiB per DMA
+			 * descriptor (16-bit field), but some controllers do
+			 * not support "zero means 65536" reducing the maximum
+			 * for them to 65535. That is a problem if PAGE_SIZE is
+			 * 64KiB because the block layer does not support
+			 * max_seg_size < PAGE_SIZE, however
+			 * sdhci_adma_table_pre() has a workaround to handle
+			 * that case, and split the descriptor. Refer also
+			 * comment in sdhci_adma_table_pre().
+			 */
+			if (mmc->max_seg_size < PAGE_SIZE)
+				mmc->max_seg_size = PAGE_SIZE;
 		} else {
 			mmc->max_seg_size = 65536;
 		}
-- 
2.45.2



