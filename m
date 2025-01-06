Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EC813BC39;
	Mon,  6 Jan 2025 15:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178803; cv=none; b=Nf7s8cgV42phL8kTjm/xahOL5cBLw98HKC+QTEtYDS1yxCJG+ZsdmJmlM5WDfcBqJYS8vvGtufFU6XlO+eocUginCjiJjhBesfvNau1ZwakepTEYkO2YxBP7vc0cv2b8HVIpeSMPRWHzREvwIDOKDGColkjBb+p8lorgB1yZrSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178803; c=relaxed/simple;
	bh=ioq8hDacpqG14hSqpT7ATsE/Jl8OaMB8yLQZ8OCDbDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0B6gquifw4W2my/hZbkH9wtekT6ZnAKBeUZUEKHBK82p9N74OurHGCCQ96JSpaZ/OWQZB6aGnvBBYTPgvI+lUj27DAPNtKzUGXDdxkqnWImMK+B2VlnxoDUGjAjpNY/tFg6n7zettqj2ox/2YuFFGCI+twA2twnJ51tPxm3oxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Bvujihe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Bvujihe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97349C4CED6;
	Mon,  6 Jan 2025 15:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178803;
	bh=ioq8hDacpqG14hSqpT7ATsE/Jl8OaMB8yLQZ8OCDbDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2BvujiheuDJt3PVQFPsDpLoyYmWlZRnxObbANXlz5ZKRdf2BLX2VRAOps+PUYNxlt
	 62OruJHMSXyDQ2E/q0Ptjb8XIkV8VjNwrWQFEX0Sf5jyMBasl9qxV73mXLS/QsW+C2
	 ouQQc9IsusaZvjMPvIZnNMpHUbkeyKvUKYQ2M8IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 070/168] phy: core: Fix that API devm_phy_destroy() fails to destroy the phy
Date: Mon,  6 Jan 2025 16:16:18 +0100
Message-ID: <20250106151141.109954198@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 4dc48c88fcf82b89fdebd83a906aaa64f40fb8a9 upstream.

For devm_phy_destroy(), its comment says it needs to invoke phy_destroy()
to destroy the phy, but it will not actually invoke the function since
devres_destroy() does not call devm_phy_consume(), and the missing
phy_destroy() call will cause that the phy fails to be destroyed.

Fortunately, the faulty API has not been used by current kernel tree.
Fix by using devres_release() instead of devres_destroy() within the API.

Fixes: ff764963479a ("drivers: phy: add generic PHY framework")
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20241213-phy_core_fix-v6-3-40ae28f5015a@quicinc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/phy-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -1023,7 +1023,7 @@ void devm_phy_destroy(struct device *dev
 {
 	int r;
 
-	r = devres_destroy(dev, devm_phy_consume, devm_phy_match, phy);
+	r = devres_release(dev, devm_phy_consume, devm_phy_match, phy);
 	dev_WARN_ONCE(dev, r, "couldn't find PHY resource\n");
 }
 EXPORT_SYMBOL_GPL(devm_phy_destroy);


