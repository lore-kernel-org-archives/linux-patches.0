Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642E43446B0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302078; cv=none; b=kmWVFpgmr00/Yn3QcHawuxwzskuniOTLv20MDGtMSisj/Lo5mac5nf8X2EIj2ABgEPOAaPx5AAFVLFhAX+3RsVg4F+1+791VuIaU265jBv7BbCm081clVp89E+BEXoePWR2nGhZBShGpCASeY+SK5WqG/kS5QRBJHlZdwaS5jJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302078; c=relaxed/simple;
	bh=VGkxdHyF1Q5NH6/81pzxeWIA/HdtOp2cxk/TbFCvoMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJmIf04k5bmzF5KQN9gvvYtwDAovKU+oskZ/jgZjjYL4EI4y/G272c94eJJ1KOrgzMPu7Omx+ZlxLa38qsCFNlEcT75RJeteBgHAsvoe4ek8o+WATIabsS2BzfPLBcV/C8pUct1c1/jQmz5DnKfzqeS0sFb05cxtvSxNCksD8wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DXUftBgt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DXUftBgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2616C116D0;
	Sat, 28 Feb 2026 18:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302078;
	bh=VGkxdHyF1Q5NH6/81pzxeWIA/HdtOp2cxk/TbFCvoMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DXUftBgtC6DZbHdjYiRvn51+g6o1SjT8uGzyDeB33iFqJuCsigh9qMHs1RqHWdCsW
	 HGc4sdGzuUixn6LaH3KrWJ887npM1OilpODtulvvdpBH2P+59572S+UKE2ZxcAVrer
	 05TstHnPrhYeSsWNg3hTqO3C1fKeaxYNZgKAWiuNEpoc0tACdUCIw0+AZ3s+/qs3yw
	 zMavH6slafvnCA8EPJ7ZzbFzur/eUMtqLg9FYnUffgeloL3wl8TVWcJpjCyj883f3R
	 9fA2GDnf4Zk88c78FOrkVFOHI5aLZjh1a6oNPgEx1Tp8fNPCYdBGsScp8iEZC40FhV
	 0zrGw+mGZhBPw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/283] EDAC/i5000: Fix snprintf() size calculation in calculate_dimm_size()
Date: Sat, 28 Feb 2026 13:03:21 -0500
Message-ID: <20260228180709.1583486-59-sashal@kernel.org>
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

