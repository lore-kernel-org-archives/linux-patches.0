Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A4C1DEFD7;
	Tue,  8 Oct 2024 13:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393635; cv=none; b=NzrpZ3l5kME28naaWiiEGFKDaYyDcCe4WlrNTWQteqIwIO6Uz/fIb9y9hF6kXihk+Hji3HJYs1vKHhuNxreC1w24kkJ/dIFuGakis4hXL4tI9/DbevadjYYAQpd3aP8tKGmB9kBr8VfjPWk2PItcy3/5N+JliKW/IseuQOM43D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393635; c=relaxed/simple;
	bh=GufAfIUsZBlS0Uo/mxPJquN8KXd7BPx9GOrNSHwRRLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TObeO3MjHjY8MGVghhtnf2nXlgbgm8GPRS7vxvbfO8UhxQJ8FEP05G7FgY/4IgktyekE/i9dnXjFEiW6eccp8Kc0F5EuysRzH+DQrUPPFFgFnUdS/e++O0aBpJ1yboEAr7q+IHmdxyxUHZ6ZYPI5kk/iRRFfwWlu1n22hoFZN+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQ8pv+Hz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQ8pv+Hz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EC5C4CEC7;
	Tue,  8 Oct 2024 13:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393635;
	bh=GufAfIUsZBlS0Uo/mxPJquN8KXd7BPx9GOrNSHwRRLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQ8pv+HzsC4lT+YtKH3+X0AsiaVAzKN/kU+p7fn4u8Jo2EarCjErhoAuCfQF5bZMR
	 6/OiaHnngNZ5PjuYF4WTrzvKXO/C0FUBmzI76dfr2dTxrL6uFKGYREaDwL2ZmcOoQh
	 ig7B9m+voU1PeX9hq2qmIC9lyWZRAo76V6X+bKDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 210/386] i2c: xiic: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Tue,  8 Oct 2024 14:07:35 +0200
Message-ID: <20241008115637.670506800@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 0c8d604dea437b69a861479b413d629bc9b3da70 upstream.

It is not valid to call pm_runtime_set_suspended() for devices
with runtime PM enabled because it returns -EAGAIN if it is enabled
already and working. So, call pm_runtime_disable() before to fix it.

Fixes: 36ecbcab84d0 ("i2c: xiic: Implement power management")
Cc: <stable@vger.kernel.org> # v4.6+
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-xiic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -1337,8 +1337,8 @@ static int xiic_i2c_probe(struct platfor
 	return 0;
 
 err_pm_disable:
-	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 
 	return ret;
 }


