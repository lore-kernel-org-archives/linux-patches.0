Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B7B15198D;
	Wed,  5 Feb 2025 14:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764896; cv=none; b=qbCNR002GrQ2fcbNkhYMTNZe9AGuBMoHFjx5jS6JM2Ntc4f2/+8VWVrOXdNHbXHkSTq7wD3UrINrAyxwtmjZNUe4r+x2jFDoThlAtiy2/GC5dd5kd+OEIDZW50loKi3QWgu7oI2fqaWUZHfsoN+bq7ePwInEe4IqBdYrYPbQEYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764896; c=relaxed/simple;
	bh=nBIAJB15vB47iKQquxarG/dN2TdfENBtRUKcw767JSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6SzSpQfdTf2OwXnrJoAqI9jINFkR9EHun8f6DoZNCXBHI61KJg94Y/PbGFRARiA21R0YLg678xQGAt1cWEHKDQkuJCl6HCQZidBzF7vil9O06KoPiBafIJT7s4+nlJlXIik5PAOrlpMBrk0qHHs4EvM6PVMR20E5PO2hTIxU0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yvNb6LXE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvNb6LXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E713DC4CED1;
	Wed,  5 Feb 2025 14:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764896;
	bh=nBIAJB15vB47iKQquxarG/dN2TdfENBtRUKcw767JSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yvNb6LXEHknWeTRS7nX6q/BE9h+ZHul9Qw7PIMhLBy8RtBueHkQ14Z6W/jmekpZXs
	 9SOsAd7NuvNU2qwlIUCa12relTTI+5xUc3jaYES0BtumdgU/oikXz+4QVUxHRUZy6V
	 sta1O+vU3s3Nv2zIoUsr3vUY9ifgmyntABShf9z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Drew Fustini <dfustini@tenstorrent.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 167/590] clk: thead: Fix clk gate registration to pass flags
Date: Wed,  5 Feb 2025 14:38:42 +0100
Message-ID: <20250205134501.671246555@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Drew Fustini <dfustini@tenstorrent.com>

[ Upstream commit a826e53fd78c7f07b8ff83446c44b227b2181920 ]

Modify the call to devm_clk_hw_register_gate_parent_data() to actually
pass the clk flags from hw.init instead of just 0. This is necessary to
allow individual clk gates to specify their own clk flags.

Fixes: ae81b69fd2b1 ("clk: thead: Add support for T-Head TH1520 AP_SUBSYS clocks")
Signed-off-by: Drew Fustini <dfustini@tenstorrent.com>
Link: https://lore.kernel.org/r/20250113-th1520-clk_ignore_unused-v1-1-0b08fb813438@tenstorrent.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/thead/clk-th1520-ap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/thead/clk-th1520-ap.c b/drivers/clk/thead/clk-th1520-ap.c
index 1015fab952515..c95b6e26ca531 100644
--- a/drivers/clk/thead/clk-th1520-ap.c
+++ b/drivers/clk/thead/clk-th1520-ap.c
@@ -1048,7 +1048,8 @@ static int th1520_clk_probe(struct platform_device *pdev)
 		hw = devm_clk_hw_register_gate_parent_data(dev,
 							   cg->common.hw.init->name,
 							   cg->common.hw.init->parent_data,
-							   0, base + cg->common.cfg0,
+							   cg->common.hw.init->flags,
+							   base + cg->common.cfg0,
 							   ffs(cg->enable) - 1, 0, NULL);
 		if (IS_ERR(hw))
 			return PTR_ERR(hw);
-- 
2.39.5



