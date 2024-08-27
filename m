Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF4F1BA88C;
	Tue, 27 Aug 2024 15:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771002; cv=none; b=M3R7xELmkbqwPjS7kEXnfmq8euJXHIxq0tAtka1y3jSXK1HmhA6IAd2sg7MmJOLKq9FcljJ6MKq8V87i9UGMiITSD/5s+FPAEI0YT6c6P+m6P0D48IqRd6AoPcW5Ohekaar4q4b8g65+H36LgHgw6QX7awuc1v6uhBh+ajPH+eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771002; c=relaxed/simple;
	bh=3RdubchbyW94y9MGHZk1lPMfuojcMBS4679TA7sgwVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZkyNnB5OQQ2vUgQAI77Qu3zBVIGN7iMtFCApUbB4a0tv/A2KaTmtKV//tQgH35+PTmEIeE3b1UGYMk9xYM0w0KHWSvAHKVlu7z4FoajfXxuCZ7bo6nGmcAKz1d00uOnrrkzFf8+nSfqUgyK6v+HtPN9dYEpi6jwtCxHDpJFydE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SYT5MW5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SYT5MW5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44955C61049;
	Tue, 27 Aug 2024 15:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771001;
	bh=3RdubchbyW94y9MGHZk1lPMfuojcMBS4679TA7sgwVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SYT5MW5JeQATnqBla5+RBolcoymghvBqud/j5ypcPdkvqAyXpfMbcEuRyzT+vg0Em
	 k0E/MOeY1HH1nVUeRdurFnoq5MSflf9+tH4FoNiwblC1hk1NSQ+qNUQDLwXOFPrleQ
	 zX9yPZE87Ko4NupJ0qu+E+Sga+XxbDf/sLRFQIp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael van der Westhuizen <rmikey@meta.com>,
	Breno Leitao <leitao@debian.org>,
	Dmitry Osipenko <digetx@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.10 030/273] i2c: tegra: Do not mark ACPI devices as irq safe
Date: Tue, 27 Aug 2024 16:35:54 +0200
Message-ID: <20240827143834.539418545@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1802,9 +1802,9 @@ static int tegra_i2c_probe(struct platfo
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


