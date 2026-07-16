Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CE822301;
	Thu, 16 Jul 2026 13:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210204; cv=none; b=mKYblocaJa385QeVBe/up/huYZ37tQ2dil0YpdDzcNy5pNByQ5tfcb2XBfp4dxYrKOpnswZ46jM7hvyWIK0XuDwzNyz5olOB0UtZBbdWrPJhPrN19Xo8h7gauXNYqED7gddgw5H8pOq0zcQPO5cSmId1OEbYwzMaoHL2Yml7EX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210204; c=relaxed/simple;
	bh=GLSrHbnl3USbfWu/cCutoDW7cPwAYQbB058RkMpMVSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cdt2rU+moPre7RNRaXfilwelamn1yyn1NI93yDnxK+q39j9+Zw4kaRZQpHxJXSXg9Yrj4iYFVM2W2TSAyrvK4vmi3iF2p/UDZpsp77Uxug0ugwko6ypelEt8sOwl3SXTxeOXFcOouaF8j0YLXWf8/mTv+rsaZg32nGULIA4mTNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A3B4goPc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3B4goPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173BA1F000E9;
	Thu, 16 Jul 2026 13:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210203;
	bh=CKWG6vfaQlvvuXhg9bm9OYPfHBWRbOoaRhD5H7368Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A3B4goPckSZdDZlLIvmuPjQZkPd70SYvOQPNxAlkGsZNs4x0Ma7GzMybytnNDG7iq
	 okPQSbfx6kKFDc/gt6Zg97Atuq0DgYbSMgeNpi4iso/2e7c0Vj25mMz9/NWkjTQSCf
	 L7usv3TXqJrKScg8VjLEE5D5hi983en9rZFji6P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.1 476/518] i2c: davinci: Unregister cpufreq notifier on probe failure
Date: Thu, 16 Jul 2026 15:32:24 +0200
Message-ID: <20260716133058.261917336@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit e43f32816a1b1fe5a86279411626fe3a9be56d45 upstream.

davinci_i2c_probe() registers a cpufreq transition notifier before adding
the I2C adapter.  If i2c_add_numbered_adapter() fails, the probe error path
releases the device resources without unregistering the notifier.

Add a dedicated error path to unregister the cpufreq notifier after
i2c_add_numbered_adapter() fails.

Fixes: 82c0de11b734 ("i2c: davinci: Add cpufreq support")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Cc: <stable@vger.kernel.org> # v2.6.36+
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260610030513.2651018-1-haoxiang_li2024@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-davinci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -818,12 +818,14 @@ static int davinci_i2c_probe(struct plat
 	adap->nr = pdev->id;
 	r = i2c_add_numbered_adapter(adap);
 	if (r)
-		goto err_unuse_clocks;
+		goto err_cpufreq;
 
 	pm_runtime_put_autosuspend(dev->dev);
 
 	return 0;
 
+err_cpufreq:
+	i2c_davinci_cpufreq_deregister(dev);
 err_unuse_clocks:
 	pm_runtime_dont_use_autosuspend(dev->dev);
 	pm_runtime_put_sync(dev->dev);


