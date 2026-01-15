Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881762874E6;
	Thu, 15 Jan 2026 17:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497552; cv=none; b=lNhcnFmrp8/eRl3fai2fWqJy/nUKEaGW/LFhV0aecthnt6LVDvRUDSL3r2l2XpXP3uKDoc30dLypJ4JXUbCyrpQ4kBwJInlK9MpRLGAzioa8GUqDv9eVJfAUutylYxqVh7W5qGJBF2gmJjhTxh2fXRpGwwvIEspWTs4jw9Msyrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497552; c=relaxed/simple;
	bh=HOMuuuEMKT8dxAQbc6viadf6W5uCXm4atAGuK9/IsfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AyzIZrBqrZPctpfwuDwbUVxjrYM32ba7PnBJJCZdcq1qlnsuPLq4NO8DryBdS/siAATfupyn4NCr8Cs5Lbh1i8gjTkkEShmGsk3oHIlCix8gBe58xWJV/PdXAtk2IoTRZPdJHNHc5gwjiAWS6Ajmu/Nz+6d7VnrCJJAZR6HTcos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xb4j+/Cc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xb4j+/Cc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153FCC116D0;
	Thu, 15 Jan 2026 17:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497552;
	bh=HOMuuuEMKT8dxAQbc6viadf6W5uCXm4atAGuK9/IsfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xb4j+/CcqbLrXBYdYLzZL5W8ck4UKP3mQGSWe67Vr35suhj5dOyKBCw4orhIYoL5h
	 6qQrjc3csVUmIA5Nip9P9GpEvqcgnja73HMpPHe6n33x5BXnKpl2HceDAm6XgnnPao
	 F5o7gtmZWjzxPNlA7jwnyOadNfDtRFlqM5aPlzPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/554] mfd: mt6397-irq: Fix missing irq_domain_remove() in error path
Date: Thu, 15 Jan 2026 17:43:07 +0100
Message-ID: <20260115164250.628561703@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit b4b1bd1f330fdd13706382be6c90ce9f58cee3f5 ]

If devm_request_threaded_irq() fails after irq_domain_create_linear()
succeeds in mt6397_irq_init(), the function returns without removing
the created IRQ domain, leading to a resource leak.

Call irq_domain_remove() in the error path after a successful
irq_domain_create_linear() to properly release the IRQ domain.

Fixes: a4872e80ce7d ("mfd: mt6397: Extract IRQ related code from core driver")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251118121500.605-1-vulab@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/mt6397-irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/mt6397-irq.c b/drivers/mfd/mt6397-irq.c
index 2924919da991a..e1daed7edc841 100644
--- a/drivers/mfd/mt6397-irq.c
+++ b/drivers/mfd/mt6397-irq.c
@@ -206,6 +206,7 @@ int mt6397_irq_init(struct mt6397_chip *chip)
 	if (ret) {
 		dev_err(chip->dev, "failed to register irq=%d; err: %d\n",
 			chip->irq, ret);
+		irq_domain_remove(chip->irq_domain);
 		return ret;
 	}
 
-- 
2.51.0



