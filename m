Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8295B3D8129;
	Wed, 20 May 2026 16:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295784; cv=none; b=QwbJQNk7LqNYbzbcjyRbhZnUAniy2ibHTwgha+ycoH3gJlQvSzls2hxzzOcuELYhSwPozskHdbpA4nRunnYJe8MO1TzidG3UgrRRmLu1pI3+T+Tcc+YyQw6Fgo61ejnILvwKP/13HKGzwFbi1I4VgAAcY2FEcdji3X7hS+hjRDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295784; c=relaxed/simple;
	bh=d1qbEZZmXsUJH55bRFNxwN2HqhPn0HfwtP1MeSET+9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5cOEuveeSk+llLA12hTe/8qgKpgMhI5d4PquQtdI1vX0xTMXTAkmPnzlTigO94As4N021e+M4Tz8FJLQevsjbJYNFbjX9twxjSu4RJJSHx7ch1Kx+mKqeKPD09OOHU0w6ok7rKbwoZLUcrA6/oLBja3aX4GUs3VV6WM/N61XlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5p5S6Jz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5p5S6Jz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDF51F000E9;
	Wed, 20 May 2026 16:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295782;
	bh=wNadxTYEft/78lzgXXx93OgfyOv9TRLVUP4zYQ3T37g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q5p5S6JzaViZpmxPbODuUW6+KnhW4Kj4KfGkxV9waRNqOy5qjh2alzLE30LuTnxM7
	 sstBg7CcI92fHtulfApkqmTzYFJwhZF8lzLWv+VRndOkdD9bk11ILREi24Zq3NMd7W
	 cKFOTdL14473crkCRLvf8t5Fpaxsm9IWvtkocOXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0549/1146] soc/tegra: cbb: Set ERD on resume for err interrupt
Date: Wed, 20 May 2026 18:13:19 +0200
Message-ID: <20260520162200.602785509@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index a9adbcecd47cc..518733a066588 100644
--- a/drivers/soc/tegra/cbb/tegra234-cbb.c
+++ b/drivers/soc/tegra/cbb/tegra234-cbb.c
@@ -1586,6 +1586,10 @@ static int __maybe_unused tegra234_cbb_resume_noirq(struct device *dev)
 {
 	struct tegra234_cbb *cbb = dev_get_drvdata(dev);
 
+	/* set ERD bit to mask SError and generate interrupt to report error */
+	if (cbb->fabric->off_mask_erd)
+		tegra234_cbb_mask_serror(cbb);
+
 	tegra234_cbb_error_enable(&cbb->base);
 
 	dev_dbg(dev, "%s resumed\n", cbb->fabric->fab_list[cbb->fabric->fab_id].name);
-- 
2.53.0



