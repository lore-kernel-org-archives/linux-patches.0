Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4177A3D9033;
	Wed,  8 Apr 2026 18:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673220; cv=none; b=K+dEC8fVZYsWN0AdD/1WGxWfO+E5G/A8fRHXp+UMECZex3vQEboQEPtnb0dLhapJQT6UGoTDXhM31h6eK7hCHcH2xyihFcDODV5xVCrS77Icf4m1KXPY/+poyJW3AU4SKleK0vwnRm+u2XuGSyF9vHRxcJR2fJdY9oIWpEOvTUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673220; c=relaxed/simple;
	bh=HCEEVUakN7ZdLeasFpItXzq0AOgngBCkPPKqDQxLx00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRJeIgcA8CHwU/VVUulUJbfZSl1rRZeUfkztbEsQBYvm/Fs9m+MARHm02IpQsvHhc8YHeu/6E8wW6cH+TD4uvrEiBdwMcTK2KSFiRxMITwB6UUfRkj/yd+cXF2gzfb+dDrEKOWOR/kEZ1nq1tIrN5jCC1Q9pBqIlerDeoRhAIKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEJNvW6T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEJNvW6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD5EC19421;
	Wed,  8 Apr 2026 18:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673220;
	bh=HCEEVUakN7ZdLeasFpItXzq0AOgngBCkPPKqDQxLx00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qEJNvW6TBIX76Wn2Yjo1S6GcuAYt5mJmrG+Ha9HyuQKYNA8lVjR3za7AQFXrrzmb3
	 D+UKkkpZ09V6jBewtH9CEglpXxM1EiNxZDLpfO3BapRl2Y6B8hf9kaufhs/YqCpOtk
	 VFiz1Zp2+Tq+/5/fnNTTCW5U+8kmkpZFQwLSWYtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 114/277] spi: stm32-ospi: Fix reset control leak on probe error
Date: Wed,  8 Apr 2026 20:01:39 +0200
Message-ID: <20260408175938.129833636@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 5a570c8d6e55689253f6fcc4a198c56cca7e39d6 ]

When spi_register_controller() fails after reset_control_acquire()
succeeds, the reset control is never released. This causes a resource
leak in the error path.

Add the missing reset_control_release() call in the error path.

Fixes: cf2c3eceb757 ("spi: stm32-ospi: Make usage of reset_control_acquire/release() API")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>
Link: https://patch.msgid.link/20260329-stm32-ospi-v1-1-142122466412@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32-ospi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-stm32-ospi.c b/drivers/spi/spi-stm32-ospi.c
index 5fa27de89210a..2988ff288ff02 100644
--- a/drivers/spi/spi-stm32-ospi.c
+++ b/drivers/spi/spi-stm32-ospi.c
@@ -939,13 +939,15 @@ static int stm32_ospi_probe(struct platform_device *pdev)
 	if (ret) {
 		/* Disable ospi */
 		writel_relaxed(0, ospi->regs_base + OSPI_CR);
-		goto err_pm_resume;
+		goto err_reset_control;
 	}
 
 	pm_runtime_put_autosuspend(ospi->dev);
 
 	return 0;
 
+err_reset_control:
+	reset_control_release(ospi->rstc);
 err_pm_resume:
 	pm_runtime_put_sync_suspend(ospi->dev);
 
-- 
2.53.0



