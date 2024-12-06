Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC03E10E0;
	Fri,  6 Dec 2024 14:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497150; cv=none; b=F2OewL8RaKXF0hw37eDdGhQgHUvBScSNSoITEErA0a5SClQ88sPylOUHsCZxKP+zkVUlhc41kOu5hZ3rBZ5HTtZ57GJ5yK4xDYFYswct6hkc9zQQkx0oAJ/OzZk7srONNzaveRTyIwd8R2EPGjoUSIKcXEPMsXIL3EqV5PolbG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497150; c=relaxed/simple;
	bh=tMFyKyJd7gHPC9tzWDK1Xm4o2ReTSWYzcqtJadMx9PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOxFB3tU0RDr5ujyyR3+w04bWRYli1XZZqS5V0kQvkbT+uuOQgGVgh9pUVcXBhYo0uYiNSQX+8+rWaG5GH4fajsQuxvYgqZRnD2H/VjBz+bfPuoDUCnT60uFkM4cWDeXV9dnbAeKfhgJUVSlXUJOCr0fYnWCKcqaAMHb0hmuWpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjFGdX8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjFGdX8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0555C4CED1;
	Fri,  6 Dec 2024 14:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497150;
	bh=tMFyKyJd7gHPC9tzWDK1Xm4o2ReTSWYzcqtJadMx9PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zjFGdX8GeegEz5pmozNCzRzQvOgECPLPJZj0DXMQJsryEO1BMmgs7QH54K2iZ8x3u
	 iVOnVms7pS/BsTHTywn1qI+lycm2Orsj2bZLhsvN1XcNwsttqkxg0LP+naTuZjyMsS
	 wX6AaDxIc6pFvSY0ZD8ogzaNQez+3Dx9wjGBx6dY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 207/676] octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_ethtool.c
Date: Fri,  6 Dec 2024 15:30:26 +0100
Message-ID: <20241206143701.428135634@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dipendra Khadka <kdipendra88@gmail.com>

[ Upstream commit e26f8eac6bb20b20fdb8f7dc695711ebce4c7c5c ]

Add error pointer check after calling otx2_mbox_get_rsp().

Fixes: 75f36270990c ("octeontx2-pf: Support to enable/disable pause frames via ethtool")
Fixes: d0cf9503e908 ("octeontx2-pf: ethtool fec mode support")
Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 8b7fc0af91ced..532e84bc38c73 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -343,6 +343,11 @@ static void otx2_get_pauseparam(struct net_device *netdev,
 	if (!otx2_sync_mbox_msg(&pfvf->mbox)) {
 		rsp = (struct cgx_pause_frm_cfg *)
 		       otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+		if (IS_ERR(rsp)) {
+			mutex_unlock(&pfvf->mbox.lock);
+			return;
+		}
+
 		pause->rx_pause = rsp->rx_pause;
 		pause->tx_pause = rsp->tx_pause;
 	}
@@ -1082,6 +1087,11 @@ static int otx2_set_fecparam(struct net_device *netdev,
 
 	rsp = (struct fec_mode *)otx2_mbox_get_rsp(&pfvf->mbox.mbox,
 						   0, &req->hdr);
+	if (IS_ERR(rsp)) {
+		err = PTR_ERR(rsp);
+		goto end;
+	}
+
 	if (rsp->fec >= 0)
 		pfvf->linfo.fec = rsp->fec;
 	else
-- 
2.43.0



