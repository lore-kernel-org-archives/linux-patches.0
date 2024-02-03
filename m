Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE738F9F5;
	Sat,  3 Feb 2024 04:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933413; cv=none; b=IHTQLr7z6BiIaZ0RtDf0X0fpm0oLD3g9hH49cySIPf0/PpgLAq6i9xtUKRxkcvuAz2FQssbrDP0ZL5ebaMteyxh19mphV/2ttTmT17LOOaHp49tZatgSYKSiqQQckc9JydFIFRl5fE5BERpDjFdzyzIwIqbb4yl1M1uCv1UTWQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933413; c=relaxed/simple;
	bh=gWMD0TX1OC4WkRXYHp9ghV+INorfkmNinA1lJq1h2BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfjODABCUa10fLge47sFLOcryfiUdsbmvijcaO72+MkRRATwObZPu3GBvThfnc7UYt0jfb/D57DZrKz7TMjmYVxzj/j+Bbu+rJL3Tf/U6pQMiIm7LIZJrPzf1baz/ajKH+A6HvnrVKEFhaNJVTFICo/ko+IlNczB7lyakaGe6CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kl4ctj3q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kl4ctj3q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C8DC433F1;
	Sat,  3 Feb 2024 04:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933413;
	bh=gWMD0TX1OC4WkRXYHp9ghV+INorfkmNinA1lJq1h2BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kl4ctj3q6DLaTNffAEAPFMe61wwLp4iCrZII3k7cg1qua6w3VZtm3HnSf56WGM6QQ
	 bBsswd0yFH1djWaFp7CUg/lfQC2ErFshxAoN3UYAJT5w9EJVa172GCiXGE+N7KrNyy
	 4vM+ObMJOeUnx0Pv82xZy5u1ClLCt/uIbSjcm6Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/219] clk: hi3620: Fix memory leak in hi3620_mmc_clk_init()
Date: Fri,  2 Feb 2024 20:05:09 -0800
Message-ID: <20240203035336.568489242@linuxfoundation.org>
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

[ Upstream commit bfbea9e5667cfa9552c3d88f023386f017f6c308 ]

In cases where kcalloc() fails for the 'clk_data->clks' allocation, the
code path does not handle the failure gracefully, potentially leading
to a memory leak. This fix ensures proper cleanup by freeing the
allocated memory for 'clk_data' before returning.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Link: https://lore.kernel.org/r/20231210165040.3407545-1-visitorckw@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/hisilicon/clk-hi3620.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/hisilicon/clk-hi3620.c b/drivers/clk/hisilicon/clk-hi3620.c
index a3d04c7c3da8..eb9c139babc3 100644
--- a/drivers/clk/hisilicon/clk-hi3620.c
+++ b/drivers/clk/hisilicon/clk-hi3620.c
@@ -467,8 +467,10 @@ static void __init hi3620_mmc_clk_init(struct device_node *node)
 		return;
 
 	clk_data->clks = kcalloc(num, sizeof(*clk_data->clks), GFP_KERNEL);
-	if (!clk_data->clks)
+	if (!clk_data->clks) {
+		kfree(clk_data);
 		return;
+	}
 
 	for (i = 0; i < num; i++) {
 		struct hisi_mmc_clock *mmc_clk = &hi3620_mmc_clks[i];
-- 
2.43.0



