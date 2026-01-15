Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FB13A7F5D;
	Thu, 15 Jan 2026 17:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497470; cv=none; b=L7qbdyRUAeuH4qsZeZh32aIQiUR76D1hRmL0Y2wpc+SKCxJOVMvlLatapVAy2sSeWY6ivI6cIeBtcLP5/xiV2ONIbwS/K5PDZkHvOFrBA6JXG4zD8tBakf9Y39ReEH+a+IF2O6awzR9vAd904tuTFNlYcEUqdRl/hEuJyxEGqqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497470; c=relaxed/simple;
	bh=BQQvXS4SQ+qrUj6VYVliqDNzomdKpAC8p2tUuTUxcig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLCC5FQHXpVBaqFBCoHBu2tZDXfreVfrCGLI+vYo1Pxz4WGYylyVompzYOK25QmpedFZ4nnaAIJmaLTPRUvg6hmhzSHSO0ha+sBjo9pOWbkFad2WhJKXWPRDEf+ALnnG2xl687PgraAFSLapS4eDh9XxGyBzzebd1gR1tA2K7h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3mJcwhQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3mJcwhQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CFEC116D0;
	Thu, 15 Jan 2026 17:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497470;
	bh=BQQvXS4SQ+qrUj6VYVliqDNzomdKpAC8p2tUuTUxcig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3mJcwhQd2yzG9RsdKEBmBPcTAM1lVCUG2hgk9S2PRdfIKbiBZRq6TfMPfwZHUL10
	 UKJudsACqBqhxE7Oao3uS+P4Ir5V/ly3SlGz2mkMn4wv5jd7+v4tJE8NNnu5TJAwLD
	 z0R91JTMJxDu/uxbAT9xNYG8EKX4jxhmxViHxg6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/554] wifi: cw1200: Fix potential memory leak in cw1200_bh_rx_helper()
Date: Thu, 15 Jan 2026 17:42:37 +0100
Message-ID: <20260115164249.540560473@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 5e88e864118c20e63a1571d0ff0a152e5d684959 ]

In one of the error paths, the memory allocated for skb_rx is not freed.
Fix that by freeing it before returning.

Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20251110175316.106591-1-nihaal@cse.iitm.ac.in
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/st/cw1200/bh.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/bh.c b/drivers/net/wireless/st/cw1200/bh.c
index 10e019cddcc65..cbb95682d21b2 100644
--- a/drivers/net/wireless/st/cw1200/bh.c
+++ b/drivers/net/wireless/st/cw1200/bh.c
@@ -317,10 +317,12 @@ static int cw1200_bh_rx_helper(struct cw1200_common *priv,
 
 	if (wsm_id & 0x0400) {
 		int rc = wsm_release_tx_buffer(priv, 1);
-		if (WARN_ON(rc < 0))
+		if (WARN_ON(rc < 0)) {
+			dev_kfree_skb(skb_rx);
 			return rc;
-		else if (rc > 0)
+		} else if (rc > 0) {
 			*tx = 1;
+		}
 	}
 
 	/* cw1200_wsm_rx takes care on SKB livetime */
-- 
2.51.0



