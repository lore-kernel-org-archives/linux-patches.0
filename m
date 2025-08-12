Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD122CA9;
	Tue, 12 Aug 2025 18:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024618; cv=none; b=q5yr50CAVMSah/LRRXj6SpP8ToivKkZrqN87DrMccX2XLypvb7XPrLJCK+89Gcdn+wk6+3qw9+cHR11k1XiDDGZQZChL3zxuCsiJMQCc7V8Vw1/tYEM8QW8+LwKSQIJzt54DCVG9N0sNNw8HaEHHxR0Vh2GCLORM9JGnRWPs3yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024618; c=relaxed/simple;
	bh=6O100+HzJB8wnRKnl/gnPjWfXqYwJi91kIIuG35ibMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=caXuIBZx8C8N3+PX8jQI5fckUliBItLYeC/qhMIBkxz/ugErCPkXhl7tK9coe54YDLLIWKZFr4PxZAVUr9gL9l0eXRnxZXj0tXgHiB83MiB6GHlaLZFn7Ay+emXzEaaLp6ZgaGOiLFVR1UlXnLPONYk5fyK+NCywU9q6J1mFXS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DvxZ8R4O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DvxZ8R4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BE8C4CEF0;
	Tue, 12 Aug 2025 18:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024618;
	bh=6O100+HzJB8wnRKnl/gnPjWfXqYwJi91kIIuG35ibMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DvxZ8R4OnK5jPKAROTDQTehZFG1lT3DhbRiz7TMgtIeERT55SNTigE99QxSqg+OBC
	 boVfKmNUO4jP20/AShf/sGM+Yv9IMLu+xMAcVzvZtPwaU4AK2/uKDlTj9Mno4D2Ult
	 pwEz1+X2KGXr3DnrOR4o/GtlqklfsJkd/vYMgNNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 427/627] clk: clocking-wizard: Fix the round rate handling for versal
Date: Tue, 12 Aug 2025 19:32:02 +0200
Message-ID: <20250812173435.508164102@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>

[ Upstream commit 7f5e9ca0a424af44a708bb4727624d56f83ecffa ]

Fix the `clk_round_rate` implementation for Versal platforms by calling
the Versal-specific divider calculation helper. The existing code used
the generic divider routine, which results in incorrect round rate.

Fixes: 7681f64e6404 ("clk: clocking-wizard: calculate dividers fractional parts")
Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
Link: https://lore.kernel.org/r/20250625054114.28273-1-shubhrajyoti.datta@amd.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/xilinx/clk-xlnx-clock-wizard.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/xilinx/clk-xlnx-clock-wizard.c b/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
index bbf7714480e7..0295a13a811c 100644
--- a/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
+++ b/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
@@ -669,7 +669,7 @@ static long clk_wzrd_ver_round_rate_all(struct clk_hw *hw, unsigned long rate,
 	u32 m, d, o, div, f;
 	int err;
 
-	err = clk_wzrd_get_divisors(hw, rate, *prate);
+	err = clk_wzrd_get_divisors_ver(hw, rate, *prate);
 	if (err)
 		return err;
 
-- 
2.39.5



