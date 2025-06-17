Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CF42EA487;
	Tue, 17 Jun 2025 15:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174804; cv=none; b=rr5JRmzJ8JZpsOS+2qgHHNgJTDsCI+6Hml1BmDa4qIjG1YLgQMS1YAp+E5isU7vOVnWNd3/aMZjnnjQgc7Xfke4ytHKzfyt+uqEvhwMN69l9Hhyk+bcWG1kTrCYAMrbqNEEFaftoMww0GDIu2bLr6PUY5vhoYUo5KfQY7lpFYGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174804; c=relaxed/simple;
	bh=4DskMkXS1QfhBORXv1nE9Ab8hqbILmuk8I6k9hPuCd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpxCYPoEMBeE8uQsXqd3yzsorfh3Iw4NvSJtGP5rrtQQocseTlRAdIlNLNmXP9n+NaH+5wuVOPoBf9DSCGOAktlHmvQkdSdBxxY16SR4ha4lvUGQKSzFnTOrVsmBQMlOtEofGEYqLiE3P0XhsZ30Zo6f+NQM6qQiVbAz6dgZ7EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6qvHVJF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6qvHVJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32772C4CEE3;
	Tue, 17 Jun 2025 15:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174804;
	bh=4DskMkXS1QfhBORXv1nE9Ab8hqbILmuk8I6k9hPuCd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6qvHVJFsNvbEluWMM7s06gSO1j0U2wVsnm7Kw2j9JeWevwgqTZBEOqi5vTxrxIOR
	 pT0/v9yOiDPFnQ6Zcz3pO0BSgYn9nnn3LCkZODZEHtMiuo0UI+hIDEKtCiWpJV+BDd
	 N19JAvIjdsbrXIXmw5zj41MLw4xTtdQzPc3NTZGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Badal Nilawar <badal.nilawar@intel.com>,
	Anshuman Gupta <anshuman.gupta@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/512] drm/xe/d3cold: Set power state to D3Cold during s2idle/s3
Date: Tue, 17 Jun 2025 17:20:28 +0200
Message-ID: <20250617152422.082658452@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Badal Nilawar <badal.nilawar@intel.com>

[ Upstream commit f945dd89fa8da3f662508165453dafdb4035d9d3 ]

According to pci core guidelines, pci_save_config is recommended when the
driver explicitly needs to set the pci power state. As of now xe kmd is
only doing pci_save_config while entering to s2idle/s3 state, which makes
pci core think that device driver has already applied required pci power
state. This leads to GPU remain in D0 state. To fix the issue setting
the pci power state to D3Cold.

Fixes:dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")

Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Badal Nilawar <badal.nilawar@intel.com>
Signed-off-by: Anshuman Gupta <anshuman.gupta@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://lore.kernel.org/r/20250327161914.432552-1-badal.nilawar@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/xe/xe_pci.c b/drivers/gpu/drm/xe/xe_pci.c
index 025d649434673..23028afbbe1d1 100644
--- a/drivers/gpu/drm/xe/xe_pci.c
+++ b/drivers/gpu/drm/xe/xe_pci.c
@@ -910,6 +910,7 @@ static int xe_pci_suspend(struct device *dev)
 
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
+	pci_set_power_state(pdev, PCI_D3cold);
 
 	return 0;
 }
-- 
2.39.5



