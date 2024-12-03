Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B22A2C80;
	Tue,  3 Dec 2024 15:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240873; cv=none; b=hdXxH8Xx/XEpbyVnQCDrnTA6kzcgLalm0kpEcVtnUBOlpzoxrW19a04MfHO9ehfVNsxZlZocweafTtHgu28zOwiGA9WJkbg7IehhYHr4ds7xtBWBHjy+7eGYVJZm9GGnZfcEP4ddYRvuj/VhHUJcdOQRd5fI1bSIzNK+KK+dlYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240873; c=relaxed/simple;
	bh=Y69Zt9wdGIT5xkFRAUY6TfWdJqrqo4lubwAXQDBcr28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amhSRDKufy8jGDPU3iqe/91bUVMqukuYLYKpn3r53PEvxldr4LM2aSmn5WdXnSA6J1n1gZ2YJhKn8hpWNGiSq73ghMipcWmhsgyiOjhmjPDfFqdL1ey2TNmX2tsEb4hm7TP8u9QM/p4agk790CqyGP2+mo7rTQqVoEY9O2gSbjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OHHjl8gl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHHjl8gl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE3DC4CECF;
	Tue,  3 Dec 2024 15:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240873;
	bh=Y69Zt9wdGIT5xkFRAUY6TfWdJqrqo4lubwAXQDBcr28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHHjl8glEQE47Ehqrqqo/YIBzV4M7+PWxjxxuEeQGsBYMdKwZ+FKKMTLUQE7PHa5b
	 PW+FTAIQhljK4TKle+qSU2pFMnfnFNzxBuGGlOA/QPd9t0LYOMLo0SYDtou6zrTFfH
	 NpnyapQ3C4naXLHIExRPqOA/yhbum3FVD5a7bSBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 260/826] octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_ethtool.c
Date: Tue,  3 Dec 2024 15:39:47 +0100
Message-ID: <20241203144753.906683303@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 32468c663605e..5197ce816581e 100644
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
@@ -1072,6 +1077,11 @@ static int otx2_set_fecparam(struct net_device *netdev,
 
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



