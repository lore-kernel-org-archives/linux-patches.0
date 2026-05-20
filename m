Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA3C403E9A;
	Wed, 20 May 2026 18:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302542; cv=none; b=TX9KLwcKiBJdTSxDZ5NYxJCRsEI+Hs6dAEY7QYtYkIeUGwh1r6z/mo7yo0q00cbjF2+CtuDbLu/UdwPZRAcDDLTy0vXM8gH/GONeADPcUNewTcDTLv39UlBhDmddiZM3VyoPKOBJAM4yOCWYC7fZSQ+g4D6HFM2YTQVCHf2VNAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302542; c=relaxed/simple;
	bh=aX5k7NgNtouCarVxlZ421LZySKE9qW3Micln4CfxtKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wgqe332sB0CCy3KYcVwcuyuCWCnGtepkBbEKXHrnnV+qzVvCcaTFkBgmB64m13FIFGF5NBZyKnQoXtEM40dimKjGVZYz8eRSnYSQPUtp5DZrbHhGKCzn+QtBXXyn0ENGQAtxy0uf2bLBO0+TegRozWO0EpPHgkiTFwSx+rfDNek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysS//uL/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysS//uL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EAEA1F000E9;
	Wed, 20 May 2026 18:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302540;
	bh=m/F5AJ0GzktEWKHf9fGtBeOytbylWv6GkWwsLREdGxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ysS//uL/0GveeEspxsuyvu4FwUzGuPcEpdH4mOCzZb4h/zqmZoMTG5gcDMOEVWYg5
	 k1GtE2tMS4TJamI18/te8TlsUoFuONU+NUoY32Vz1uGHB0EhrB/CzOb+n2kDp8fQ2q
	 NWR3Jl2c7717sVMFXPvf/e8PjZ6/36ECbLczywlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhang <zhangjian.3032@bytedance.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 254/508] ipmi: ssif_bmc: fix missing check for copy_to_user() partial failure
Date: Wed, 20 May 2026 18:21:17 +0200
Message-ID: <20260520162104.151952479@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Jian Zhang <zhangjian.3032@bytedance.com>

[ Upstream commit ea641be7a4faee4351f9c5ed6b188e1bbf5586a6 ]

copy_to_user() returns the number of bytes that could not be copied,
with a non-zero value indicating a partial or complete failure. The
current code only checks for negative return values and treats all
non-negative results as success.

Treating any positive return value from copy_to_user() as
an error and returning -EFAULT.

Fixes: dd2bc5cc9e25 ("ipmi: ssif_bmc: Add SSIF BMC driver")
Signed-off-by: Jian Zhang <zhangjian.3032@bytedance.com>
Message-ID: <20260403090603.3988423-2-zhangjian.3032@bytedance.com>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ssif_bmc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/ipmi/ssif_bmc.c b/drivers/char/ipmi/ssif_bmc.c
index e8460e966b83e..6928adb5df5ab 100644
--- a/drivers/char/ipmi/ssif_bmc.c
+++ b/drivers/char/ipmi/ssif_bmc.c
@@ -163,6 +163,8 @@ static ssize_t ssif_bmc_read(struct file *file, char __user *buf, size_t count,
 		spin_unlock_irqrestore(&ssif_bmc->lock, flags);
 
 		ret = copy_to_user(buf, &msg, count);
+		if (ret > 0)
+			ret = -EFAULT;
 	}
 
 	return (ret < 0) ? ret : count;
-- 
2.53.0



