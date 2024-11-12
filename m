Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389F821B427;
	Tue, 12 Nov 2024 10:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407806; cv=none; b=h5ryXdjixhol1CAswb2Eb6DJIhzo8wZ2vLeMF+b8uTVcIsGUd4Dfwh8paHKyllMWuCZthasLEKgFw3ESCdWjR6+g059LgfT74SU5tdYAOJBTMGd9JmRfj0uCaTT48DpPCxQoRgXy6NHEYwrj9LG5MD39BpleqR6OdxbP1NmZwqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407806; c=relaxed/simple;
	bh=N1vPjMzG+IsUmdPudeYilaGkbuSM7+HJtkXb8xFkLA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHF+HzOw+62xCTNTBHzRXArGLhcl/LizstUR9h+i/1QuELJ2u9uMdWxwZzhE2DKvRyXjlHh7bZsWot3Mcg4sEmnZPzYPLVSGsq3EYN+XxzaUpUe+PLc9RNYnMlfcqVeC0QPU7LykDdn1l8YgGz2TzcoMI+JQaVk6XZeNN2XhnCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVm+6AQ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVm+6AQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A3EC4CED7;
	Tue, 12 Nov 2024 10:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407806;
	bh=N1vPjMzG+IsUmdPudeYilaGkbuSM7+HJtkXb8xFkLA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVm+6AQ7C3cUo8EHmfcaRRH/Kp1/krMWozUyGCt3epkjI6hHrkgczPF8WH7n45qn/
	 MwslYvXatyQfi2nMVHsE3oTcb4Om76lJQY/x+hCGfOSRGwd65/aHgheOXDZ43xmQ3K
	 y1dTLTeZCuyHMECGvpMtOlyB372qtqBcBvT2lUJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.6 061/119] media: ar0521: dont overflow when checking PLL values
Date: Tue, 12 Nov 2024 11:21:09 +0100
Message-ID: <20241112101851.045921050@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

commit 438d3085ba5b8b5bfa5290faa594e577f6ac9aa7 upstream.

The PLL checks are comparing 64 bit integers with 32 bit
ones, as reported by Coverity. Depending on the values of
the variables, this may underflow.

Fix it ensuring that both sides of the expression are u64.

Fixes: 852b50aeed15 ("media: On Semi AR0521 sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ar0521.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/ar0521.c
+++ b/drivers/media/i2c/ar0521.c
@@ -257,10 +257,10 @@ static u32 calc_pll(struct ar0521_dev *s
 			continue; /* Minimum value */
 		if (new_mult > 254)
 			break; /* Maximum, larger pre won't work either */
-		if (sensor->extclk_freq * (u64)new_mult < AR0521_PLL_MIN *
+		if (sensor->extclk_freq * (u64)new_mult < (u64)AR0521_PLL_MIN *
 		    new_pre)
 			continue;
-		if (sensor->extclk_freq * (u64)new_mult > AR0521_PLL_MAX *
+		if (sensor->extclk_freq * (u64)new_mult > (u64)AR0521_PLL_MAX *
 		    new_pre)
 			break; /* Larger pre won't work either */
 		new_pll = div64_round_up(sensor->extclk_freq * (u64)new_mult,


