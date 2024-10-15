Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202651EABBD;
	Tue, 15 Oct 2024 11:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992865; cv=none; b=P7mQKXqbZBuYA6mfKB6TwdbPC3HkaBcMLlkXzoFlOELnM1uMOZcI6gKaUzkfgw5JXHF0z3969Kdo2z3bgP0dKvTXU5xMNGvgBiwb+zoNOLPQ7YvapYaDJZYYnSSYF/7JXq9shywM8sL1nOI7qAROm8TSj1pbbW0WL0ZRZaSr8SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992865; c=relaxed/simple;
	bh=zF/xQ2wo83liMjfjVrj62I47GanvbqY2ue8uZ0X9mVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPsTXAMufqsidg+wTa3Hq4l4xvsR6Q2soNAPokPCmbgPddmiRjIJTf8XSr2v2St3fjBGq+4dx36F04cl5i3UDjnkHL1nOiyxLuZVMz3O1FCrqrjgkujUWwwoyW5kkICjJjk2lrMdf3DrRg8OvGyp8Q+4haqi5dMK/NVXzgi67xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYu9I2k1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYu9I2k1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D378C4CECF;
	Tue, 15 Oct 2024 11:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992865;
	bh=zF/xQ2wo83liMjfjVrj62I47GanvbqY2ue8uZ0X9mVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYu9I2k1qNwWyVOgFQue2S+4t4NH7Jfpbf2AAV+NTA8ptoUocae7qRN5vuMGBMOmr
	 Fho3hWiIUdOZsXEEGxbeX9Kulx5v9uTRTvoR0y3862qY7UW112/SD3nkS7F5WAWivU
	 xOoX7Ndd1VnELkWLDKG8W6GrwVV0cpa6Y2v4f3CM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 240/691] clk: ti: dra7-atl: Fix leak of of_nodes
Date: Tue, 15 Oct 2024 13:23:08 +0200
Message-ID: <20241015112449.882053645@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 9d6e9f10e2e031fb7bfb3030a7d1afc561a28fea ]

This fix leaking the of_node references in of_dra7_atl_clk_probe().

The docs for of_parse_phandle_with_args() say that the caller must call
of_node_put() on the returned node. This adds the missing of_node_put()
to fix the leak.

Fixes: 9ac33b0ce81f ("CLK: TI: Driver for DRA7 ATL (Audio Tracking Logic)")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://lore.kernel.org/r/20240826-clk-fix-leak-v1-1-f55418a13aa6@baylibre.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clk-dra7-atl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/ti/clk-dra7-atl.c b/drivers/clk/ti/clk-dra7-atl.c
index 62508e74a47a7..fc266c0ab6293 100644
--- a/drivers/clk/ti/clk-dra7-atl.c
+++ b/drivers/clk/ti/clk-dra7-atl.c
@@ -258,6 +258,7 @@ static int of_dra7_atl_clk_probe(struct platform_device *pdev)
 		}
 
 		clk = of_clk_get_from_provider(&clkspec);
+		of_node_put(clkspec.np);
 		if (IS_ERR(clk)) {
 			pr_err("%s: failed to get atl clock %d from provider\n",
 			       __func__, i);
-- 
2.43.0



