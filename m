Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053AC26B080;
	Thu, 13 Feb 2025 15:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459200; cv=none; b=I5zvkUPh9Jq1n3eXy0beDvjLaofThnWiJbe+KG1DW0NFeqMlkc5DhFNTJwsLcn1GeIorK5S2qUe5hw9tb3j0KibBjC1lgZhr24o+pH49UA0lxhjYLn0LiQDWby8vt3tVe+k/VITb5Lvblwc/5HF8lHxSyLfOIms8cjkJrosnUe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459200; c=relaxed/simple;
	bh=FAYzh9I45ENeoML7Ac1Y5T1gHBA3J3AF2qQ/5b2byYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baA2A+wEdt/XCQe2LyEHf6r4NasJauTTjlegWSXueRm8XxUSA/YRCy8mFm6OyptOGcmm31ExzYoUpjtflDS2cjvtxPvn/8HQL2JVZZNYNBssOW/crzexi8WkmubspEU6O0v2HQB03PgZt9wuuEPuXDpvF1vWka6Ik/S8Cfa9jv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejuA4Je1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejuA4Je1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B41C4CED1;
	Thu, 13 Feb 2025 15:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459199;
	bh=FAYzh9I45ENeoML7Ac1Y5T1gHBA3J3AF2qQ/5b2byYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ejuA4Je1RQ5wiMFrwpVqzWtvZJR8wdDUE9UzoDB3o+Sm2XGbii+ooDxh+YUJi+fBS
	 IUEyoYNqOppESilZ/ugcysnZb6sOtU9HV1fCyXluSs69VlI2VwJFU7ijYP0Y9q4nmo
	 XBsYcSZOUSYDjtRrk1ju9I4/ouxO+xTIIlE+TNwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.13 196/443] clk: clk-loongson2: Fix the number count of clk provider
Date: Thu, 13 Feb 2025 15:26:01 +0100
Message-ID: <20250213142448.174570772@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/clk/clk-loongson2.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/clk/clk-loongson2.c
+++ b/drivers/clk/clk-loongson2.c
@@ -294,7 +294,7 @@ static int loongson2_clk_probe(struct pl
 		return -EINVAL;
 
 	for (p = data; p->name; p++)
-		clks_num++;
+		clks_num = max(clks_num, p->id + 1);
 
 	clp = devm_kzalloc(dev, struct_size(clp, clk_data.hws, clks_num),
 			   GFP_KERNEL);
@@ -309,6 +309,9 @@ static int loongson2_clk_probe(struct pl
 	clp->clk_data.num = clks_num;
 	clp->dev = dev;
 
+	/* Avoid returning NULL for unused id */
+	memset_p((void **)clp->clk_data.hws, ERR_PTR(-ENOENT), clks_num);
+
 	for (i = 0; i < clks_num; i++) {
 		p = &data[i];
 		switch (p->type) {


