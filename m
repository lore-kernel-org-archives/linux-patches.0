Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23166225417;
	Mon, 23 Jun 2025 22:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716630; cv=none; b=RcBISoaDnr71p2sc2ADGdFth69N3FH87Xjww8Gi05fJZPa+mRHKhVPtYUyewVNLRAk6CKm5tHNi33uIriCEvozuapFk1dabKmBY9Z3pxriSN8fbe44SocDND/UXxegTVuZL1xAmGy5T6/GKgGNQx2ZTr1ToTkI0sNITh1UDi488=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716630; c=relaxed/simple;
	bh=3WNK9dK4T+zjeZ9M55ASDhKwnUxM6Eru7EDJ6dENMdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=og7unYGgXoFQFvvhXVKePsfxZBKMvp21d1JaWZ1gm8OnuBpYpAIu6Z8funRtHQ7EmcF58YiUv3lcjKf14BQjyEdN7Wm67g5lMsXaRUKTcrPPotiNb9aQ2ow9j6f/r+xm8OsJpL8+eYY3gYl6OVCkWAo8Fie/Dj7iaFpYtPApZmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PwNTa1L7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PwNTa1L7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68FBC4CEF1;
	Mon, 23 Jun 2025 22:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716630;
	bh=3WNK9dK4T+zjeZ9M55ASDhKwnUxM6Eru7EDJ6dENMdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwNTa1L7otfJLKRrk4e7yLFV1MGkYPTdsE21V74488HXz+22VoLcwZfwidfgPnCLg
	 a3qcnkJNVJIw6evnU+oN04HREFSwc8sQOw6/ORaGn+XTknENdYuVl9Il/iIu0fIPWl
	 igHlHn0o16R7BC7Qo8Sy1saIVzhHNvZWTQAM0Mo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 543/592] Octeontx2-pf: Fix Backpresure configuration
Date: Mon, 23 Jun 2025 15:08:21 +0200
Message-ID: <20250623130713.356619217@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 9ac8d0c640a161486eaf71d1999ee990fad62947 ]

NIX block can receive packets from multiple links such as
MAC (RPM), LBK and CPT.

       -----------------
 RPM --|     NIX       |
       -----------------
             |
             |
            LBK

Each link supports multiple channels for example RPM link supports
16 channels. In case of link oversubsribe, NIX will assert backpressure
on receive channels.

The previous patch considered a single channel per link, resulting in
backpressure not being enabled on the remaining channels

Fixes: a7ef63dbd588 ("octeontx2-af: Disable backpressure between CPT and NIX")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250617063403.3582210-1-hkelam@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 84cd029a85aab..1b3004ba4493e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1822,7 +1822,7 @@ int otx2_nix_config_bp(struct otx2_nic *pfvf, bool enable)
 		req->chan_cnt = IEEE_8021QAZ_MAX_TCS;
 		req->bpid_per_chan = 1;
 	} else {
-		req->chan_cnt = 1;
+		req->chan_cnt = pfvf->hw.rx_chan_cnt;
 		req->bpid_per_chan = 0;
 	}
 
@@ -1847,7 +1847,7 @@ int otx2_nix_cpt_config_bp(struct otx2_nic *pfvf, bool enable)
 		req->chan_cnt = IEEE_8021QAZ_MAX_TCS;
 		req->bpid_per_chan = 1;
 	} else {
-		req->chan_cnt = 1;
+		req->chan_cnt = pfvf->hw.rx_chan_cnt;
 		req->bpid_per_chan = 0;
 	}
 
-- 
2.39.5



