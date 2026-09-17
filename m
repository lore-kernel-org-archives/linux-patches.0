Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA0A4973B9;
	Thu, 17 Sep 2026 17:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665748; cv=none; b=DcUNnVhWmF2TGqdWqyqmx5PO+Tl/vJT91eTvcNlZ1YPpgSt2FhSIgVzXG22ppT6k5djDw7dAoibe8qo3QXsrazcE+xzowlI161M4nhYvr2kpXdU32ghSx3E7jFKCj2tINnxQYzSJaap7M1NjrJO56eIYbU1Bz+yvD7QgrAonuPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665748; c=relaxed/simple;
	bh=YDU/WRggu7AN+99W86vugpmTYIfCVg/LeVJwKa5s0tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJOjOQzDez6QEsFT+8VP5vTon1rE1OD0dz3ffgUOY9hJI2zwYBU+v1koTIpE5/hWLvBlnhEexqkfSYaC6u2A9Y9GBhLkLcI6W+yRIWKR2NJygulGw1ftAxjkNWPITZzdTvuNi9LG7OV7SdcD2tfy9kNwzYhy5jTn5jzQmSto9KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ggf4u9Ff; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ggf4u9Ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0341F00898;
	Thu, 17 Sep 2026 17:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665747;
	bh=2J6d5kD7Q+iOUbH9qiTH5frCM4xLX5iWtbHRF1THhq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ggf4u9FfOlAEmrERMRhaQqeH9KvuKwKPMH+TspcrtOWW6y+WPsBq9cJq3Hg+ulHqy
	 LvxzhnvgCsdylzZ8di4VPTgqO3NiBPptItdjXNbOlgsKTxPLaaAhx1CH9JTk5IRZGD
	 4BCZJqEElZNNLGSHr0p8Yipt6zr/uY898N+2xia0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0806/1250] pds_core: dont release PCI regions for VFs on reset
Date: Thu, 17 Sep 2026 16:10:01 +0100
Message-ID: <20260917151613.759546642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ac3fbc5e3dccc..886b862b54b02 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -512,8 +512,8 @@ static void pdsc_reset_prepare(struct pci_dev *pdev)
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



