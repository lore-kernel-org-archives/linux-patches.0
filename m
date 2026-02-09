Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC39285073;
	Mon,  9 Feb 2026 14:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648321; cv=none; b=FqMY9DyvPi0sSc18E7DnCWsM2NV1Kw9KA/2ArvmgmnM4eTSqzH7A1nkR4tJwkJ7LAACw2oJgCaf89ekPZgXfgcUwD0ad/KRp0GGwv4m0dkfMrP+snHMetrTG7+vGolOpmcQSMxLoRsLGTuO7SX2N0HRHSX5AEeDO/v/5Zt+CaZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648321; c=relaxed/simple;
	bh=ulBYsHJcHar8CRlKox40eV7RJlPjOhcF6HhsU8sHSvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmKxxfv+kusAt6IZlJHN93jDTp8+tjIrHv09gqjZcmYoTvEfFqh2ETvUw7a+ASwDb3GcSmf5g3RcqsmchczM4kc4XJozfDRor5jaMbycmtYhZx7OTCyCgMoz8MQCS9qoTlFYNPnbdJ1ah10K1OVInt2rQmCeEnC6+dGuqcSVwbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cIAOLsxS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cIAOLsxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802FFC116C6;
	Mon,  9 Feb 2026 14:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648320;
	bh=ulBYsHJcHar8CRlKox40eV7RJlPjOhcF6HhsU8sHSvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cIAOLsxSAC1B9v+km1yXpnOWmDN14LqVDN0CQFUFfw4z2m8Wk8G5uWIVGXjSVZulE
	 y9NgkNuh/YpIobMRnxU6Wd8xo4qdNpOZgjHCkXzqjc1u4xzoKptvjTo7FLzBoKcIzu
	 edikZJSNCiZXaXvPCSB/FLxY2+yFXX8Gs3pHcClM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Veerendranath Jakkam <veerendranath.jakkam@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 40/69] wifi: cfg80211: Fix bitrate calculation overflow for HE rates
Date: Mon,  9 Feb 2026 15:24:08 +0100
Message-ID: <20260209142303.366958949@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

From: Veerendranath Jakkam <veerendranath.jakkam@oss.qualcomm.com>

[ Upstream commit a3034bf0746d88a00cceda9541534a5721445a24 ]

An integer overflow occurs in cfg80211_calculate_bitrate_he() when
calculating bitrates for high throughput HE configurations.
For example, with 160 MHz bandwidth, HE-MCS 13, HE-NSS 4, and HE-GI 0,
the multiplication (result * rate->nss) overflows the 32-bit 'result'
variable before division by 8, leading to significantly underestimated
bitrate values.

The overflow occurs because the NSS multiplication operates on a 32-bit
integer that cannot accommodate intermediate values exceeding
4,294,967,295. When overflow happens, the value wraps around, producing
incorrect bitrates for high MCS and NSS combinations.

Fix this by utilizing the 64-bit 'tmp' variable for the NSS
multiplication and subsequent divisions via do_div(). This approach
preserves full precision throughout the entire calculation, with the
final value assigned to 'result' only after completing all operations.

Signed-off-by: Veerendranath Jakkam <veerendranath.jakkam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260109-he_bitrate_overflow-v1-1-95575e466b6e@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index b513e24572a3f..f59985e80e20d 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1553,12 +1553,14 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
 	tmp = result;
 	tmp *= SCALE;
 	do_div(tmp, mcs_divisors[rate->mcs]);
-	result = tmp;
 
 	/* and take NSS, DCM into account */
-	result = (result * rate->nss) / 8;
+	tmp *= rate->nss;
+	do_div(tmp, 8);
 	if (rate->he_dcm)
-		result /= 2;
+		do_div(tmp, 2);
+
+	result = tmp;
 
 	return result / 10000;
 }
-- 
2.51.0



