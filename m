Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673A419DF4A;
	Mon, 23 Jun 2025 22:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716203; cv=none; b=mcxR0Yx6gZD2lOKA+JLhwCa6SFPg60aH7fAsbjhdxuftjx0JZsVRD8GY50Uym1IY83adly1akUjSgDq7TMAzrtVErJ8wyejLItz24kqtmM5zqCRIqMqDkSxy/k7QeMP7QHie7jueDRuw48bI6QEuVohi4gQ0ujg9eti38QJLyrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716203; c=relaxed/simple;
	bh=MlPYJkbLC9Y94ZWFmP9vBcfX1i+gNBu+PQXzQnq5KpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g9xvdT2a8rZPqBa9W1zJX2V9LR9n3f+256qrjIXT8UMSanxxD/19vvNLWkSMAbahU39PA2CrUJdGKdXn3gUArXPeWnrT4l++MHMJOaRy/moHdC+HaOXF86LCY7sVpDq2SoUB1034eZfU1Y+a0nWZCE9zATzWsTHDrBOXp5ejXts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eeUO0CuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eeUO0CuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F087AC4CEEA;
	Mon, 23 Jun 2025 22:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716203;
	bh=MlPYJkbLC9Y94ZWFmP9vBcfX1i+gNBu+PQXzQnq5KpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eeUO0CuJPBS95uzcZsJn/mCgfs0hjF7fBh/F6FhVrxXjBgqG3+ateWra0DTGnVYXO
	 s5XakVqRr+eKWhQ0Y3wmRoKvMoi6TY6YcD2mAKYbA7Hy+R1hMGOX4OvLU6mne/PbAU
	 cmusZg6XCayRxSWt43tBYJNt5IahilqGecoIhN3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 308/508] media: ccs-pll: Start VT pre-PLL multiplier search from correct value
Date: Mon, 23 Jun 2025 15:05:53 +0200
Message-ID: <20250623130652.890430311@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 06d2d478b09e6764fb6161d1621fc10d9f0f2860 upstream.

The ccs_pll_calculate_vt_tree() function does a search over possible VT
PLL configurations to find the "best" one. If the sensor does not support
odd pre-PLL divisors and the minimum value (with constraints) isn't 1,
other odd values could be errorneously searched (and selected) for the
pre-PLL divisor. Fix this.

Fixes: 415ddd993978 ("media: ccs-pll: Split limits and PLL configuration into front and back parts")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ccs-pll.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/i2c/ccs-pll.c
+++ b/drivers/media/i2c/ccs-pll.c
@@ -397,6 +397,8 @@ static int ccs_pll_calculate_vt_tree(str
 	min_pre_pll_clk_div = max_t(u16, min_pre_pll_clk_div,
 				    pll->ext_clk_freq_hz /
 				    lim_fr->max_pll_ip_clk_freq_hz);
+	if (!(pll->flags & CCS_PLL_FLAG_EXT_IP_PLL_DIVIDER))
+		min_pre_pll_clk_div = clk_div_even(min_pre_pll_clk_div);
 
 	dev_dbg(dev, "vt min/max_pre_pll_clk_div: %u,%u\n",
 		min_pre_pll_clk_div, max_pre_pll_clk_div);


