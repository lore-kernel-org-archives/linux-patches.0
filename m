Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75D91F8AE4;
	Tue,  3 Dec 2024 15:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238705; cv=none; b=r3bpI16Ps4bqVCxNj/+c89Bofgqg08qMDssOpLkZF3682NmrpfiRCyWpeiouOWFU9nITxGO/1StpRMLcMoA6Z5uQt0Q4PmjX71nnYNZCSc67XBW5BGbv21zkigxzX9tWjh5Tf03mJks+ty4Nm+6Yv9Zo59ybTvE8W67zcV/1U7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238705; c=relaxed/simple;
	bh=Xm88Ur5L8mrH08Q9LcS+tcl2j8CBilFPBbsnI6EKXRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9lr9nh07t6BiDkjeIS5ljkE4Qxt9iJK/fWgLGbxL9+7L0FOnB04IP4dTPsc8isGpqyL8WIBVI9CmbDHpHDrA/9jyAkOwUpqAyY1PyKVmfv5eNwpJnEZWYqjV9TGjDQBvfdpIOcUxETY85OnvRx0fsSVOANMh5cnYsTZok6gScU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAN7Wbqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAN7Wbqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6FEC4CECF;
	Tue,  3 Dec 2024 15:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238704;
	bh=Xm88Ur5L8mrH08Q9LcS+tcl2j8CBilFPBbsnI6EKXRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TAN7WbqtVflOYtetahlL1IjbddHZj1/FL9Xuhb8Zivot9XGpkakIYMvblksoC0wUC
	 auEQT+M00k1IggZc2m4SyEHL/JJwZ6skrRACgr25aptmFR41gYUQM99a3QySFQS0j8
	 3j3yiTEO0YVhg+BQnoZtUiDof2tGdurzJ02Trj5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 368/817] eth: fbnic: dont disable the PCI device twice
Date: Tue,  3 Dec 2024 15:39:00 +0100
Message-ID: <20241203144010.206426810@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 62e9c00ea868ceb71156c517747dc69316c25bf1 ]

We use pcim_enable_device(), there is no need to call pci_disable_device().

Fixes: 546dd90be979 ("eth: fbnic: Add scaffolding for Meta's NIC driver")
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241115014809.754860-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_pci.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
index a4809fe0fc249..268489b15616f 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
@@ -319,7 +319,6 @@ static int fbnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 free_irqs:
 	fbnic_free_irqs(fbd);
 free_fbd:
-	pci_disable_device(pdev);
 	fbnic_devlink_free(fbd);
 
 	return err;
@@ -349,7 +348,6 @@ static void fbnic_remove(struct pci_dev *pdev)
 	fbnic_fw_disable_mbx(fbd);
 	fbnic_free_irqs(fbd);
 
-	pci_disable_device(pdev);
 	fbnic_devlink_free(fbd);
 }
 
-- 
2.43.0



