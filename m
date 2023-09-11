Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869BD11715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0843AC433C7;
	Mon, 11 Sep 2023 15:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445094;
	bh=uXpGHgRfJVouFi7ds/iphviLOcmcoG+VIrlFw220cSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MxAbWCks5doF26+pxqR23rKGlFFrp+JCVoHGtNGtKtmM9gEcfguT4Urxa+4+mcAAc
	 loSE7VO9xhy0wjP5AowFn+zB/xXM+qt5qtD6jfwlNTenoUj2+UqF+ts8XgUirgornN
	 QchkQmhQYCQEp7f+OgYCifTmHvrNXPfN803mPhv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Austin <alex.austin@amd.com>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 208/600] sfc: Check firmware supports Ethernet PTP filter
Date: Mon, 11 Sep 2023 15:44:01 +0200
Message-ID: <20230911134639.757340086@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Austin <alex.austin@amd.com>

[ Upstream commit c4413a20fa6d7c4888009fb7dd391685f196cd36 ]

Not all firmware variants support RSS filters. Do not fail all PTP
functionality when raw ethernet PTP filters fail to insert.

Fixes: e4616f64726b ("sfc: support PTP over Ethernet")
Signed-off-by: Alex Austin <alex.austin@amd.com>
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Link: https://lore.kernel.org/r/20230824164657.42379-1-alex.austin@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ptp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index eaef4a15008a3..692c7f132e9f9 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1387,7 +1387,8 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 			goto fail;
 
 		rc = efx_ptp_insert_eth_filter(efx);
-		if (rc < 0)
+		/* Not all firmware variants support this filter */
+		if (rc < 0 && rc != -EPROTONOSUPPORT)
 			goto fail;
 	}
 
-- 
2.40.1



