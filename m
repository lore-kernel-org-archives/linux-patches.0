Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7233E9F85;
	Thu, 15 Jan 2026 18:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500040; cv=none; b=p/ASTiecPBXu5lGdGtodRNFfmHG+VF70E0urJrHTSZIedG/MfF9fyf2Kx/kHXmvS/tB8GrTzi3RFKBgzx+kiit5hDYpmIbv/MInqDVNR/nkZrFzyHO0sulYsUYH+JFXv1tQYbCPgSCm6oPWT0uC4uOl9QP42BMescPzFnP8uAfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500040; c=relaxed/simple;
	bh=GHgVidZP69yicPPfj4WsZ9mgnC8i/TmQDXckAwNav6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWbGX6hN9XrGYLn/tYkjFFCwPiToN+z57VHwekB04AxJJFoaokoxAgyTeLxD9o6Xzu5kwvgqk6qqulE9Ra19lqrXWyaoHcAwWSDXdt9xH6ANEUWd65hforE2/dSsbBj0rYBdzQi1PqFzbZPwiVasm9HNdQflxMxp8YPdet6bBEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CunlevGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CunlevGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058C2C116D0;
	Thu, 15 Jan 2026 18:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768500040;
	bh=GHgVidZP69yicPPfj4WsZ9mgnC8i/TmQDXckAwNav6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CunlevGhA+Ag/ELDYlP5dJeP2Ue2C6vr8ZhDl7+Ec0GK9VhIcBQfO+chnCK1N/UlR
	 UkUI3RBSQYFGSYekrmucBvbS9kpzrrf40R6N3aAVkR82eCfnLdI4kihoXTA3s6fOf3
	 vbPUkFk4lLSeaKAu2DXvwxEzjj/pwG3fini9onu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Di Zhu <zhud@hygon.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 437/451] netdev: preserve NETIF_F_ALL_FOR_ALL across TSO updates
Date: Thu, 15 Jan 2026 17:50:38 +0100
Message-ID: <20260115164246.755110132@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Di Zhu <zhud@hygon.cn>

[ Upstream commit 02d1e1a3f9239cdb3ecf2c6d365fb959d1bf39df ]

Directly increment the TSO features incurs a side effect: it will also
directly clear the flags in NETIF_F_ALL_FOR_ALL on the master device,
which can cause issues such as the inability to enable the nocache copy
feature on the bonding driver.

The fix is to include NETIF_F_ALL_FOR_ALL in the update mask, thereby
preventing it from being cleared.

Fixes: b0ce3508b25e ("bonding: allow TSO being set on bonding master")
Signed-off-by: Di Zhu <zhud@hygon.cn>
Link: https://patch.msgid.link/20251224012224.56185-1-zhud@hygon.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c9f2a88a6c83e..934ecac171ccb 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4894,7 +4894,8 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 static inline netdev_features_t netdev_add_tso_features(netdev_features_t features,
 							netdev_features_t mask)
 {
-	return netdev_increment_features(features, NETIF_F_ALL_TSO, mask);
+	return netdev_increment_features(features, NETIF_F_ALL_TSO |
+					 NETIF_F_ALL_FOR_ALL, mask);
 }
 
 int __netdev_update_features(struct net_device *dev);
-- 
2.51.0



