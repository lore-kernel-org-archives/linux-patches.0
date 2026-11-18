Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048174;
	b=oez7X5OgGkdhoUzMgjWvr8OqdEcRZkmdpkp4kJygWJnQ8emba2k1YYIW5Cpabxv8TGUw
	 vko7knnKxq3sXe5giCWpZD75eVmuA1kDV8zY62o+8Wtxz4iwEgsJDbDhTWfVHxFB5ZLr4
	 uGWiJcirzRBs26M0myciKoTavc3BabKmTPxFNkBcKWRQN9JGjkPkF2+ZBKm4BBk+lZCsK
	 FEYpmlUmt8WBF/wnLyyrQGdIKZHRl7yH7xMa8HwK7cou6FLMA6xqLqHx6N+uiuPB5F5cd
	 kU0vjMSgOdhIbN+Vykkue1mxa37H5zDvF9EREzK3da5Y+sUD8/KYaAdDSs3h+kqly9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aVcQvND/BkAWLP5bc9wfhewBHffZXoGCvqD5bv5pt8c=;
	b=TUKSPaLjzqKwi3w0m3MSxWFrWNTDmQW17rCYnxen1fK7zGOCD8caR6LORSH/WwJIlWux
	 v7+y52taRtE0SG/vHzb2BytRrTvOJEbPKrjuNdOfCzmv+A21NWghxsbh9FKWKmfWFwywL
	 FOErn6Y3wxv1S6SoeioveJgknOuBNXfbKc7NYkFIrk9xBkhht2khSbf2DUeArtJg5z0wt
	 gMVHG5xprLR+958O1oslSNAhacrH4fvvZe0znd6cGO06/un7kCRDfUWIffZtDqhmYxUhW
	 rjHsLiI4KwjEmg0T7gw5XPWuU4QaAGketaSv4YT07WwGC+Zyn0lZQAjqCayAUVLUWMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PZWdugQd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E42606A31C;
	Thu, 19 Nov 2026 00:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PZWdugQd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F1E1F000C4;
	Thu, 19 Nov 2026 00:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048174;
	bh=aVcQvND/BkAWLP5bc9wfhewBHffZXoGCvqD5bv5pt8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZWdugQdQxE1XrdmDbEuxZXYTvueN6wAk8g0HgPubDeLOw8Jy/0c+c7xApneuigIR
	 MSgipfVM5df5ueaEDWfQ04UDXkk+lud6pQyT4zUWF1PI4E6N/cpm4Cf0eitra6aNLT
	 89eYutvV5khLwk/BqKspfteWrJwly2qY4e5Rfpn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1861/2857] scsi: mpi3mr: Fix out-of-bounds phy array access on link change
Date: Wed, 18 Nov 2026 15:48:15 +0100
Message-ID: <20261118150308.245013762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit f67caaa2521a3c8f931d1e679d831ba5ca654794 ]

The phy number that comes with a link change is used to index the node's
phy array without being compared against the number of phys allocated for
that node.

Check it first.

Fixes: 42fc9fee116f ("scsi: mpi3mr: Add helper functions to manage device's port")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-13-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index d6ac71e1d9e4e..a95fec5f6f4e0 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1070,6 +1070,13 @@ void mpi3mr_update_links(struct mpi3mr_ioc *mrioc,
 		return;
 	}
 
+	if (phy_number >= mr_sas_node->num_phys) {
+		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+		ioc_err(mrioc, "%s: phy_number(%d) >= num_phys(%d)\n",
+			__func__, phy_number, mr_sas_node->num_phys);
+		return;
+	}
+
 	mr_sas_phy = &mr_sas_node->phy[phy_number];
 	mr_sas_phy->attached_handle = handle;
 	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
-- 
2.53.0



