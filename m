Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD151C8FB5;
	Mon, 14 Oct 2024 15:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919492; cv=none; b=X4vf5ZoX6OWJVc5hsH3F1PcI8ma95IolJdlx8przuBty0l7QWe/xCPoCHc+ahgmfBFj7MoWrM810PkjJBuXSq+fG2LWi3lv2r5xz+01VZGxkx0CRO1W47dl3AbwmA3ZPa88Cswihiv0iNRomGNixuuNU7z/hF0DixYJMh6XU9Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919492; c=relaxed/simple;
	bh=xR4TD6tHyeNddjNBXBCvwcVm9duxlsNuXz5kkLxX0hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPcoXBuMWGhueMoba5B2Kr5HCO2354AYS2FERgxXu88gcynPINVXlRcikkGo1uncHB1WB0B1m4tNAxyAVXjQW0qVMbEOG6/5OCGQxJYpfOm+nSyn9+sp+NH5si1tQNACd3MwVoVMSLPSoylmxf0dGlhOG/i804MJW9ILqWD34k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sc2ccHM1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sc2ccHM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6708C4CEC3;
	Mon, 14 Oct 2024 15:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919492;
	bh=xR4TD6tHyeNddjNBXBCvwcVm9duxlsNuXz5kkLxX0hY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sc2ccHM1KwMA01qdxhen6OrW7dOEcA2AGpY4betGb0BatY6DQL6fO0J8L/oetV8qX
	 aj6xaXSXNFBTrQst5kBN0r3dZ2HXCNmpivMy8ZPssA914Q3p/kuep7zbYh6TDvseUa
	 O2zlMcwmGuHrRuhRWcmZmQsXoopsbN78tsozkaJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 621/798] i2c: xiic: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Mon, 14 Oct 2024 16:19:35 +0200
Message-ID: <20241014141242.436581773@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 0c8d604dea437b69a861479b413d629bc9b3da70 ]

It is not valid to call pm_runtime_set_suspended() for devices
with runtime PM enabled because it returns -EAGAIN if it is enabled
already and working. So, call pm_runtime_disable() before to fix it.

Fixes: 36ecbcab84d0 ("i2c: xiic: Implement power management")
Cc: <stable@vger.kernel.org> # v4.6+
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xiic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 00998a69a6b13..d48b8429deb4b 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -854,8 +854,8 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 	return 0;
 
 err_pm_disable:
-	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 
 	return ret;
 }
-- 
2.43.0



