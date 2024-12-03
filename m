Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFFA1F6691;
	Tue,  3 Dec 2024 15:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238430; cv=none; b=m4pvYKhNosSU4WJ6Zc4/qHnFnC6NdXpasfa6a9ktcWNX2XDrS8l6XjZD6vPp96C8FnUBgEvqmUY1DGRf4j59ZvdXcatA3v1M1lyOJBxwvj9ZC4KqoKKcT4pJPbwSJsHhvT10NwUZ2gN2hq47ocL98QwM0gvb+6w/7ouS7p6u9RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238430; c=relaxed/simple;
	bh=ATyqUbOur1ZUenG4zU+KM+giRMla3ztoJ8DRZRXcsJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fz1Eh+Y65DDGfAWa3+cBKliI+xGuozbWi5HkuZF47nr7WR6dx/DjydB29XkURHuEw6rJiXBHiZ8JPnD2Plr12Z/DuWuuN5nPTIhMxGqEltXGviG9wjFiur/5W+abcE6zG+24a8xVwOgUatvLvHECdwWlF7ptV1iCbxx7tPEDgI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FwGG7RoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FwGG7RoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62DEC4CECF;
	Tue,  3 Dec 2024 15:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238430;
	bh=ATyqUbOur1ZUenG4zU+KM+giRMla3ztoJ8DRZRXcsJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FwGG7RoXuFjNnanHSipy6DzAss8zcLcl5iMqAZqQFeCOnqMFlkfdGtsjNNGHVvymG
	 1SeCAyMurYKJPbCe6YKnhY1PmU9Q4vaerDSxnIgpI63K3BwRVlK/qx2yHAD4uySRKG
	 GLUVFF6rOp+8zvJyEqh83UYnrY+ONRHtEXsFD13E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 243/817] wifi: ath10k: fix invalid VHT parameters in supported_vht_mcs_rate_nss1
Date: Tue,  3 Dec 2024 15:36:55 +0100
Message-ID: <20241203144005.252428842@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit d50886b27850447d90c0cd40c725238097909d1e ]

In supported_vht_mcs_rate_nss1, the rate for MCS9 & VHT20 is defined as
{780,  867}, this does not align with firmware's definition and therefore
fails the verification in ath10k_mac_get_rate_flags_vht():

	invalid vht params rate 960 100kbps nss 1 mcs 9

Change it to {865,  960} to align with firmware, so this issue could be
fixed.

Since ath10k_hw_params::supports_peer_stats_info is enabled only for
QCA6174, this change does not affect other chips.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00309-QCARMSWPZ-1

Fixes: 3344b99d69ab ("ath10k: add bitrate parse for peer stats info")
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Closes: https://lore.kernel.org/lkml/fba24cd3-4a1e-4072-8585-8402272788ff@molgen.mpg.de/
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20240711020344.98040-2-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a5da32e87106c..3c34f3d8e5554 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -9121,7 +9121,7 @@ static const struct ath10k_index_vht_data_rate_type supported_vht_mcs_rate_nss1[
 	{6,  {2633, 2925}, {1215, 1350}, {585,  650} },
 	{7,  {2925, 3250}, {1350, 1500}, {650,  722} },
 	{8,  {3510, 3900}, {1620, 1800}, {780,  867} },
-	{9,  {3900, 4333}, {1800, 2000}, {780,  867} }
+	{9,  {3900, 4333}, {1800, 2000}, {865,  960} }
 };
 
 /*MCS parameters with Nss = 2 */
-- 
2.43.0



