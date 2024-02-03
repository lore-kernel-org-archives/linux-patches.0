Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81221175B1;
	Sat,  3 Feb 2024 04:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933414; cv=none; b=oHirwoR0z7LPFI8dnb4aE69blsiUbeqcB3IU+eiJVU21f54BtecJ3JR5Re1ZTFm2jYPGOY5k1P85N7DBe66YPukaG1Q8V8GG6c31NkEH9fB6ZhS3NiqHWTot/6ZfZfxpyM2asiY2mmBchRug/5Y+aLAjIc9pyO3YBRQxuezSOiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933414; c=relaxed/simple;
	bh=9ID9PSSoOfU/TFNaIqPuvJXB/v2V3vyO5t7SkJx9QeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjRmCFJdFsQQtSKQ+f4TDdwYZGmHxXJN+yi5O/+ZN5tLB007JddhWRUT6TXc++5HQiacLZaqjhnWjqHN9Bp/4OyvbI1XUpblPVix6LL6KkzoyPyaoGJyKnRBjVm6QnHprCCyeu6CB+BIqsn5ITp+YlAk5NVvzI7ffHp+HLgUnSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCEan9hT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCEan9hT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1D7C43390;
	Sat,  3 Feb 2024 04:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933414;
	bh=9ID9PSSoOfU/TFNaIqPuvJXB/v2V3vyO5t7SkJx9QeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LCEan9hTWw4N7FlxNheAJxaO7IpCkMa4sZOJg/YdTvuKeSJOtuTWpgt4UC0L1co2A
	 hRkCgN7gFFrJQioQzp3Dx2VLxa/busdH5mGnB48Ckg6LpW+54KQrXOWuGC2aqT/HLy
	 w3FavhYnDPZdV7M1b36yOOAg9nke0nS+ZWePALnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/219] clk: mmp: pxa168: Fix memory leak in pxa168_clk_init()
Date: Fri,  2 Feb 2024 20:05:10 -0800
Message-ID: <20240203035336.701663665@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit 2fbabea626b6467eb4e6c4cb7a16523da12e43b4 ]

In cases where mapping of mpmu/apmu/apbc registers fails, the code path
does not handle the failure gracefully, potentially leading to a memory
leak. This fix ensures proper cleanup by freeing the allocated memory
for 'pxa_unit' before returning.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Link: https://lore.kernel.org/r/20231210175232.3414584-1-visitorckw@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mmp/clk-of-pxa168.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/mmp/clk-of-pxa168.c b/drivers/clk/mmp/clk-of-pxa168.c
index 130d1a723879..cb0ebbd82038 100644
--- a/drivers/clk/mmp/clk-of-pxa168.c
+++ b/drivers/clk/mmp/clk-of-pxa168.c
@@ -306,18 +306,21 @@ static void __init pxa168_clk_init(struct device_node *np)
 	pxa_unit->mpmu_base = of_iomap(np, 0);
 	if (!pxa_unit->mpmu_base) {
 		pr_err("failed to map mpmu registers\n");
+		kfree(pxa_unit);
 		return;
 	}
 
 	pxa_unit->apmu_base = of_iomap(np, 1);
 	if (!pxa_unit->apmu_base) {
 		pr_err("failed to map apmu registers\n");
+		kfree(pxa_unit);
 		return;
 	}
 
 	pxa_unit->apbc_base = of_iomap(np, 2);
 	if (!pxa_unit->apbc_base) {
 		pr_err("failed to map apbc registers\n");
+		kfree(pxa_unit);
 		return;
 	}
 
-- 
2.43.0



