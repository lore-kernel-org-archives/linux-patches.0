Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4186C28DC4;
	Wed, 20 May 2026 17:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298485; cv=none; b=jM83/A0avhXoj6vdxnvZisOjr6BFnQ9G+uPUq+K7gIzjfkc6dC3L8qnUflhCvbagn4i6s3Opci+KY9lhoGcKY6042SDdGEd20uMC95wiHqvVU0BKcucmfenBOA6bGBEY4po3n9tYDIy43qvm8ZLrsv3ul2U4dYkc4rWCpBbI0Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298485; c=relaxed/simple;
	bh=HMgqyjFWDYquMCJYHq2pa+HR6hEpCQ3i0WqcoRlBbL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBv8hBdOhy7fWsy0SCj9APUU7hf2tFFQqAZWFH1QZCRDoV5UGpQOqepuofn5fE6Rbbx1qAvwBTPC6H/Dmsokvhc/uPei0TIo9LUfoHBhBby7BDgdV1/p6ZOTObBq6FmyeDeAorH3/lLsIQpEA9+YBcKv32eFuDdYk6v5NprD1UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fUb5t+5z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fUb5t+5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61D61F000E9;
	Wed, 20 May 2026 17:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298484;
	bh=IL/e0A4d4mDFFT0f6iitANJzYtY4zTX9bjAhwi3mm4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fUb5t+5zk2z/k+klAYp5+Ddn2ub4NbQq43cLs6OMFPUfxp0a72Vc56t/38NIPaFlA
	 7670C8h4MnQL0ix9XNtBzpKSagtkq6p9HQBFhsruolTJ2re3GeXaI1Ji54Zo6OK7k0
	 w5RqgK6HrDRiLTbAL5tOso64d72sdIX4YwhM+N+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 427/957] soc/tegra: cbb: Set ERD on resume for err interrupt
Date: Wed, 20 May 2026 18:15:10 +0200
Message-ID: <20260520162143.782221632@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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



