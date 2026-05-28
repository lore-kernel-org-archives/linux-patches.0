Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3426F3290B0;
	Thu, 28 May 2026 19:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998251; cv=none; b=HZmPv8XyI3sS8o383iofIhFu5oslZ0l5Du0uEJPwbgiivdmaqHqmV0vyeo6JCdYr6i4mg5A3fqlVHmaMpK0U/QWg1azFJdGRBIRpLjxhOWH4/qGQitReHuJRmJsXqkOZyp+GczTQdgx6c1PXRiG85r7cjNqpLwDrZ309Lsdobl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998251; c=relaxed/simple;
	bh=jPcmfHYfKwogiYEmYzcNpq9JHiWLWkilXsYFgWTon9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqVdXlue2nKjK50KLASPKP2M/Pc2FDzjTBzxfzyms0YYGDNNcPXzj1CPoozjLFx43fjHFlOMljas7YWenCU4CykEkOJrfVrNhnkbHHm3IiUAxo06eRguGYRtiFX7OoQOT42/IX2s0spZNAi4fjTddqaqO93YA2veLJDLfUFn0Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBMhZT2E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBMhZT2E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921421F000E9;
	Thu, 28 May 2026 19:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998250;
	bh=OlPFsHSYJ/yF4KzHCx5NDjb0gxeUwDVNZQAkQRyOYok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lBMhZT2E0dcw/D48DbcycS/If9tw4K7Ww52q/HPc2XdUOupfHdemjPSR44p7+soIM
	 7j9+e3jxIX01ez10Vta242+p30V9DTMe8OhIH1hOm9CqGkKkQn6LR2FwaBHU39kT1a
	 SalA25v7jjWrz4wEV5nM3FKgRLODJCASJJbINpmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Sachidanand <sauravsc@amazon.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.0 106/461] i2c: tegra: fix pm_runtime leak on mutex_lock failure
Date: Thu, 28 May 2026 21:43:55 +0200
Message-ID: <20260528194650.032369626@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Saurav Sachidanand <sauravsc@amazon.com>

commit 57cf4e8d6a57dc2ef5810f4852a23ba4c71b74bb upstream.

If tegra_i2c_mutex_lock() fails, the function returns without calling
pm_runtime_put(), leaking the runtime PM reference acquired by the
preceding pm_runtime_get_sync(). This prevents the device from ever
entering runtime suspend.

Add the missing pm_runtime_put() before returning on lock failure.

Fixes: 6077cfd716fb ("i2c: tegra: Add support for SW mutex register")
Signed-off-by: Saurav Sachidanand <sauravsc@amazon.com>
Cc: <stable@vger.kernel.org> # v7.0+
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260507221145.62183-2-sauravsc@amazon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-tegra.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -1522,8 +1522,10 @@ static int tegra_i2c_xfer(struct i2c_ada
 	}
 
 	ret = tegra_i2c_mutex_lock(i2c_dev);
-	if (ret)
+	if (ret) {
+		pm_runtime_put(i2c_dev->dev);
 		return ret;
+	}
 
 	for (i = 0; i < num; i++) {
 		enum msg_end_type end_type = MSG_END_STOP;


