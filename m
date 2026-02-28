Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1E3383C69
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302079; cv=none; b=Bc+9jZ17YjO8PEOpyV5BVHPKJlNJ25tJPnVTN6s8BScGeok77iWItAgp4C1j4DV6LJ1Gb7lariS6yUuXbcXC5tBI0nAAluW5QoNfbH1x+Jv07chdanongKD3KSxuMNbXNHi/eToSsLDm1/AQLQH40aTdfoNV6BTofllpVsUl/Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302079; c=relaxed/simple;
	bh=mI+wdgAwbsAkG4TZ0SztIQy85yl2XbqyWNpS7Vcdos0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d59/VBhQYbMvHLYlRAp8alLfBs0qEvZwzQObbNBrQ8kZfUlBRmH1/LfYJqiCeEssX5xo3DCiGa6owhr3duwdqzFQ1IHRkRGHC0Ua+zk7R3nmvd2lHYNa3ZU2WmcoS9PJwAnRrIQv5QZucCnoWnzfUvmlll9JJH/as1IghA2eng8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NAiqEjMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NAiqEjMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5ECC19423;
	Sat, 28 Feb 2026 18:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302079;
	bh=mI+wdgAwbsAkG4TZ0SztIQy85yl2XbqyWNpS7Vcdos0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NAiqEjMwyjk4MXJuNyscc/U/1t1jH5F8MPdTurfSPAW/8Ny83HyDtd9OuHI9oc/iC
	 E7DXiBVQ3dDjVuNOykYsWI/5DRo4uPKHvJTtJZxtZJY/jeFyg2mHWWbsw3epQapT1B
	 z1TBrnpbj5rn7Cu3s2G/DJeCqa0nmf8K4HUaD5+LZgt/s1zLrR22gZdFbnxBsxAe2z
	 +W+jOyIXpcIk8JRYmIQZt1oKpoteJPfvtvkB3V9D85gIgXCP4rqurgE2ZvkEzFFsfv
	 79bH0RgHQTF1rbkxwsyr4l1R2fxNAZqWBYnJnu8iBwgasXmnEiT1aSnHWkIgvimG15
	 tv0hA9ldRz2rA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/283] EDAC/i5400: Fix snprintf() limit calculation in calculate_dimm_size()
Date: Sat, 28 Feb 2026 13:03:22 -0500
Message-ID: <20260228180709.1583486-60-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 72f12683611344853ab030fe7d19b23970ed2bd8 ]

The snprintf() can't really overflow because we're writing a max of 42
bytes to a PAGE_SIZE buffer.  But my static checker complains because
the limit calculation doesn't take the first 11 space characters that
we wrote into the buffer into consideration.  Fix this for the sake of
correctness even though it doesn't affect runtime.

Also delete an earlier "space -= n;" which was not used.

Fixes: 68d086f89b80 ("i5400_edac: improve debug messages to better represent the filled memory")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Link: https://patch.msgid.link/ccd06b91748e7ed8e33eeb2ff1e7b98700879304.1765290801.git.dan.carpenter@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i5400_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 49b4499269fb7..68afb3bb8e290 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -1025,13 +1025,13 @@ static void calculate_dimm_size(struct i5400_pvt *pvt)
 		space -= n;
 	}
 
-	space -= n;
 	edac_dbg(2, "%s\n", mem_buffer);
 	p = mem_buffer;
 	space = PAGE_SIZE;
 
 	n = snprintf(p, space, "           ");
 	p += n;
+	space -= n;
 	for (branch = 0; branch < MAX_BRANCHES; branch++) {
 		n = snprintf(p, space, "       branch %d       | ", branch);
 		p += n;
-- 
2.51.0

