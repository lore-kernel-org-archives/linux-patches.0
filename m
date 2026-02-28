Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCF1347FF8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302532; cv=none; b=PHPXO36IezITmw1ciG6Kjiw6TQox4ZcZ1HaSVXSMxv6Hc/7CdBJF4b4OuGk7Y24PkiTqFhzuD5PmIak6FlX3tTiVQoXKo4Fp5D7/CoWPCi7gIj3P3iHldgFM65z/2S6FSmn7JxQ+N6wfqFqNp5ocCGySDjp6Qb2jzoYu5zOUzpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302532; c=relaxed/simple;
	bh=l60rLUv/1rBpY2EE6cMDOavrb5NY8VvK3x+Qf1zvtgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwwkV+dSUhfF8xZ3Z4XdunNG9Gn2zIBMuYe034d4P8zTUMHEln1i8b6mdunY1fk+9j7WG0FdxbkPqgzfWN/zif54xKwMUKHx0qLps0WnGqeOamxjtqNS2FaqX8bMsa/SCx0AUGXY2Lu+aQSoPFMCYRl28REmm8E1aWvm0x6ftP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NQnRUuOa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NQnRUuOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB585C2BC87;
	Sat, 28 Feb 2026 18:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302532;
	bh=l60rLUv/1rBpY2EE6cMDOavrb5NY8VvK3x+Qf1zvtgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQnRUuOanYQAyaA7DrQQLfOqjs6w/4noEW2d+z6RaeBpv2O8htTLQ6ZJmTkp1NoJt
	 hP4fe4U9Y55wr9qKf2mKe/MJn1b700o4V79z69dXitXQ7a95HUlYrzhhyQwKiHoYr1
	 oWekexW3K4DB4hA7ROQHR2wE7tBoV/GAFetglQY6zLJVNYW3pj3cCBErIzeUlPy/Lb
	 cn/E9aRJDDJIAgZbuwb00R3B7DBiH0+GHrdA6CDHQLhp+ADcARE+tPXSC8gVgBW/3N
	 WMuaRF/MZ88hOHMrFLlXA48Zxe1BuGEdyOtIyx1Lx0HWU9Uq2hF22EAecfvW2Uy99d
	 1m7IxiQ7KMctg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/164] EDAC/i5400: Fix snprintf() limit calculation in calculate_dimm_size()
Date: Sat, 28 Feb 2026 13:12:51 -0500
Message-ID: <20260228181505.1600663-32-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index f76624ee82ef7..5b1188f1b5705 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -1024,13 +1024,13 @@ static void calculate_dimm_size(struct i5400_pvt *pvt)
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

