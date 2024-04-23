Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB3B143882;
	Tue, 23 Apr 2024 21:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908739; cv=none; b=n8inIexemavhm0FdQ8tfmqzc+L8lpcgyJQ6d5x1QU0DWFD/7AIPX7oD/pMYx6fMr7FJx2uClYFmJOO9QH+9KxsDu0Jqy9clM/xljLP9CxSdsIDtulku0WU7jw4c5gaqpWOLht6tWcdbO/Hv70BtAdyJSbnMEqWODSH1hG1vAKTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908739; c=relaxed/simple;
	bh=3e9QiZSM87HXoskk9malujogzkzAXnUnpvy//f2tXF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAnUaTxrH52C7kS6WDJuOySJ7sUatOQiIt0ffDLoIejmyAymZpVNEToCBySLPXlJPLPoV8C7FTp7xE+JSSEErmCLEphWprPkvltYTPVH+ZWX3nWuy9BR9/Sz9JS0abonemtHAUmSPRQulVDUaML4gf1Be7gxVEwqO+CNWqbJWpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LlQ2RaQh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LlQ2RaQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DB1C3277B;
	Tue, 23 Apr 2024 21:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908738;
	bh=3e9QiZSM87HXoskk9malujogzkzAXnUnpvy//f2tXF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LlQ2RaQhVAtct+SyPjHHJCQ3YX9yzP7OGWErDZrmlrj5rJFDF7ua2+WbU5+HEeMJo
	 a4HhaYbR9BPr4JkIgElng7tuJI4wDMJnZwRmLELoezj9FJjQCyZT8l4t0mDX/Q2TxW
	 A7nAJAbQvn+aUpd91aEdNuAIfr2jcmWlHRpqf4Js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/141] clk: Print an info line before disabling unused clocks
Date: Tue, 23 Apr 2024 14:39:12 -0700
Message-ID: <20240423213855.909687218@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 12ca59b91d04df32e41be5a52f0cabba912c11de ]

Currently, the regulator framework informs us before calling into
their unused cleanup paths, which eases at least some debugging. The
same could be beneficial for clocks, so that random shutdowns shortly
after most initcalls are done can be less of a guess.

Add a pr_info before disabling unused clocks to do so.

Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230307132928.3887737-1-konrad.dybcio@linaro.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: e581cf5d2162 ("clk: Get runtime PM before walking tree during disable_unused")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index ad40913d80a8b..d841a9d7281c6 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1388,6 +1388,8 @@ static int __init clk_disable_unused(void)
 		return 0;
 	}
 
+	pr_info("clk: Disabling unused clocks\n");
+
 	clk_prepare_lock();
 
 	hlist_for_each_entry(core, &clk_root_list, child_node)
-- 
2.43.0



