Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E483C35BDA8;
	Wed,  3 Dec 2025 16:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778989; cv=none; b=RtJHIN55MQkXwSH5M/11RjcAII6Ttw+pAZWuThbuZI2zfsi643GI589GuemUqZ24O0cUGcu6LJ6k9W1+ty3y2UzP/47ajc94k6r4T+k8iGtdjkaCfCOJ8h/eRKV3kTevpPm0JM66ATld2h7fYaFIn+aNvY18I9kdANFObWzt2CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778989; c=relaxed/simple;
	bh=zfNxUh7JJzI7EuItrUseAfh+x703diKdj+AusMC7pmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dl04r82hiWMh7Mn9M2lwBBjKInI6n0fikSRrZCEtQGpQ6dx6I2Xxr5imna64EAK8nUnY4ejjBaKOgZTnoj1ptOsC4kHplx/fVf6OSGTKKekaE/uAUQF2JQoueMYvkr4yO3D24xhn1LaWDcFtYPIrDpmalZFsEjLUL5d48IhsSY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DnMQZpsF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DnMQZpsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699DAC4CEF5;
	Wed,  3 Dec 2025 16:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778988;
	bh=zfNxUh7JJzI7EuItrUseAfh+x703diKdj+AusMC7pmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DnMQZpsFKFitUyVE416UNlz8mfrKhfDRZKDXtFMaqWhR+Fe0KEdKy8/Ji1lHlNkSj
	 02xPPGmoTPno7UR8veEbLkxkAeHtMMShLwLYcHgB2rQRFm/iBKXtu0MayJ9swpNkxH
	 7kK3E/i1DnJpgVCjb+od+Y/zrFWhur1u3RGYqS+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alistair Francis <alistair.francis@wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/568] nvme: Use non zero KATO for persistent discovery connections
Date: Wed,  3 Dec 2025 16:22:03 +0100
Message-ID: <20251203152445.164280736@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Alistair Francis <alistair.francis@wdc.com>

[ Upstream commit 2e482655019ab6fcfe8865b62432c6d03f0b5f80 ]

The NVMe Base Specification 2.1 states that:

"""
A host requests an explicit persistent connection ... by specifying a
non-zero Keep Alive Timer value in the Connect command.
"""

As such if we are starting a persistent connection to a discovery
controller and the KATO is currently 0 we need to update KATO to a non
zero value to avoid continuous timeouts on the target.

Signed-off-by: Alistair Francis <alistair.francis@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 7d3759f875b23..938af571dc13e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -5131,8 +5131,14 @@ void nvme_start_ctrl(struct nvme_ctrl *ctrl)
 	 * checking that they started once before, hence are reconnecting back.
 	 */
 	if (test_bit(NVME_CTRL_STARTED_ONCE, &ctrl->flags) &&
-	    nvme_discovery_ctrl(ctrl))
+	    nvme_discovery_ctrl(ctrl)) {
+		if (!ctrl->kato) {
+			nvme_stop_keep_alive(ctrl);
+			ctrl->kato = NVME_DEFAULT_KATO;
+			nvme_start_keep_alive(ctrl);
+		}
 		nvme_change_uevent(ctrl, "NVME_EVENT=rediscover");
+	}
 
 	if (ctrl->queue_count > 1) {
 		nvme_queue_scan(ctrl);
-- 
2.51.0



