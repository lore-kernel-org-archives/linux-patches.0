Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F021DEFE6;
	Tue,  8 Oct 2024 12:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392228; cv=none; b=rnYVgfE8Cg9Nji2Qm4pmWzvKJM0n0vU89U3vIr8Lkz34oiE0pfS5ypDQagB+rVlv/BTyws6X2xluRvYyQZVyEPk+qzlE4Jj/0iZhwK3BVIusMLphlIJFizvodcG27LKPNPuHJA6OgFjOxhvaGGf8nhccPrTHeQEzKCbikoxjGpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392228; c=relaxed/simple;
	bh=NVFdkKs4IdbmNZ+4vTFGClOSBHHfq3lb9jULCCICy/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+cNFIkmyO4j8qa+9LdiRjViyvr7nX30+xIbtaE039X7lOZyAOHqsiOrjHenUcPPdpcKHPJcsxiPCLSPcKJT8KKvxiToMaqhgwc02vzhM4VKzvGyiggMuBSjV1ZT0CVun7ZoGCavdvWneN5z57cO6q/c9nRjL1jVxj9RxAqjEpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WltC5pAQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WltC5pAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD28C4CEC7;
	Tue,  8 Oct 2024 12:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392228;
	bh=NVFdkKs4IdbmNZ+4vTFGClOSBHHfq3lb9jULCCICy/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WltC5pAQysbvpqArM2C0U51mWAFDwkfkJQX3wpr9dK3PjFWc+gJpD9YKhYiv/hMpw
	 PxZ9QDNXq2u8uJAaROBf+nHVeIz4Udj5sNnzKn4JH+wMMduzJ3A0omK0Ylh2+Xi9kT
	 hfjms2SLvFcuTtaw3kTqShYvzojgLZys9g86Q66I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.11 354/558] i2c: xiic: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Tue,  8 Oct 2024 14:06:24 +0200
Message-ID: <20241008115716.229263861@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


