Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BB58465
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999A8C433C9;
	Wed, 20 Sep 2023 11:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210325;
	bh=HIL5DGDVqVdyiKQ8Y6mv+3bz4htkVfTe9bNcvkm4lkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oU/tn3dodD9KX+ETJuZwx8EneVLaGWs5FJRKIMEhFMem75TirGiPrcB3DZpXqrpdE
	 ge8eroga+j/+wfRk5urSgkw0aXsjaBUx4uAGN2WRkktDGBdnbfwCsfAr9NS0mtJOsv
	 ESm/MGhCY91c2nCgkqkygQPVXB0quxK0ATXJL2N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Gong <quic_wgong@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 036/211] wifi: ath12k: Fix a NULL pointer dereference in ath12k_mac_op_hw_scan()
Date: Wed, 20 Sep 2023 13:28:00 +0200
Message-ID: <20230920112846.911416933@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wen Gong <quic_wgong@quicinc.com>

[ Upstream commit 8ad314da54c6dd223a6b6cc85019160aa842f659 ]

In ath12k_mac_op_hw_scan(), the return value of kzalloc() is directly
used in memcpy(), which may lead to a NULL pointer dereference on
failure of kzalloc().

Fix this bug by adding a check of arg.extraie.ptr.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0-03427-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.15378.4

Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230726092625.3350-1-quic_wgong@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 45d88e35fc2eb..d165b24094ad5 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -2755,9 +2755,12 @@ static int ath12k_mac_op_hw_scan(struct ieee80211_hw *hw,
 	arg.scan_id = ATH12K_SCAN_ID;
 
 	if (req->ie_len) {
+		arg.extraie.ptr = kmemdup(req->ie, req->ie_len, GFP_KERNEL);
+		if (!arg.extraie.ptr) {
+			ret = -ENOMEM;
+			goto exit;
+		}
 		arg.extraie.len = req->ie_len;
-		arg.extraie.ptr = kzalloc(req->ie_len, GFP_KERNEL);
-		memcpy(arg.extraie.ptr, req->ie, req->ie_len);
 	}
 
 	if (req->n_ssids) {
-- 
2.40.1



