Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295E915DBD8;
	Mon, 27 May 2024 19:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836883; cv=none; b=QpRtuD23KdJ+SMuMoQ1u/JuzPre6vpMCGwT9zifLBOGPA7LY30wrQNTOGCLX2KTyGJ+toYErRr6tcTeVZLAPhQV976/RfrRaxrATLmSMPR7EXU1+L/bcHmb32AnXrqvQRyRECgCU6XV4OqXDtE7xPkTfrdFwMgqBmMX9VbDtBaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836883; c=relaxed/simple;
	bh=0xf56kzAbJNE6Ib6B8d5+x1+8B/jITxJYVJcO4habDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJ3JkQmOHRe1L3bn/LX2SRL5X8QoBYBBY8H7ydAfcBTxyU1hSFxLr+ttJ8H+lJFtusety4f7a0XUNkaGd1Ugz6KAWSqsALAG6MKQmfAi/MLzjRxEqrfBIkpfv2Y8mP6bH/XBwGAZeKvk30GLlEiTG84HWUkptJmNyEONmSm7ycg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=liLCICWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="liLCICWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3829C2BBFC;
	Mon, 27 May 2024 19:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836883;
	bh=0xf56kzAbJNE6Ib6B8d5+x1+8B/jITxJYVJcO4habDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=liLCICWt7MTe2Ve0kYv+ME0sh4VC5swVZY9ncHve3HCwcPb7mYNsxcK9E0r3XqkFf
	 9jtQr9ExoLsv1xugvpqHdIWZSZFyqQRIbgbLd4JpDtqJWMO6l14Xo4sz36tyZTje/W
	 8oWw/ueQ2duvNW/1NzavimZ3nMifalZXhi0+fqoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 223/427] wifi: mwl8k: initialize cmd->addr[] properly
Date: Mon, 27 May 2024 20:54:30 +0200
Message-ID: <20240527185623.349047859@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 1d60eabb82694e58543e2b6366dae3e7465892a5 ]

This loop is supposed to copy the mac address to cmd->addr but the
i++ increment is missing so it copies everything to cmd->addr[0] and
only the last address is recorded.

Fixes: 22bedad3ce11 ("net: convert multicast list to list_head")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/b788be9a-15f5-4cca-a3fe-79df4c8ce7b2@moroto.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwl8k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index ce8fea76dbb24..7a4ef5c83be48 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -2718,7 +2718,7 @@ __mwl8k_cmd_mac_multicast_adr(struct ieee80211_hw *hw, int allmulti,
 		cmd->action |= cpu_to_le16(MWL8K_ENABLE_RX_MULTICAST);
 		cmd->numaddr = cpu_to_le16(mc_count);
 		netdev_hw_addr_list_for_each(ha, mc_list) {
-			memcpy(cmd->addr[i], ha->addr, ETH_ALEN);
+			memcpy(cmd->addr[i++], ha->addr, ETH_ALEN);
 		}
 	}
 
-- 
2.43.0



