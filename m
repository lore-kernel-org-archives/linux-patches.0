Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22ED18C90A;
	Tue, 30 Jul 2024 16:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355524; cv=none; b=luEE5dwfeduiyFhzLfiu+3+qD9vvcziynXvvio8fXNYo4rYc0LIpMHl7POMh8BGpGinDX572Lf6w1keY7FDffnV1uISKWThpvkRaNRptpG0CBR0FzprXdH+Mgo6SbpFWlTorb7fxwv10pli2k/QZnZ1TUn1DkPr3IGsn4gIAlKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355524; c=relaxed/simple;
	bh=DG1nch64xJ1vuX0McYcyTuqyroXt/Xe/Cf+k/r9Mwg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvxghWO3a5Wst1gHtO0mFXqSHe+Jhn0H+35YNuhzbjxuuzibpKXONw3xHLb2N0wbWZv8AASj+BXlQHyAs/ysBkONAJu94fUACfaeUpi9lp9+aS8yHPlnsE3IKStmjR1nfBZcJFld7YRg2YvVVI4FuQKWL2+BDcMHCbYxU2eWTx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4hnWtRR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4hnWtRR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F4EC32782;
	Tue, 30 Jul 2024 16:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355524;
	bh=DG1nch64xJ1vuX0McYcyTuqyroXt/Xe/Cf+k/r9Mwg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K4hnWtRRCmOEh0hrlbEQbr7NWDD7rlMfJv1InF/PGPb0SPrU7mYVwQNwT2PSCuvs/
	 VaMmfh5VEbkS+2o9GuYBlM/TIVBYfAyyO0pYh5JbgZO7VkEMDK5+hIODonDhGA6evy
	 ElatJoK35eqbGO0u6r4QW5vCRM2ChOQ7W7LiIHug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/440] wifi: cfg80211: handle 2x996 RU allocation in cfg80211_calculate_bitrate_he()
Date: Tue, 30 Jul 2024 17:45:35 +0200
Message-ID: <20240730151619.874294143@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit bcbd771cd5d68c0c52567556097d75f9fc4e7cd6 ]

Currently NL80211_RATE_INFO_HE_RU_ALLOC_2x996 is not handled in
cfg80211_calculate_bitrate_he(), leading to below warning:

kernel: invalid HE MCS: bw:6, ru:6
kernel: WARNING: CPU: 0 PID: 2312 at net/wireless/util.c:1501 cfg80211_calculate_bitrate_he+0x22b/0x270 [cfg80211]

Fix it by handling 2x996 RU allocation in the same way as 160 MHz bandwidth.

Fixes: c4cbaf7973a7 ("cfg80211: Add support for HE")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Link: https://msgid.link/20240606020653.33205-3-quic_bqiang@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 37ea62f83cb56..1665320d22146 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1393,7 +1393,9 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
 	if (WARN_ON_ONCE(rate->nss < 1 || rate->nss > 8))
 		return 0;
 
-	if (rate->bw == RATE_INFO_BW_160)
+	if (rate->bw == RATE_INFO_BW_160 ||
+	    (rate->bw == RATE_INFO_BW_HE_RU &&
+	     rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_2x996))
 		result = rates_160M[rate->he_gi];
 	else if (rate->bw == RATE_INFO_BW_80 ||
 		 (rate->bw == RATE_INFO_BW_HE_RU &&
-- 
2.43.0



