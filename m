Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57ED02D739C;
	Sat, 12 Sep 2026 15:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226017; cv=none; b=XjOzY3KnUCgbnZXSFXsu+PB+nw4UTe/GtlOBvX0nlQmNZmvMPf88Wtq4ymKSf85tXYVFMLUfCkI8kjRfPh4TI6W6Con3dtwJeRb3CcM+Pb3DBBihY99FV0Hr1cTQa/otzuBQh0H5XcJA9oeV+nKqlrEgKWf+YZy6PyWh1s2JlJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226017; c=relaxed/simple;
	bh=omvxH7oIW2CwcwYfcMZauVopXRbFESjGQc6J6xpSuuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhkYQFPpChqI4284e0DGi6mwfQfj63ybiL3EApX8iA3zF2RWcHAcgrhK29GTld5y0EyHKuYdZB9DCIygMRUcRIfREPoFshGl1TckMnehUEfT5z1dJToN+1/9EvolPDvmf/rFkETre38zIG3OGKXof4k7i921qHsGN9vDUyz7shE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XNffgMeS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XNffgMeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94981F000FF;
	Sat, 12 Sep 2026 15:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226016;
	bh=yF7tK56Oh4fKBCwVvsikVzmf1vcAwDb5Ge/yzmOx1ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XNffgMeSht8wg3yaETz6+0cFr/hgfH1W/GYU3FsBInoM6Gh4pPydQEovSflxVdG3x
	 GQ2eSwQa7dU+gpTU0LW5PuFDfLZz2bZ/A6eVSqsHNazjrCTBciLC639jGEBt5PyxYS
	 Tuy2dE1FE4l/VWE0Te44wcSLhiNPsghgL1QOMjXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1314/1424] i2c: ocores: Disable clock on failed resume
Date: Sat, 12 Sep 2026 09:02:26 +0200
Message-ID: <20260912065636.688636416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 43eb13f13385a1e7251978a1977ac61b99edef01 ]

ocores_i2c_resume() enables the controller clock before reinitializing
the hardware. If the clock rate changed while the device was suspended,
ocores_init() may reject the resulting prescaler. The callback then
returns an error with the clock still enabled, while the controller
itself remains disabled.

Disable and unprepare the clock when ocores_init() fails so the failed
resume path balances the successful clk_prepare_enable() call.

This issue was found by a static analysis checker and confirmed by manual
source review.

Fixes: e961a094afe0 ("i2c: ocores: add common clock support")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260813153155.3953577-1-ruoyuw560@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-ocores.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index 350ccfbe86340..30168990f30e0 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -768,7 +768,11 @@ static int ocores_i2c_resume(struct device *dev)
 	rate = clk_get_rate(i2c->clk) / 1000;
 	if (rate)
 		i2c->ip_clock_khz = rate;
-	return ocores_init(dev, i2c);
+	ret = ocores_init(dev, i2c);
+	if (ret)
+		clk_disable_unprepare(i2c->clk);
+
+	return ret;
 }
 
 static DEFINE_NOIRQ_DEV_PM_OPS(ocores_i2c_pm,
-- 
2.53.0



