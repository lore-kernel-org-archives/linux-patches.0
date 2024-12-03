Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE481E3DCF;
	Tue,  3 Dec 2024 16:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242268; cv=none; b=BSUc/IJtMojIOc73HUu9F/vJ4B/3ARpN8U59qXs3XQj1XJ5CELERZowWB6Xml9dhF9SMDW1KV6bekUd0IQScK5vCNeHdz/0u0Zc5hZhfAxQdg2jSFmuYsYfdtuFAwAMwX+qV7LrE2VnXmO34ME0s77S7KdFQalq9DDx6jhCei/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242268; c=relaxed/simple;
	bh=g7MdBUNWTis2ylcbgYVuYoiUyTvcgwKzusGeXZ5vMY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nRT9slzttnw4HAahR7EzV+U7M3FLO/l8T3j2tFNPMjzKIdHSu0FjVTTKCJUMeFstVoiiMDS2lKZmOOk6vWcpjtc0VGzykhsr/ZKDAXdBoXsqIl7OWC5ClumIYBFRFe0STT3VANwEW9DGVRyu1cbvdS+gPckxhzz60W96cOJK3u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMl4mpy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMl4mpy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB63C4CECF;
	Tue,  3 Dec 2024 16:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242268;
	bh=g7MdBUNWTis2ylcbgYVuYoiUyTvcgwKzusGeXZ5vMY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eMl4mpy8XkzGhulkB904q506I5xaimGslH9fHA/lgFMuZ4flBll7j3HgKCrjBUMqD
	 BE1XUa6w6gFx4dq5k3AIySRrO3ueAJ6oCrgjpAmIOuorOOT+ZjqX1nD7n3iWWGaRI7
	 W1wuejT/90XC7ZKVRHEVe2NeNvLWLcNkTj6/d2u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.12 657/826] clk: clk-loongson2: Fix potential buffer overflow in flexible-array member access
Date: Tue,  3 Dec 2024 15:46:24 +0100
Message-ID: <20241203144809.382563309@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/clk/clk-loongson2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/clk-loongson2.c
+++ b/drivers/clk/clk-loongson2.c
@@ -306,7 +306,7 @@ static int loongson2_clk_probe(struct pl
 		return PTR_ERR(clp->base);
 
 	spin_lock_init(&clp->clk_lock);
-	clp->clk_data.num = clks_num + 1;
+	clp->clk_data.num = clks_num;
 	clp->dev = dev;
 
 	for (i = 0; i < clks_num; i++) {


