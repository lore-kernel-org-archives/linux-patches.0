Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7814C37146D;
	Sat, 28 Feb 2026 17:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301463; cv=none; b=hk+agu1GmJlVv/Qgw1qnk8RirExAFe/0vRlplRCGjElsNP0eQ3HwKA72zDMa/pNSwHBuAIwY3tSMthVPLA4tsg89kmUbiUkuJsQm1p2TvN5g+oh3kT4aKoV4kAwg8OyR1uTfeWbHhoI0o239bB/k2fKFdzMowwADSVetzhwWVoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301463; c=relaxed/simple;
	bh=G9GwIaJ9gIxZ5AmUoyBqSUEXGS6+56r2NwHTvwc+K7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfgf8k9fRZitUsQKthkLnZzCdHppMuKj2g/ollRcoTuhSgTEdZS8eRD3LwAl2fTrAJgFPehDqa965IEPFhoJtink6950nT5RLzYF6wkbqBMlLVkZH4BEvNv2NBgO6P2lyLdUfjYWY+R8Rr0EiZZHlnxyokPhYOvf8/eqdD9Ih24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cngIKhSO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cngIKhSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC02C116D0;
	Sat, 28 Feb 2026 17:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301463;
	bh=G9GwIaJ9gIxZ5AmUoyBqSUEXGS6+56r2NwHTvwc+K7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cngIKhSO/9DUB48p1SvFvaUcxkPLbAiTeXUJSH21z7TIWiFseiJlXKszgHWd764IK
	 vjGwuHU070lF5X07PVKWPoCikzy+Y3v49uXF/6RS3th9Y69nbYAYjJ2eo4VsVgPaqq
	 4eZQQr+hWNtAQF/7ExuP5MZjJhm5ARPY8GHdW4kvjCiEcXmEtu+KmXWufSToEylT4M
	 cbaidNa2aplCE9X36GWdtFSBJV9KygQ1z7aXlJRDHzD/3VZcubpcNAUb/n3G2PAqks
	 FCPBZj9m6Zib1EysldqZKtejWNPVSkMwQWhBeqozxUldm39QuNictcZ39Kw79mj8JN
	 mK0bHRDZcp24w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Niklas Schnelle <schnelle@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 648/752] PCI/IOV: Fix race between SR-IOV enable/disable and hotplug
Date: Sat, 28 Feb 2026 12:45:59 -0500
Message-ID: <20260228174750.1542406-648-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit a5338e365c4559d7b4d7356116b0eb95b12e08d5 ]

Commit 05703271c3cd ("PCI/IOV: Add PCI rescan-remove locking when
enabling/disabling SR-IOV") tried to fix a race between the VF removal
inside sriov_del_vfs() and concurrent hot unplug by taking the PCI
rescan/remove lock in sriov_del_vfs(). Similarly the PCI rescan/remove lock
was also taken in sriov_add_vfs() to protect addition of VFs.

This approach however causes deadlock on trying to remove PFs with SR-IOV
enabled because PFs disable SR-IOV during removal and this removal happens
under the PCI rescan/remove lock. So the original fix had to be reverted.

Instead of taking the PCI rescan/remove lock in sriov_add_vfs() and
sriov_del_vfs(), fix the race that occurs with SR-IOV enable and disable vs
hotplug higher up in the callchain by taking the lock in
sriov_numvfs_store() before calling into the driver's sriov_configure()
callback.

Fixes: 05703271c3cd ("PCI/IOV: Add PCI rescan-remove locking when enabling/disabling SR-IOV")
Reported-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251216-revert_sriov_lock-v3-2-dac4925a7621@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/iov.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index ac4375954c947..c6dc1b44bf602 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -495,7 +495,9 @@ static ssize_t sriov_numvfs_store(struct device *dev,
 
 	if (num_vfs == 0) {
 		/* disable VFs */
+		pci_lock_rescan_remove();
 		ret = pdev->driver->sriov_configure(pdev, 0);
+		pci_unlock_rescan_remove();
 		goto exit;
 	}
 
@@ -507,7 +509,9 @@ static ssize_t sriov_numvfs_store(struct device *dev,
 		goto exit;
 	}
 
+	pci_lock_rescan_remove();
 	ret = pdev->driver->sriov_configure(pdev, num_vfs);
+	pci_unlock_rescan_remove();
 	if (ret < 0)
 		goto exit;
 
-- 
2.51.0

