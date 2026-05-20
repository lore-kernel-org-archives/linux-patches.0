Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8921536EA8B;
	Wed, 20 May 2026 18:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302273; cv=none; b=bS5w12BuIQoZJwIjCo2CCXziDXItQNMOElt+KjSQpSFNnyBw9Tq6hlUoVtF6CbNAX6lZmvupdqcMStJe10j4ztOZP2+N1xyv4B2jyDqO0nbOOhE1bIaYPGsPSuY2ezuNImo6RnbyH45MWWF+D40UUR4qvxf2DEj/zMkqQIAr3LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302273; c=relaxed/simple;
	bh=VGgK4/xJlpB/M53XXs2bbIAmZcBUblGP641s43FQUUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRcQlyxeB1SgfR2gpMge7vhJhQ1McQxO5YnE6Xag+huE7JJAc0gcr/7Lj3zTQkMAg7F4bvnbTdbZchbSFZOaED7j4lvbuCOAkGTlL+8vTpfz2U3qKObTnbjkg4JtinPAwzUOUp1gSkfxpNkFrB5IJ8yOjswE+V6P3D8aU9lE2IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRD3gdvZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRD3gdvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D631F000E9;
	Wed, 20 May 2026 18:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302272;
	bh=eGCo8Gcx7gKAxj4pGzBlV9O23ePnJFjUgY5I4ZUYuV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRD3gdvZvYIzpLEtTh66Hb0Te0T2r1frxsxVxl4tGKxUiuHgbEu9PXj5cWLVrqs4a
	 CKkZSwGweB13Wrv4YDtIXvFDKpv4Nl2ysOxmzhhZQApElkZFtBFdaUEFH5D8jXoG0d
	 vPI7Nn4xUnfrAERXhD8KSQb1kcCGIVGQ7Y33gwu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 203/508] soc/tegra: cbb: Set ERD on resume for err interrupt
Date: Wed, 20 May 2026 18:20:26 +0200
Message-ID: <20260520162103.037045632@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Sumit Gupta <sumitg@nvidia.com>

[ Upstream commit b6ff71c5d1d4ad858ddf6f39394d169c96689596 ]

Set the Error Response Disable (ERD) bit to mask SError responses
and use interrupt-based error reporting. When the ERD bit is set,
inband error responses to the initiator via SError are suppressed,
and fabric errors are reported via an interrupt instead.

The register is set during boot but the info is lost during system
suspend and needs to be set again on resume.

Fixes: fc2f151d2314 ("soc/tegra: cbb: Add driver for Tegra234 CBB 2.0")
Signed-off-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/cbb/tegra234-cbb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/soc/tegra/cbb/tegra234-cbb.c b/drivers/soc/tegra/cbb/tegra234-cbb.c
index e8cc46874c729..eace89ed16176 100644
--- a/drivers/soc/tegra/cbb/tegra234-cbb.c
+++ b/drivers/soc/tegra/cbb/tegra234-cbb.c
@@ -1176,6 +1176,10 @@ static int __maybe_unused tegra234_cbb_resume_noirq(struct device *dev)
 {
 	struct tegra234_cbb *cbb = dev_get_drvdata(dev);
 
+	/* set ERD bit to mask SError and generate interrupt to report error */
+	if (cbb->fabric->off_mask_erd)
+		tegra234_cbb_mask_serror(cbb);
+
 	tegra234_cbb_error_enable(&cbb->base);
 
 	dev_dbg(dev, "%s resumed\n", cbb->fabric->name);
-- 
2.53.0



