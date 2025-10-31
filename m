Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718361F37D4;
	Fri, 31 Oct 2025 14:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919497; cv=none; b=KMXXX6s+psaA59T4jaq4msfrRckHFpWMoDgKvsvAUwrZOJuCqGCYnpT0sOsq6amYATCQ2uXy+rDrUIL/jnnPS9ScrJMTb53NWbdi7v6SgVxVEeLd0sRpC4McuNjEPD0mSjRKD34fkZa62WRG9fIDzdLoEjMcG6Dec9B2faKfkl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919497; c=relaxed/simple;
	bh=qqmO42GeU6RjJbuGwmcprSxhTnASJC508P1rjINaFio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYtGJgHp7e1UKEWBb5OS2jV0FmY7RAm8TZJo2UUxv+l6PVjuG2vJT4KbBDXsjQTGbyPKOXuYR3SKZOzAkYIgMDBa0x5jkxSX1N6bVmwW6hjpy31mDPOTpBvYK4q+uOQTYyFU41W2Hponzjr5xKtjznASjgd2SpLJ3uh73elQWJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XzvkJt83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XzvkJt83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7755C4CEF8;
	Fri, 31 Oct 2025 14:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919497;
	bh=qqmO42GeU6RjJbuGwmcprSxhTnASJC508P1rjINaFio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XzvkJt83F447azBklL52eywL3KUxLmbER+n/yH1nGS5Y+VaoAisn7Vkvih4Cahf/f
	 7OnDBROcY8cOYAaV9fTb/BveQxyn3MdmmtZDvqNj0wObenlkXqv7dcHMKZkgxkbNmK
	 wowU0mGvpl9Mg33bTCG5q0pkUBYmkKkI0Hyjmg7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Kumar Singh <quic_adisi@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Kalle Valo <kvalo@kernel.org>,
	Amelia Crate <acrate@waldn.net>
Subject: [PATCH 6.12 38/40] wifi: ath12k: fix read pointer after free in ath12k_mac_assign_vif_to_vdev()
Date: Fri, 31 Oct 2025 15:01:31 +0100
Message-ID: <20251031140044.945054780@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Kumar Singh <quic_adisi@quicinc.com>

[ Upstream commit 5a10971c7645a95f5d5dc23c26fbac4bf61801d0 ]

In ath12k_mac_assign_vif_to_vdev(), if arvif is created on a different
radio, it gets deleted from that radio through a call to
ath12k_mac_unassign_link_vif(). This action frees the arvif pointer.
Subsequently, there is a check involving arvif, which will result in a
read-after-free scenario.

Fix this by moving this check after arvif is again assigned via call to
ath12k_mac_assign_link_vif().

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1

Closes: https://scan5.scan.coverity.com/#/project-view/63541/10063?selectedIssue=1636423
Fixes: b5068bc9180d ("wifi: ath12k: Cache vdev configs before vdev create")
Signed-off-by: Aditya Kumar Singh <quic_adisi@quicinc.com>
Acked-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Acked-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20241210-read_after_free-v1-1-969f69c7d66c@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Amelia Crate <acrate@waldn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/mac.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -6733,15 +6733,15 @@ static struct ath12k *ath12k_mac_assign_
 
 	mutex_lock(&ar->conf_mutex);
 
-	if (arvif->is_created)
-		goto flush;
-
 	if (vif->type == NL80211_IFTYPE_AP &&
 	    ar->num_peers > (ar->max_num_peers - 1)) {
 		ath12k_warn(ab, "failed to create vdev due to insufficient peer entry resource in firmware\n");
 		goto unlock;
 	}
 
+	if (arvif->is_created)
+		goto flush;
+
 	if (ar->num_created_vdevs > (TARGET_NUM_VDEVS - 1)) {
 		ath12k_warn(ab, "failed to create vdev, reached max vdev limit %d\n",
 			    TARGET_NUM_VDEVS);


