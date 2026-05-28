Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F72327C00;
	Thu, 28 May 2026 20:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001463; cv=none; b=Xc6tv/px8gjFZqIZByGT7OJB0Lbja3vcAOCuSNUWrn9v4sVmM/g4H4iCVLRot6fYta4hfj6z5jykyHayog80ZeBXTTLx2FFs6ZHKm/zIBb0smVHF92PcDl5b0kuWCCBEhrqoJ0vwS/9ptm5FDMMgmnlkH7FDLTT6gqnPagdChjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001463; c=relaxed/simple;
	bh=C0WXPAe5Tk8mY47K4kcQwcpvESEp3l+h6ODsxL8vt2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qR1c1y1Eqr6QL1WKeQm2Y4fpZd4DuMdueY+QBnmce/OMKU0dxBHYf6KHj4TO0+wn6awbhnguwM2dYwvYaRJxxBvQmTVrCcxfyXM3pFRX/jEGfzgoMvywthVNiwN8gAm6+e3xjniFrYgt65PvH0tH/CXxu3YPixEGAIBJMzmfW6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0of69GaQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0of69GaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C127F1F000E9;
	Thu, 28 May 2026 20:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001462;
	bh=CbDNg36ty5DpfieBr6JeqEgHtGfmAC3Tvce2mdGvLnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0of69GaQwXNmhfi1Atsa33Ni7CH2MKVvrAt7uA3DG0Iarf2QJ3qw9QmIh5sW4z9DQ
	 082ch5zppsznuAP4jEiqFGKUeAZDB8zUy1IBJW8JwTANvCKf/u5jxt2EXupgsjrhXP
	 uuyYRlCrXAaQzrvZ6LYCI/N9V6M7KML5rjGrwZW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 135/186] wifi: ath11k: fix error path leak in ath11k_tm_cmd_wmi_ftm()
Date: Thu, 28 May 2026 21:50:15 +0200
Message-ID: <20260528194932.595140837@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

From: Nicolas Escande <nico.escande@gmail.com>

[ Upstream commit 7320d6eb861e9913193a7801834c661381756a79 ]

This is similar to what was fixed by previous patches. We have a call
to ath11k_wmi_cmd_send() which does check the return value, but forgot
to free the related skb on error.

Fixes: b43310e44edc ("wifi: ath11k: factory test mode support")
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260506134240.2284016-4-nico.escande@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/testmode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/testmode.c b/drivers/net/wireless/ath/ath11k/testmode.c
index 43bb23265d346..b9f0ef458988c 100644
--- a/drivers/net/wireless/ath/ath11k/testmode.c
+++ b/drivers/net/wireless/ath/ath11k/testmode.c
@@ -457,6 +457,7 @@ static int ath11k_tm_cmd_wmi_ftm(struct ath11k *ar, struct nlattr *tb[])
 		ret = ath11k_wmi_cmd_send(wmi, skb, cmd_id);
 		if (ret) {
 			ath11k_warn(ar->ab, "failed to send wmi ftm command: %d\n", ret);
+			dev_kfree_skb(skb);
 			goto out;
 		}
 
-- 
2.53.0



