Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D3C2D7DF1;
	Tue, 21 Jul 2026 20:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664718; cv=none; b=pArzunPIyWc3NU8k1vueybErvX4LpxrNiAXQbjAU8Vap/27GD8rfRIpkPpt+EhpOeD6AazUoibTaN29VuN3CNx665yQoI6X5UgdyxUjSBKNT7FPZcI6Ea7iIJ/bvFYDVrYk0tOwI1UH1zEw6iMZsGMkAd3zIMExBvF5m6SASa9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664718; c=relaxed/simple;
	bh=+0hKRkVxS9gUnVelZ8oCBWSr/4aTfzO+sx+4hZmHnfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSlOBlMXdy9iWFeXLajIARfL75cnswV4AHf17aI1fWfTXSbYLnynXJw3ItxFasFCKpfQP7ZGZS2PFa3xIRM8LazgYiRb8hcVKmFq+YOrqkNGhXpPTr+S+K9fooiDzP2hFiS5nB+51MuhrECSInuLcqqNxk0M7B5uTJlhWfPPw5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GgNOkdPk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GgNOkdPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF4D1F00A3A;
	Tue, 21 Jul 2026 20:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664717;
	bh=P/edV7zHzrU8MxBgU27QSenUiZFZEIoquDB+W+QVlHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GgNOkdPksD/jX12DrLSdbNXcrSPCTxApUZUMpxzXgf3LdbTwadwpyKAeiwUniiukv
	 qH88KiufKHfkTSrRphzElOfAUUULksM1CuPfywXA0GOhbhPyBJjdRtVnt+6kS6DfXd
	 SDcdObPgwrbp5Z5G+FFJSLLyHkRZxu1TvDEopHIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0032/1266] i2c: core: fix irq domain leak on adapter registration failure
Date: Tue, 21 Jul 2026 17:07:49 +0200
Message-ID: <20260721152442.515765484@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 8ce19524e4cc2462685f596a6402fbd8fb984ab2 ]

Make sure to tear down the host notify irq domain on adapter
registration failure to avoid leaking it.

This issue was flagged by Sashiko when reviewing another adapter
registration fix.

Fixes: 4d5538f5882a ("i2c: use an IRQ to report Host Notify events, not alert")
Cc: stable@vger.kernel.org	# 4.10
Cc: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Stable-dep-of: ba14d7cf2fe7 ("i2c: core: fix adapter registration race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core-base.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1551,7 +1551,7 @@ static int i2c_register_adapter(struct i
 	res = device_register(&adap->dev);
 	if (res) {
 		pr_err("adapter '%s': can't register device (%d)\n", adap->name, res);
-		goto out_list;
+		goto err_remove_irq_domain;
 	}
 
 	adap->debugfs = debugfs_create_dir(dev_name(&adap->dev), i2c_debugfs_root);
@@ -1599,6 +1599,8 @@ out_reg:
 	init_completion(&adap->dev_released);
 	device_unregister(&adap->dev);
 	wait_for_completion(&adap->dev_released);
+err_remove_irq_domain:
+	i2c_host_notify_irq_teardown(adap);
 out_list:
 	mutex_lock(&core_lock);
 	idr_remove(&i2c_adapter_idr, adap->nr);


