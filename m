Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301EB2550D7;
	Wed, 25 Feb 2026 01:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983515; cv=none; b=fgTV7/rq2d4zqZgylDLjWQabndZJgQeBu784X6iwodAIXqO1ok7bZJQa0EZ9hknRicQPznEiEqMF1xhcnSn1gSCn8q6cigQAhse1yF4Uji1YJukl+s/B8XGOwwywom3xIIAHFh2a1LJRT475VxhmaCBtKvkAlTqykj/w75zDJHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983515; c=relaxed/simple;
	bh=RXDCvXS8tJXeGFgqpAHa3olv21NKTjMYDAlVSlWgrWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHHj7NLyAaS8Ct8qL7Ez1S9HUb6BYvqJc62woqx85n1Oa64GK9MUSstadMoyfobgMSH4nFV92pnfWiPnu2NNCi4V0x2TxmL4corf5Hf8hDn3oQdj8s+Enz2ePsgJaW1m1mT4NNkWpRYr2UHEJsyEQhHt5jpGty/gLdnirj1dbIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LjzDueKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LjzDueKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAABFC116D0;
	Wed, 25 Feb 2026 01:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983515;
	bh=RXDCvXS8tJXeGFgqpAHa3olv21NKTjMYDAlVSlWgrWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LjzDueKeQ6iKvdR1tdR/Rd4YYFN05URhhQSwp7xv+92LVrPr+u/FeMJaejcrdUXbq
	 DvMGvnPRqvnXsaXk9A9O1DAeoEqy68oTG7o/G4uGmEOBLOLMcpv6Dy5s+ZIgpR6sLs
	 2WWu97AtT/4NyhA0qM4Iiwvl+tnF8UtjsR1F03I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petre Rodan <petre.rodan@subdimension.ro>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 580/781] iio: pressure: mprls0025pa: fix scan_type struct
Date: Tue, 24 Feb 2026 17:21:29 -0800
Message-ID: <20260225012414.024241689@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petre Rodan <petre.rodan@subdimension.ro>

[ Upstream commit 8a228e036926f7e57421d750c3724e63f11b808a ]

Fix the scan_type sign and realbits assignment.

The pressure is a 24bit unsigned int between output_min and output_max.

 transfer function A: 10%   to 90%   of 2^24
 transfer function B:  2.5% to 22.5% of 2^24
 transfer function C: 20%   to 80%   of 2^24
[MPR_FUNCTION_A] = { .output_min = 1677722, .output_max = 15099494 }
[MPR_FUNCTION_B] = { .output_min =  419430, .output_max =  3774874 }
[MPR_FUNCTION_C] = { .output_min = 3355443, .output_max = 13421773 }

Fixes: 713337d9143e ("iio: pressure: Honeywell mprls0025pa pressure sensor")
Signed-off-by: Petre Rodan <petre.rodan@subdimension.ro>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/mprls0025pa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/pressure/mprls0025pa.c b/drivers/iio/pressure/mprls0025pa.c
index 4b23f87a822b1..6ba45d4c16b30 100644
--- a/drivers/iio/pressure/mprls0025pa.c
+++ b/drivers/iio/pressure/mprls0025pa.c
@@ -160,8 +160,8 @@ static const struct iio_chan_spec mpr_channels[] = {
 					BIT(IIO_CHAN_INFO_OFFSET),
 		.scan_index = 0,
 		.scan_type = {
-			.sign = 's',
-			.realbits = 32,
+			.sign = 'u',
+			.realbits = 24,
 			.storagebits = 32,
 			.endianness = IIO_CPU,
 		},
-- 
2.51.0



