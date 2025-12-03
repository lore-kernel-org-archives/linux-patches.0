Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1718132E75C;
	Wed,  3 Dec 2025 15:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777068; cv=none; b=k8S9fjHBItDe2RfLUAqvuG/NdmPtv+re4dugcv8ZzAvKqBF02mJ9opgTxnA15fM35iEkCABDckvMMTB0G26sxhBZqyw47uzTRrWndNZopVF6rh3RIrmb6aB3EqJvoX5FB8muz9QfUUzkAOUy6K/NeOffA0jP4oFADzBx+vDP8YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777068; c=relaxed/simple;
	bh=lnEHmpXO5SDSMPNBWRsparEmAb7f4EE4oRIcUJOIOUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DI3AsdarIIe3+tmjDv/CitYIhkZGj8o/2Bh5XKYzbX0Z1Zlyzz7AuXsZuNPsM7Px9x5DmOeG1uqssYwNEkkdz/j2f3qyrcNeWkQn0OOihPpyJt3ipIM5Vmq6bcWHW7LP1OXBTtZN2mXCQ3A2vXkNgs6inBQ5PfVFmuhgDrqrNzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHjQEY+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHjQEY+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795ACC4CEF5;
	Wed,  3 Dec 2025 15:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777068;
	bh=lnEHmpXO5SDSMPNBWRsparEmAb7f4EE4oRIcUJOIOUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mHjQEY+KLzgocixmuz1qGpVP2YiKFHmp1EKsQXzaqkq/c5sqKCmOSXtHW9YszjkxO
	 4v8ADYahgjVxlJTPD4kiwe1LyzfK1dWqKs9wBpxridjkOOA/nCslhZgFhez+IiSPqX
	 BZ+6tQK3ydPAOQjXNiPxRNLCunwjjcM62tRHeLUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anurag Dutta <a-dutta@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 039/146] spi: spi-cadence-quadspi: Remove duplicate pm_runtime_put_autosuspend() call
Date: Wed,  3 Dec 2025 16:26:57 +0100
Message-ID: <20251203152347.905738310@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anurag Dutta <a-dutta@ti.com>

[ Upstream commit 10eaa4c4a257944e9b30d13fda7d09164a70866d ]

Fix runtime PM usage count underflow caused by calling
pm_runtime_put_autosuspend() twice with only one corresponding
pm_runtime_get_noresume() call. This triggers the warning:
"Runtime PM usage count underflow!"

Remove the duplicate put call to balance the runtime PM reference
counting.

Fixes: 30dbc1c8d50f ("spi: cadence-qspi: defer runtime support on socfpga if reset bit is enabled")
Signed-off-by: Anurag Dutta <a-dutta@ti.com>
Link: https://patch.msgid.link/20251105161146.2019090-3-a-dutta@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index ce0f605ab688b..d7720931403c2 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -2012,7 +2012,6 @@ static int cqspi_probe(struct platform_device *pdev)
 	}
 
 	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM))) {
-		pm_runtime_put_autosuspend(dev);
 		pm_runtime_mark_last_busy(dev);
 		pm_runtime_put_autosuspend(dev);
 	}
-- 
2.51.0



