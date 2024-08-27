Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51E373466;
	Tue, 27 Aug 2024 14:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769838; cv=none; b=JrUOTk4bBGHz8MfeWEFIJgHPElzVgDi3CqQL9ckEkc4UG2CY8WNb0OhZh2FBEJvdxRnn8FAawwcch7HJZJ6fifgELTiBH56ASgOSYMYlZqstSpYIVvfOBH+EgqTSxPzTOZi5BkEtVKCQRiqNW5Tsq1t0DBA6VMiGP9RkyCtelp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769838; c=relaxed/simple;
	bh=MRquWxTIG7H81+FsZpp++9R1horB119+wGhkLa0bhsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RN+KoMlwA1WhafkXQfX+MXwk6Bs4K7oXjWpPeG8qzCAmMi8kEcwouRpaNf+xKjy9WxSibs8fn6gRXQMDFohtxQktAUB7WGSjlk55M9Yd3MymJjHMokWlO5Diz0I1T2cqXhd5AbIeqrujVSQ6JVRLTyr9S16Wn7Rbg3j521pIlAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8jaWHpP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8jaWHpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1934DC61053;
	Tue, 27 Aug 2024 14:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769838;
	bh=MRquWxTIG7H81+FsZpp++9R1horB119+wGhkLa0bhsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8jaWHpPo19p4WarU/Ph2ilpLK49bn09JRS8gpZhX8Ba5ZW5vAuwv8LLFC/cHTzXp
	 T6v/z/R93WBHGOyn5MhVtUCSTbLC9M58N6/cZmDnCS+NAOiuP3ZIKe9R+rmK2XikIu
	 SPpdJPAZ0fr2VIOfQr/iaOVZe2FoY3OvzNeez+r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael van der Westhuizen <rmikey@meta.com>,
	Breno Leitao <leitao@debian.org>,
	Dmitry Osipenko <digetx@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 019/341] i2c: tegra: Do not mark ACPI devices as irq safe
Date: Tue, 27 Aug 2024 16:34:10 +0200
Message-ID: <20240827143844.136532532@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 14d069d92951a3e150c0a81f2ca3b93e54da913b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-tegra.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -1804,9 +1804,9 @@ static int tegra_i2c_probe(struct platfo
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


