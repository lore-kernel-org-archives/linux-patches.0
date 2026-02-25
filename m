Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D5226E6FA;
	Wed, 25 Feb 2026 01:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983852; cv=none; b=atzeUjP7SAfzAwEmQfJTqy3ohBdoONfNbQIlI9RWkLSeGoFuJrA8q3rhsp42R18GP0NXblJYvI/uDHaFyioyBe3Qb8nz8vT8fm3D1p31ZXwz3SmtMupcv9JdXahgZZhNImpwQVj+w/kf4Jn/sZ4f/ZM41SZQnxYp6NE/+rO+7BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983852; c=relaxed/simple;
	bh=bVmqXDzKRI6LNXMqyJWdjMwaahC1jc/bdJH+D8DeBc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+JcPVVgBVJHDqx0zvNFAFFwxRU1y62eUhERnkAXGUut7RF9E6e3TR99Dkmse2Psgz5PFxaYC6cefIZ7tinTNHsozsIbpJ/0MBJFiO//cAW+IA6nBnyvFyK6dKSDtEPFT8A3r5cPgSWDBa5sdwc5YoXsdNaeACS8xwJv+Ejsr9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGd3vOkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGd3vOkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6196EC116D0;
	Wed, 25 Feb 2026 01:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983852;
	bh=bVmqXDzKRI6LNXMqyJWdjMwaahC1jc/bdJH+D8DeBc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGd3vOkNXbE7Ha0iO5do8Ddmg5KYF1tQe20bIU8J5pqAONiQ9n4oBVHJovdsiI9Xd
	 MBCDQjsfl5ZQCMzb7h3rZ71NKHxvfeubMdxWUA+XGQJU2HysVTf5ItDjst+ir9awWn
	 fK85ftBmCmAWpYuxz2Nbk3ptW+UySDAymz4YTp/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 128/641] EDAC/i5000: Fix snprintf() size calculation in calculate_dimm_size()
Date: Tue, 24 Feb 2026 17:17:34 -0800
Message-ID: <20260225012352.253205450@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 4a1bebc1ff14d..471b8540d18b0 100644
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



