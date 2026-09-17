Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3641E3DB62F;
	Thu, 17 Sep 2026 18:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670622; cv=none; b=lV8UKVJQn5jKZRKyY23qi+IZKLn5+aaUlUde4IkKYzKV1jEPNH3CkxqtmPfr2ehZ95Til/sNo/RaMRvNbuudcLZBxKmluF6EXkdvGNnOEW8M57hnwQOAQgjIBg+bLZcVbUp4tOepQCqea40yU7QLVXy/4whgi5KaUN3YG2cDjHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670622; c=relaxed/simple;
	bh=ABfvSAKJzgISWpYDnQYkGYXfn6LoUdCMCIidan3ayo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVMOEoXLNF+UM7Na9qu8Kli4qLfTy+aVJMoaTwek/D5LnTAjQe75QHuWX+62p85wkydEuKGCiXG1jOAq9TDLHw+aB6/22S0DI1DNXpy7ngf7w9pmKRfJEVjvLylskGBCnbqiKHCRDG3RRrf4HVaPLIHiK7lTej4jH+ctuZ0e2gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xu68FMBR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xu68FMBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E67F1F00898;
	Thu, 17 Sep 2026 18:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670621;
	bh=osFaUf32WPhJL2VZRDeps4h00eXtrP9FK5unOnLN0uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xu68FMBR8bIunDoSeR8iVgsa5B10/x3PW7/9Bs6rDpev+Vv9M06hyx5tr6JlJIgs1
	 2hZqOEJ9/xdeKaB3ZS3DNY6tdAAKjHixbtnqADXCgL4qwE+VyFE76MjB/heCvoLEVO
	 poG2Jl1+vn8JedstC7X/phWqcqDMK0t8xRQCzniU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0683/1102] pds_core: dont release PCI regions for VFs on reset
Date: Thu, 17 Sep 2026 16:10:26 +0100
Message-ID: <20260917151557.399671616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e29478e14ac89..3348d46c752ed 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -503,8 +503,8 @@ static void pdsc_reset_prepare(struct pci_dev *pdev)
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



