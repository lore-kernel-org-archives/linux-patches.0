Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CEC1C4EEA;
	Tue, 27 Aug 2024 15:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772426; cv=none; b=oao6uzLDskQ/QMHkOhR5xbXFtWAbqMS1x/XUKYIwO2AQk3CEg2K3urI3fJRnKY9nMlw3t1UkBTiftT9Mme/v9fvaWS+QLJ4NUXG8p8s/AsWX5YvbZm3fzHlHNdjD9z5a5KB5MMC/AhntBHBLiRMQ21C350apBcTOm1D06P8HcvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772426; c=relaxed/simple;
	bh=LxSNKAAlMNt30KP0tlHGHW3GHQypv7GF4LrfyJNQ8Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRQlwvQmCkAwJxruykk10v+azltyg9gXJ1k6DYXSrCY66Y78p+PCcJAW2qwAReHxs5FSrxxDKPMlDIgBtDFC5wDPySDLZhjdklTQ+RpH4ALWnz8TIhMir902JcF4/iYwo89ZbD7FFtOjs0GtvpvEG1bAfl8jd1llRQnUpjUwKwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pHVniVnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pHVniVnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7412BC4DE18;
	Tue, 27 Aug 2024 15:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772425;
	bh=LxSNKAAlMNt30KP0tlHGHW3GHQypv7GF4LrfyJNQ8Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pHVniVnbucTpCY1igElnx8UDW6aPvdiRgVD7a5xKYqQ/5xAPRinY8GJcFnoZ0ciIh
	 pWad+vCmqstbIdkIpBAd0dO12hkmUwHlPWjZvtp2Z5nbFpewPeJM/FfLu6prPOgTra
	 LSNu7y4eoYWqqhTPmQjsxN+DF2x0TRi9Jaz513ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael van der Westhuizen <rmikey@meta.com>,
	Breno Leitao <leitao@debian.org>,
	Dmitry Osipenko <digetx@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 212/321] i2c: tegra: Do not mark ACPI devices as irq safe
Date: Tue, 27 Aug 2024 16:38:40 +0200
Message-ID: <20240827143846.302130822@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 14d069d92951a3e150c0a81f2ca3b93e54da913b ]

On ACPI machines, the tegra i2c module encounters an issue due to a
mutex being called inside a spinlock. This leads to the following bug:

	BUG: sleeping function called from invalid context at kernel/locking/mutex.c:585
	...

	Call trace:
	__might_sleep
	__mutex_lock_common
	mutex_lock_nested
	acpi_subsys_runtime_resume
	rpm_resume
	tegra_i2c_xfer

The problem arises because during __pm_runtime_resume(), the spinlock
&dev->power.lock is acquired before rpm_resume() is called. Later,
rpm_resume() invokes acpi_subsys_runtime_resume(), which relies on
mutexes, triggering the error.

To address this issue, devices on ACPI are now marked as not IRQ-safe,
considering the dependency of acpi_subsys_runtime_resume() on mutexes.

Fixes: bd2fdedbf2ba ("i2c: tegra: Add the ACPI support")
Cc: <stable@vger.kernel.org> # v5.17+
Co-developed-by: Michael van der Westhuizen <rmikey@meta.com>
Signed-off-by: Michael van der Westhuizen <rmikey@meta.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-tegra.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 3792531b7ab7f..f7b4977d66496 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -1832,9 +1832,9 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 	 * domain.
 	 *
 	 * VI I2C device shouldn't be marked as IRQ-safe because VI I2C won't
-	 * be used for atomic transfers.
+	 * be used for atomic transfers. ACPI device is not IRQ safe also.
 	 */
-	if (!IS_VI(i2c_dev))
+	if (!IS_VI(i2c_dev) && !has_acpi_companion(i2c_dev->dev))
 		pm_runtime_irq_safe(i2c_dev->dev);
 
 	pm_runtime_enable(i2c_dev->dev);
-- 
2.43.0



