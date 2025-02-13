Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE39281369;
	Thu, 13 Feb 2025 14:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457658; cv=none; b=RxcPpcm6297+LxF2Z65nfKfc5qVkbZJY8zu78paJUPzZBTO3SVcWCDjrmqA2+2xlBDEXXyM/nMhn3nip4p4pDLGmmvD12eJAkC2UUFLQfO0+aakA1Mz0LDejZ+TExkMHwfIEvgF5Ta7UHyLlEuRx3Ixl0rRfjPPSStLIoUDfPy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457658; c=relaxed/simple;
	bh=LvcFbHxjOvAkOm+JB/U76g/WL4t9mVoD2A08vYd/oZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCt8A0wqQJN7ebkYN5nblEvZ2jw1khvxshDiDZ8n4J5fFzjnRy9spHwp+5l7gxbu0GMdUBEyGXUWoIxR5HAyzStYSiNdutLOZkbZc2I8PQirI4mQ1GPD3f+KqiKMFK8t1GBugnahrdhjJS3C3mdHYLYWBM9MDhO7g0eaQMFkBcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fN7gs8Kl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fN7gs8Kl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDF6C4CED1;
	Thu, 13 Feb 2025 14:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457657;
	bh=LvcFbHxjOvAkOm+JB/U76g/WL4t9mVoD2A08vYd/oZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fN7gs8KlYhsDBpOJ4+NE+SiYZwFDUsb9fL859qgD5EjMcbiiTGbdG7IaLtvViUbIO
	 TVj8QIwN1fMIVTdu097a3/UDwsEP8Nj/xODjYrrCU59ZleJWEuZ9BJDG4gQvGmuaHM
	 RlBz/Z5H/fjcdhMeyiN1JXicJX6GhILEGiA7ubZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.12 176/422] clk: clk-loongson2: Fix the number count of clk provider
Date: Thu, 13 Feb 2025 15:25:25 +0100
Message-ID: <20250213142443.336124499@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Binbin Zhou <zhoubinbin@loongson.cn>

commit 5fb33b6797633ce60908d13dc06c54a101621845 upstream.

Since commit 02fb4f008433 ("clk: clk-loongson2: Fix potential buffer
overflow in flexible-array member access"), the clk provider register is
failed.

The count of `clks_num` is shown below:

	for (p = data; p->name; p++)
		clks_num++;

In fact, `clks_num` represents the number of SoC clocks and should be
expressed as the maximum value of the clock binding id in use (p->id + 1).

Now we fix it to avoid the following error when trying to register a clk
provider:

[ 13.409595] of_clk_hw_onecell_get: invalid index 17

Cc: stable@vger.kernel.org
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Fixes: 02fb4f008433 ("clk: clk-loongson2: Fix potential buffer overflow in flexible-array member access")
Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Link: https://lore.kernel.org/r/82e43d89a9a6791129cf8ea14f4eeb666cd87be4.1736856470.git.zhoubinbin@loongson.cn
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/clk-loongson2.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk-loongson2.c b/drivers/clk/clk-loongson2.c
index 7082b4309c6f..0d9485e83938 100644
--- a/drivers/clk/clk-loongson2.c
+++ b/drivers/clk/clk-loongson2.c
@@ -294,7 +294,7 @@ static int loongson2_clk_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	for (p = data; p->name; p++)
-		clks_num++;
+		clks_num = max(clks_num, p->id + 1);
 
 	clp = devm_kzalloc(dev, struct_size(clp, clk_data.hws, clks_num),
 			   GFP_KERNEL);
@@ -309,6 +309,9 @@ static int loongson2_clk_probe(struct platform_device *pdev)
 	clp->clk_data.num = clks_num;
 	clp->dev = dev;
 
+	/* Avoid returning NULL for unused id */
+	memset_p((void **)clp->clk_data.hws, ERR_PTR(-ENOENT), clks_num);
+
 	for (i = 0; i < clks_num; i++) {
 		p = &data[i];
 		switch (p->type) {
-- 
2.48.1



