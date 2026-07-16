Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEF22FFDE1;
	Thu, 16 Jul 2026 14:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211470; cv=none; b=YpQwKnr8u9XlrgyZUwp1WXMvXHRfPWyGQXdKQ4DjX4tBPUw5+leJmOsGEV34W1tN5PENFHJ8Y0Vb8jm1o1RKePx3UGu5ZuwiYYrAvFAt0LZN7/jiqlR5gqUR+SJjGFdybuukrwPGhhB8ZYRnUzAdpvJ0IvKX/Pt0D/sOMcPZ2AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211470; c=relaxed/simple;
	bh=YDgGnOhuiltQoGT1DUvBPiLYomTdLeAfCxbgEm+fLRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOWGTJxlt7aS3AJaes/Xu8RN0UUK2Rz/KDX/9Gz9/OgWdkdlT33ND7HRSzC4OnkzXhh6iMnZlnxFj55m3Noslo7EjIB/xxbsXAqRdojYIj2/+hW3ThONh1+56gi0yo1XGvatpn7nsG4mPFrif0j1DzZmsfkDULYJp9Hj46z826A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opBBhCRu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opBBhCRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6404F1F000E9;
	Thu, 16 Jul 2026 14:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211466;
	bh=YJ8odY8O/WDmoG7xSdkrFbOymp21WGsQvnERujWTFfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=opBBhCRuWWsekr/60wQ/Fm+lDBYqtjLJomvB+IAbK26aDP8cK0tAHDfiVmjbwNK6R
	 Df8L2F4CM/Y/xD+Rzo+G4saY2bsw0MBWNiFwc2Rpzu4SQWQYWkkGqVL6trdZpmUcTd
	 bd/4eDG2vq6Vl+BH54fnjM/xTKiYhcfbDObq4X2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 439/480] i2c: davinci: Unregister cpufreq notifier on probe failure
Date: Thu, 16 Jul 2026 15:33:06 +0200
Message-ID: <20260716133054.315313020@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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


