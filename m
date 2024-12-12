Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398842210F8;
	Thu, 12 Dec 2024 16:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019278; cv=none; b=W6P71j6+MUIWCpos4lIWnVMtVZuZNBw234BjmltbOgt0b4u7XgK6wQlTLDbYChuUlp24Ahz11SxD8cHs0tkhbU68O9EFvOHhdhMaKf5NOL/C9LGakvPvyS026IUEofjIcM0kWpDkNchgR+qLcadDyMKz8fnI1uWp70iq89IMo1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019278; c=relaxed/simple;
	bh=Q2dTMOHPbFyyGylOV0F93GltDgLn5CPMhnuMlIZ4AYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISTdAwyf5yk3dYs/iZfOMS2Hl3kQ/2TL2TIJU325LRVJVwJanl/eAc0mQmVFqy4U/veOFlQpk6bS6NoxaQF0fLXh6Naw4NlkFWvvZiQU+tNX9AWqF9ZJ34fCXHYuNE1wpzds6w1qiTPwmdcGHIaLfrCfP5apZ6Fd4qH4O4KP0CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2TCu1N7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2TCu1N7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD9DC4CECE;
	Thu, 12 Dec 2024 16:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019278;
	bh=Q2dTMOHPbFyyGylOV0F93GltDgLn5CPMhnuMlIZ4AYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2TCu1N7FTSNOyyQX5DwgwT+fJjhz8NVdg3FtMozr6gwDaz0xekObackeV4h8azQx/
	 9egyxz+AYh/v3ehnxO8L2VoZUrlyrsBgVeb8XUWDzfnsZZdPKuFy/NtKRTZOxcGC5h
	 SfvCNy0TQ1gOI27sEl7MgB1awH26tIlU0OKA65hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 158/772] octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_common.c
Date: Thu, 12 Dec 2024 15:51:43 +0100
Message-ID: <20241212144356.459763533@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Dipendra Khadka <kdipendra88@gmail.com>

[ Upstream commit 0fbc7a5027c6f7f2c785adae3dcec22b2f2b69b3 ]

Add error pointer check after calling otx2_mbox_get_rsp().

Fixes: ab58a416c93f ("octeontx2-pf: cn10k: Get max mtu supported from admin function")
Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index c00d6d67db518..d05f91f97a9af 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1786,6 +1786,10 @@ u16 otx2_get_max_mtu(struct otx2_nic *pfvf)
 	if (!rc) {
 		rsp = (struct nix_hw_info *)
 		       otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+		if (IS_ERR(rsp)) {
+			rc = PTR_ERR(rsp);
+			goto out;
+		}
 
 		/* HW counts VLAN insertion bytes (8 for double tag)
 		 * irrespective of whether SQE is requesting to insert VLAN
-- 
2.43.0



