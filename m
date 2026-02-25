Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED674369A;
	Wed, 25 Feb 2026 01:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982967; cv=none; b=dHeS50y/QIkDiLzkHnztL6IOgaBZ6jw9d159in/P2qUVQCaKwYd25QhFuzyicLw6pM/5abBBcXR2ivaJWHqo5PRfrMRGKaouLVGXalBCTfF1O8lzCga37axlcJV2b6LdVEBpZ050PIAgcRPiuJ9Kgwvi6HOUWNjed56ZKRxZ9iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982967; c=relaxed/simple;
	bh=qkJbLlA+bICKUzVZG/C6KuNdftn1HOQVppjmf67bDRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qbzr2oYOTCX5SALcSNT6Adj2aevtRnlJVv6rjy42lkEeQM8bzqMJCzoCZUlrtLhfnWty98X5Ns6KdWU8o9Xn2hmMkdTd5ZUayVmHStOhjZuEnT6+gAnUzfwA/SiawVpxUHZT8C7rT4gxsvxovTazqDBrRd53Bwb5vGzZmEctZ40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQj1JxpK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQj1JxpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833F7C116D0;
	Wed, 25 Feb 2026 01:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982967;
	bh=qkJbLlA+bICKUzVZG/C6KuNdftn1HOQVppjmf67bDRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQj1JxpKM+VjPC3vanAzNGj5Se/J1W6LRkaKBejSOU8tZpRtiNiAz26RsT9bf7Dzv
	 PRjaq+TErJqpJW/Ot2iHF8C2TekByNpiWgj66xhvKWK6BVD//fqTtoKBgriShz8fOD
	 RjlSRo8IoojoDaoAAcah4RzwIslkizevKLDT5uEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 142/781] EDAC/i5000: Fix snprintf() size calculation in calculate_dimm_size()
Date: Tue, 24 Feb 2026 17:14:11 -0800
Message-ID: <20260225012403.149585014@linuxfoundation.org>
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



