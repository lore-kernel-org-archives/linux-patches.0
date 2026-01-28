Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380DA1885A5;
	Wed, 28 Jan 2026 15:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614364; cv=none; b=Fo+8sjgPYpTMd/YPf7CFoJ0dS6f7KsdDYYFHth8bjSARtq0a3ei8k7LoQS8i13W10QB0Nl+VdBKDXByXUtXgpD/Oagc8L4OiRqgCEXdLzm6EZmdkDRk4Ys3BmxH332iiq4VoTV+GAJYpF+q6veLz+OAvWiJPS02x/1T8tQdNYMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614364; c=relaxed/simple;
	bh=gPF2fSZQ4zirswiRYZB/Y2Pw6j5a5zPhjztkkZlMkeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrKCOKuwWwU+7oU4JDazUpHrT2TUiK3bxJP37OuLHEDLGNRfcPUGPtsVvyE04Zhc0lTawTIM4i98m6BGnxlRCYrwOldk9onrglgfk6m2uANQYYZp9M/Vwnsw+66Yo9VdyFmNbcl2vm2tHzFVBxa5wT4ZgMGWu+4u4WGVU1EUnas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t8umQd6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t8umQd6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20FAC4CEF1;
	Wed, 28 Jan 2026 15:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614364;
	bh=gPF2fSZQ4zirswiRYZB/Y2Pw6j5a5zPhjztkkZlMkeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t8umQd6EVTC/FovnBj9rSj3H/yWNj675PjIpaDH10nh2/WodLssJ5HiI/AxuZkXWk
	 CoQIGSugqaTZnJw+eY1wO72Lx/oxazx1Ch6gtqgNGIqkCERRh+14zWsvWvmGSqZvdw
	 R63uTHIiThRy5hiQ+IhG3gFJLS1iNPPRIqZqi7Ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Wolf <wolf@yoxt.cc>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/254] ata: libata: Print features also for ATAPI devices
Date: Wed, 28 Jan 2026 16:21:30 +0100
Message-ID: <20260128145348.926164499@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit c8c6fb886f57d5bf71fb6de6334a143608d35707 ]

Commit d633b8a702ab ("libata: print feature list on device scan")
added a print of the features supported by the device for ATA_DEV_ATA and
ATA_DEV_ZAC devices, but not for ATA_DEV_ATAPI devices.

Fix this by printing the features also for ATAPI devices.

Before changes:
ata1.00: ATAPI: Slimtype DVD A  DU8AESH, 6C2M, max UDMA/133

After changes:
ata1.00: ATAPI: Slimtype DVD A  DU8AESH, 6C2M, max UDMA/133
ata1.00: Features: Dev-Attention HIPM DIPM

Fixes: d633b8a702ab ("libata: print feature list on device scan")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Tested-by: Wolf <wolf@yoxt.cc>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index e51a27ae0a7d2..d5e713f284b71 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3049,6 +3049,9 @@ int ata_dev_configure(struct ata_device *dev)
 				     dma_dir_string);
 
 		ata_dev_config_lpm(dev);
+
+		if (print_info)
+			ata_dev_print_features(dev);
 	}
 
 	/* determine max_sectors */
-- 
2.51.0



