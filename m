Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FAA34D4CB;
	Fri, 21 Nov 2025 13:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733558; cv=none; b=YpzdujWyoXtoy5uCWgbXur2tF3V5vylvlCIaWiSam9YRDBdkh7cdEdFdlyGK3z/dr4GMg/BmjupJmvY0koCXUlG83+dFDH5zL78Kf0OmivIeslFUfw1nwadtDP2CXZ3JIm+zIxN1s0xefEzb47kPsIJ88AkjToUCYuZEZkaLP6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733558; c=relaxed/simple;
	bh=GKtYFsMINhdMczZY+79mqRmQv7Koh3cWNgEZdiZZz/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6QbUWFcioiRS/Ir0Dv8XDqFTqEiF/EZXX2zOFd9qzyMu1pmXlIUo+p41jLI7QvCPNLww/+MDwBZfovD8iph1rBM3NoZx/zApEaXDsnSO2Df6mU/SnPSTiH84oRx/nBaOcpacOL71MgS0y7JrPVIXYJe8Z8V+7LiNQpQ9tklTME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9Dhn8Cw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9Dhn8Cw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE02C4CEF1;
	Fri, 21 Nov 2025 13:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733557;
	bh=GKtYFsMINhdMczZY+79mqRmQv7Koh3cWNgEZdiZZz/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9Dhn8Cw0Yzt57RsgD/VWDt2i+ka55qfEeYSqKueRRywp5UblV43zvUiD55dgrgQD
	 7deKQtoC4jICG9PMXOWGWyMIDFHnKJ/+qAJCMgP+fCcKeKTdlSdEafPG56VgmtCplx
	 Oh82EPr0nFBpoGvxq3Hb+He1uMio0hb2Ns1/Csjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 510/529] scsi: ufs: ufs-pci: Set UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE for Intel ADL
Date: Fri, 21 Nov 2025 14:13:29 +0100
Message-ID: <20251121130249.182147026@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit d968e99488c4b08259a324a89e4ed17bf36561a4 ]

Link startup becomes unreliable for Intel Alder Lake based host
controllers when a 2nd DME_LINKSTARTUP is issued unnecessarily.  Employ
UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE to suppress that from happening.

Fixes: 7dc9fb47bc9a ("scsi: ufs: ufs-pci: Add support for Intel ADL")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251024085918.31825-4-adrian.hunter@intel.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/ufshcd-pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -463,7 +463,8 @@ static int ufs_intel_lkf_init(struct ufs
 static int ufs_intel_adl_init(struct ufs_hba *hba)
 {
 	hba->nop_out_timeout = 200;
-	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
+	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8 |
+		       UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE;
 	hba->caps |= UFSHCD_CAP_WB_EN;
 	return ufs_intel_common_init(hba);
 }


