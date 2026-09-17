Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A555A0ADE;
	Thu, 17 Sep 2026 15:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659622; cv=none; b=dRmRedITPAf3ilAQCPfwJBHmxzg3UpBxdxDMhb+Jzlp+wkxW9mahD3TCv43GLgOxv3R/OasB91l+d/IObQYDTGNVDN92uD8ckepc2pVk77yt6TvUv89yTXDbdJz1b50OTVE26iiTmz8xjT0614iEbNOQBIJBAlA9h/DjoiCiz6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659622; c=relaxed/simple;
	bh=rvP5F8stLwcPoG1956jE2e0dj1seX4KjkkDPBEZv2fY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rk8qrtqPQGf52DNVjeRNZxaBDXG/IqTHyAi3ioT4ORBfwN98iiqBz+NrkTU/vnwIUMC/iUpyaWSyI1BYXAOgTaoGXtDq/cJR8F0c6o5QknNpuQ6abDSXg84LC1v974/ooPs/UgoLjBOE4QKc6/1chpI72r631kUNGw0gLZQeyHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StoyKHfb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StoyKHfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D526A1F00898;
	Thu, 17 Sep 2026 15:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659613;
	bh=kF11iRRsVdiPkrNJfwccEraSEJeuF/0aeg52v5dnjJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=StoyKHfbiPveS6WBsDWV6D3zon7F0uYkfWhviZ6GjAuSISZVREjKd77U3DHAAmFFA
	 9vFrmhK+lsGvmgPK0n/M96nBNSnWIbZB+Hs8/CeibKEcuQafucOkpG2FPmM824Pr68
	 48Us6jt8mDpke8dpvYj4+tNpEsQzgT/TEIpXSUkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 288/733] pds_core: dont release PCI regions for VFs on reset
Date: Thu, 17 Sep 2026 16:09:56 +0100
Message-ID: <20260917151358.576923897@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit 73608de7e59246b4b533c1ffaee158a7048e186e ]

pdsc_reset_prepare() called pci_release_regions() unconditionally, but
only PFs call pci_request_regions() (pdsc_init_pf). On a VF FLR this
makes the kernel warn "Trying to free nonexistent resource".

Fixes: ffa55858330f ("pds_core: implement pci reset handlers")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260804235946.177762-1-nikhil.rao%40amd.com
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Link: https://patch.msgid.link/20260901044219.1361466-3-nikhil.rao@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 1b960139de4e4..a19269f6b66c7 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -511,8 +511,8 @@ static void pdsc_reset_prepare(struct pci_dev *pdev)
 		mutex_lock(&pdsc->devcmd_lock);
 		pdsc_unmap_bars(pdsc);
 		mutex_unlock(&pdsc->devcmd_lock);
+		pci_release_regions(pdev);
 	}
-	pci_release_regions(pdev);
 	if (pci_is_enabled(pdev))
 		pci_disable_device(pdev);
 }
-- 
2.53.0



