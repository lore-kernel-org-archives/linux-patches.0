Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD2734E750;
	Tue, 16 Dec 2025 12:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887211; cv=none; b=Pt3JWXXxvLdJariX6Zh7Mfd3jWUsTboFl56d7ZnUvYnddTxtYHGiqw4C0u7IgjAMJTXiCarWf/y5qpuJ3ZUe6JDAXBgHPuxcX+9S8bGdOEh2ZzdpsTxJY9Fkk+8eIdArvpFDWoxPFxn/zqWb1tnYQTFRSqtMD0i1bWpgZkA/HE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887211; c=relaxed/simple;
	bh=OK+M5LYWpSppujutDjK/iTZD9+T3B33uCotgEple5a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JAwpbfz4haNgSQ4EQTeJ9IODB7MZ7tIIxAvNAhEzhDhddGF1+729pb04N21LetyPjTBlniQ5ZNqW5l2EEajmBWW2c6oRvD8LjDtnmVRT3T7/CXZNJL37iqX8LYg7wJwdKytXnJIP7trwOYgdXuQYfbF/32gpjbtl3UFOPliWlqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSwvqu9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSwvqu9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804F0C4CEF5;
	Tue, 16 Dec 2025 12:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887210;
	bh=OK+M5LYWpSppujutDjK/iTZD9+T3B33uCotgEple5a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vSwvqu9Lnal2DTHsBpjYKAcbgivua+18c5rNZhZE3ntQ+HOAjjYZesm9COG4B6XKu
	 YQMPAZycDwdfPDvrtCjfCRnJNXd9dp6gml5R7zOO+BvFwNzBQUONkRa8LFVkg4c6is
	 KKcS6BUXW0imuZB5iiM/6XTCPIrCr7pVdzim/H6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 160/614] wifi: ath12k: fix potential memory leak in ath12k_wow_arp_ns_offload()
Date: Tue, 16 Dec 2025 12:08:47 +0100
Message-ID: <20251216111407.134254497@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit be5febd51c478bc8e24ad3480435f2754a403b14 ]

When the call to ath12k_wmi_arp_ns_offload() fails, the temporary memory
allocation for offload is not freed before returning. Fix that by
freeing offload in the error path.

Fixes: 1666108c74c4 ("wifi: ath12k: support ARP and NS offload")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20251028170457.134608-1-nihaal@cse.iitm.ac.in
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wow.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath12k/wow.c b/drivers/net/wireless/ath/ath12k/wow.c
index dce9bd0bcaefb..e8481626f1940 100644
--- a/drivers/net/wireless/ath/ath12k/wow.c
+++ b/drivers/net/wireless/ath/ath12k/wow.c
@@ -758,6 +758,7 @@ static int ath12k_wow_arp_ns_offload(struct ath12k *ar, bool enable)
 		if (ret) {
 			ath12k_warn(ar->ab, "failed to set arp ns offload vdev %i: enable %d, ret %d\n",
 				    arvif->vdev_id, enable, ret);
+			kfree(offload);
 			return ret;
 		}
 	}
-- 
2.51.0



