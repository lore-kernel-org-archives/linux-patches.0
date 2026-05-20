Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCC43F789B;
	Wed, 20 May 2026 18:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300889; cv=none; b=dWVC3VZFfrFbLs655WSJL7kt21oHZOp+1p9lCSTaBBOkPdBJDQK4GrT4rC7tZdR1kY6TOIP78MKxQ18ecKOtHyG5XmlpXBQyZbTB8sypdZ1aYBz2IHMzZ31i4ec3Pz+tPpiGHrvdwiBtZX/TYCSkqp+AKTXSW1/oGeulo1jqO+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300889; c=relaxed/simple;
	bh=n7lhTvnsuJYFF3215jNTsNUdZYHxyuV0DCbtLL5N4F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaV94TVQ//9h242j2wn0jcnuUve4D7QE2u610HZSQ3BAq1S0FaKRyyW2br5HBcLnPLGkSN8pOQpjIuOrK/ujc9+pjNqi+xS+bxHqcKq1CGEZJlnkilUftn4fyjWfaYuaBaDArTMVTTGTLXOdItFhAw4Em/FYGe0eO0d8TsRj+7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XqgbwTSG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XqgbwTSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423581F000E9;
	Wed, 20 May 2026 18:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300887;
	bh=6qqnSQ09D+Z663YsV8VLVz63dXXNhDDmwOlOTYFjeb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XqgbwTSG6/ml3NOaI2hcZRrwYZXzR6noD6FxtV9Nj8CcEdP4MPoXH8f7MBdxiZBh/
	 EKKOy2n9Ax9lzGX2K4QpN6SRfHCHIVZCoatdk0anYNaK8N50hW+Wsh13Mm7o0gXokm
	 zt0x948ghSaq0YbSjyTqQaW/ublYkQGfoWAPV5Hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 305/666] soc/tegra: cbb: Set ERD on resume for err interrupt
Date: Wed, 20 May 2026 18:18:36 +0200
Message-ID: <20260520162117.831049701@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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



