Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81C6344D9A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301699; cv=none; b=rwo4Uga3cVjHyHWafo0HQaXaNb7iPzegrAhF01fwn+KfKWs+Dopt/fcb41eqBrmyBkVqfxWENzI3zb5sVLwwX7lWGJ2ce2Qat5nvf02E983pzgfz/g9V4RRAidzNf9aBVwScvWuvoXH2PKC2jtyLR4iHjNT0d58HJ9E3w0KeYXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301699; c=relaxed/simple;
	bh=VGkxdHyF1Q5NH6/81pzxeWIA/HdtOp2cxk/TbFCvoMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QAeLjbwFNMZFBcaX83Gn93NT2LqfoYeP2jMO/AS/TsiKernd4u/mMIbrdFkLDcdrdm4V+QCsgysyg6YNNUaTQfmkYDakWKD2X6zPkX5zqo9mQfqrJVsv3FfkuNnqG2T46etohcaAHLGyV/VQmauq5EmDznZP/ZsvOUhyyWdRyI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YyEHuluj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YyEHuluj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129ECC116D0;
	Sat, 28 Feb 2026 18:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301699;
	bh=VGkxdHyF1Q5NH6/81pzxeWIA/HdtOp2cxk/TbFCvoMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YyEHulujLZQ4aGQIJsWperVPkk1PyS6AA3Tjazj09SgaAZ/q9c10gnpwt2+qUE9BA
	 pZKdK1+NZIMNvqJ4vdbemy/gDWsYEta92yZWnmupW0J5xlyLVNWzglSzlRPoJ+hL9Z
	 XxSLidHgr9aIUOR+AeeK7vjH21q/TzJ+kqWgyPCK8sMDabFHR+UpNqrGXvxPpY3JkH
	 fP6ZcsVD2No3EJv1we4tGUc7r6ir0HzRfV4AnJTnbE09ToTxhxNzMcyUAcko/3bi9m
	 uTyZiUuEcqVT8qFQtg22JNwxj4Q5FiTt1c4G8d2tIQ9/RkbGlD6fsi3BSAtlK2q5V/
	 RK6kDCjQ564Yw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/385] EDAC/i5000: Fix snprintf() size calculation in calculate_dimm_size()
Date: Sat, 28 Feb 2026 12:55:14 -0500
Message-ID: <20260228180011.1568201-92-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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

[ Upstream commit 7b5c7e83ac405ff9ecbdd92b37a477f4288f8814 ]

The snprintf() can't really overflow because we're writing a max of 42
bytes to a PAGE_SIZE buffer.  But the limit calculation doesn't take
the first 11 bytes that we wrote into consideration so the limit is
not correct.  Just fix it for correctness even though it doesn't
affect runtime.

Fixes: 64e1fdaf55d6 ("i5000_edac: Fix the logic that retrieves memory information")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Link: https://patch.msgid.link/07cd652c51e77aad5a8350e1a7cd9407e5bbe373.1765290801.git.dan.carpenter@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i5000_edac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 4b5a71f8739d9..8c6a291e01f6a 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -1111,6 +1111,7 @@ static void calculate_dimm_size(struct i5000_pvt *pvt)
 
 	n = snprintf(p, space, "           ");
 	p += n;
+	space -= n;
 	for (branch = 0; branch < MAX_BRANCHES; branch++) {
 		n = snprintf(p, space, "       branch %d       | ", branch);
 		p += n;
-- 
2.51.0

