Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9809D203718;
	Wed,  6 Nov 2024 12:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896812; cv=none; b=CNHfqqJqDxpHGGYfLd9EZm71aUCQ1dYXXcHbF9njivvLc0WK7u0jV9AqlLA5PKAXwGUFsNhdso1TQTTR20aIuOyxVQZZC0LaauPaRwdH9KXlxYbkM9dlpPz8xVEhrjSKymEdR9xjlpV2Z6nELDzXJIPIchjkTXHUnnCX0oDSVPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896812; c=relaxed/simple;
	bh=vfFhaFuza0PYC8rQWNhp5BVvoHqi1fvncbDVq5AlHn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCpTrPYeabPH0bOPiwGqAGC9PCWWutIvpDd9iSu1I5V9KoTWGPnZtXy+jeBqd1rePHEHCl+MV4YgkJDNNIqXN09na3eucWgnTA+jNnmCzs0KEOTXBJcCsAEVF1w8cxmj5ToI2TjIyOE/sf6feE6XKqh79WgEZueoeY2Tve+yCOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvRzNdC2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvRzNdC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6D9C4CECD;
	Wed,  6 Nov 2024 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896812;
	bh=vfFhaFuza0PYC8rQWNhp5BVvoHqi1fvncbDVq5AlHn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvRzNdC20/ZcnZMOnPMVs4hIRgK+EVHvrNgcRsLMXN1+RBUkdNPdLgTkx18nXbGch
	 y9ZxpP9fMkuqQeSNE/3sGmtfIlTzXinagYicLrD7gu4NAKyvQa3o+GN+ciWyDK3Ey8
	 KEGeXXA4BiNppai5QnKet5FRlhKK4HrMQxE+FvTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/110] firmware: arm_sdei: Fix the input parameter of cpuhp_remove_state()
Date: Wed,  6 Nov 2024 13:04:47 +0100
Message-ID: <20241106120305.425806299@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit c83212d79be2c9886d3e6039759ecd388fd5fed1 ]

In sdei_device_freeze(), the input parameter of cpuhp_remove_state() is
passed as 'sdei_entry_point' by mistake. Change it to 'sdei_hp_state'.

Fixes: d2c48b2387eb ("firmware: arm_sdei: Fix sleep from invalid context BUG")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Reviewed-by: James Morse <james.morse@arm.com>
Link: https://lore.kernel.org/r/20241016084740.183353-1-wangxiongfeng2@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_sdei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index 68e55ca7491e5..b160851c524cf 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -764,7 +764,7 @@ static int sdei_device_freeze(struct device *dev)
 	int err;
 
 	/* unregister private events */
-	cpuhp_remove_state(sdei_entry_point);
+	cpuhp_remove_state(sdei_hp_state);
 
 	err = sdei_unregister_shared();
 	if (err)
-- 
2.43.0



