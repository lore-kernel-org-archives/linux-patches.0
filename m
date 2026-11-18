Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039530;
	b=S320CN5J0T8P66A9YyGqO+y9Csx2oMDK/lllWB5UxFOzw/BWO3wt4iMECvLaOXtoqPFS
	 kFc83I4C/YPhp7XxmF7dxUxZ+lqAsp8l195yXB2+c5NEnE+xUMI9q+8S1i8uvqCFAzPZ8
	 E4sG10VQzC/bV06seRTGJEsVbAq9IVILQszoZOkgRJhaX37JArtefFE8afcNN7waMHSEZ
	 b79tqdC+PV7GJdw5N8S0lw85ozWZx/BiNnVW835tjD64+UrUI2CHjHHCeuxRFVgFkzfXS
	 kIKmFAy392NfpKYPG2jmz3COakeeET7+UWlNuCj4FP1rVSNLkHo/yDVv1YMwmgZpUzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hrJ+aDbKFpBxNpX8pQ4HqGO1KJUKln9E5dfpMIZNHgI=;
	b=BxPCIHkIG2Up8CtfBoadJRgUK6HFJE+1DqN2NN9K3t7LnHpCgyzp1zBuFZkvQVrloY/G
	 AcevIdJtdtK7aKeAgh6f0msGHG2/mhOism7aqlguu8wpkboGxnUM3hvNF3BePLUIq2H7Q
	 OoQRCh2C7MbwdCutmQqokp+OARtfwlYodfqoFbBFTgxbMj9QI0UBfXKaq+7JC5wB3U4m7
	 DyW0YnwvcNtsCV+5YemWM2HufmZVr9vBrdqUDu088v/AP9orCadT27e7YxXPR845xG4OY
	 SiNjcMkEu+rZ1aNLjR9x10fYZmIzMtuk/IGBJKkgG1sOAKtk1cpubKX9rV8z7w4FGOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1uNJ4vA1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A938606A325;
	Wed, 18 Nov 2026 22:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1uNJ4vA1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6105D1F000C4;
	Wed, 18 Nov 2026 22:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039529;
	bh=hrJ+aDbKFpBxNpX8pQ4HqGO1KJUKln9E5dfpMIZNHgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1uNJ4vA1ShaiZQypPeBP1OFMh/iAp2JyYPGn58xbwUJp2uXTU/TaolvBJxw7lFxjr
	 2KthxJOVAOuQtQt+541Avd5rVlB1M2X1uA6mYasyVXBbvObd1052MpGphLVxjd1rUc
	 PU/Xfg+XKsidnu/LnI8g9deCCacyEWD0ivwyAV4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2132/3318] scsi: mpi3mr: Fix out-of-bounds phy array access on link change
Date: Wed, 18 Nov 2026 15:45:54 +0100
Message-ID: <20261118150426.021606018@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e717d90cc15b1..b299c501809c0 100644
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



