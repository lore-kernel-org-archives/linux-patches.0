Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B2A1F7572;
	Tue,  3 Dec 2024 15:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239568; cv=none; b=kmqfKO49FkRdaAU6YggU7yZWGCURX6NcgotFN99hlRPG+1dRonl0nx9nk5S/zq6Kw2dkrvMNcOXCAtwaUe8AhHZ81s/nOQ+GGEyjnVHbgzTOpodYXZhw1dPK2WtO1y9XvsCAVeRmI7FV5DBNxF9FQECcMUcwMv93YKsWi/s8M8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239568; c=relaxed/simple;
	bh=+ESj6aPuYh9rv41ZrO9OuFIKeOERoCV4VBSB7+VoO2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNOMTPyUL4lH2S6Q7yP2XJbDLBYdQrEWg+RQv4P14l0Ut/AvcBvt+7E8wFFvQ06cvAlaZyo8yNLRKy5vZsQQnJ/oVglqr6DhtiZHVkmNLrf3KW7Li0CcOY4qtKNMoGyLW+pDxKGSbrKYsSVlnEgdqGfo2iKMGhsWMDCk32bv7iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5jqUU9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5jqUU9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE66DC4CECF;
	Tue,  3 Dec 2024 15:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239568;
	bh=+ESj6aPuYh9rv41ZrO9OuFIKeOERoCV4VBSB7+VoO2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5jqUU9e/JPa3gx72uPG3xadQVTDs1q5DKlCvls8bbAnlL1ZyxgsbKn/WUZYzqzOt
	 Nkcmib5eZjQ8zY6pHD+CtcJEMHFzK4/paWFFaPLGoWhQJxnWS/8ks1xXYVqU91nwG1
	 SnxipasPyOjSR4I8WXW+4CA3iERRESr2AJH+5KMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.11 659/817] clk: clk-loongson2: Fix potential buffer overflow in flexible-array member access
Date: Tue,  3 Dec 2024 15:43:51 +0100
Message-ID: <20241203144021.681481811@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo A. R. Silva <gustavoars@kernel.org>

commit 02fb4f0084331ef72c28d0c70fcb15d1bea369ec upstream.

Flexible-array member `hws` in `struct clk_hw_onecell_data` is annotated
with the `counted_by()` attribute. This means that when memory is
allocated for this array, the _counter_, which in this case is member
`num` in the flexible structure, should be set to the maximum number of
elements the flexible array can contain, or fewer.

In this case, the total number of elements for the flexible array is
determined by variable `clks_num` when allocating heap space via
`devm_kzalloc()`, as shown below:

289         struct loongson2_clk_provider *clp;
	...
296         for (p = data; p->name; p++)
297                 clks_num++;
298
299         clp = devm_kzalloc(dev, struct_size(clp, clk_data.hws, clks_num),
300                            GFP_KERNEL);

So, `clp->clk_data.num` should be set to `clks_num` or less, and not
exceed `clks_num`, as is currently the case. Otherwise, if data is
written into `clp->clk_data.hws[clks_num]`, the instrumentation
provided by the compiler won't detect the overflow, leading to a
memory corruption bug at runtime.

Fix this issue by setting `clp->clk_data.num` to `clks_num`.

Fixes: 9796ec0bd04b ("clk: clk-loongson2: Refactor driver for adding new platforms")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/ZzaN5MpmMr0hwHw9@kspp
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/clk-loongson2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-loongson2.c b/drivers/clk/clk-loongson2.c
index e99ba79feec6..7082b4309c6f 100644
--- a/drivers/clk/clk-loongson2.c
+++ b/drivers/clk/clk-loongson2.c
@@ -306,7 +306,7 @@ static int loongson2_clk_probe(struct platform_device *pdev)
 		return PTR_ERR(clp->base);
 
 	spin_lock_init(&clp->clk_lock);
-	clp->clk_data.num = clks_num + 1;
+	clp->clk_data.num = clks_num;
 	clp->dev = dev;
 
 	for (i = 0; i < clks_num; i++) {
-- 
2.47.1



