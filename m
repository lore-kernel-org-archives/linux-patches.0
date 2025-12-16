Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3EC28314B;
	Tue, 16 Dec 2025 12:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887953; cv=none; b=B5ftQgdDCxUmODZiLnAxeAc5LCNRkAEzeeVnlQxmmxNJyo+j4TmeghJhHTmbPljl5PPsnPB5avP94UI1hhNTp4JbX5f9Fa9ZH9ibNgcRheO5tV0TpaEX92quGC5R3qQpgIsITQVhjtNc5HQ8lZjtqPvqE6oJlCTH9fmIsfgwPuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887953; c=relaxed/simple;
	bh=8TunygGGhgSDxUWNuieu7JzgID/5NHlfWUnMbRyUssA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kv2xdiGY9FBna8TCBdBNbFL0UaL3Qbdn6i24HfAqlNWx5NJdKP+mlWCpv1blsFPkYRVlYJwu27oCFyshOH6A0+Rb5b6BuvOeY9tvA2ckKQiG/YU8zQTeGDhX8MOu/KGXWmQ0m+kRQ8Zk8Q6isK3siYTZ3rN/PdcXZb9qLaGIdPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bqqs1B89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bqqs1B89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A59C4CEF1;
	Tue, 16 Dec 2025 12:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887952;
	bh=8TunygGGhgSDxUWNuieu7JzgID/5NHlfWUnMbRyUssA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bqqs1B89sciiXjEPRbPKiXj0hDMOmrgWayREgYO/6J9WQ3jrlT00rMq6WKiCdoa0p
	 z/H3O3R5ibdQqYwYfXtVu8VmmR+OBix7eVdlMSBSI0MicVKiBr4KjmkTsaOQh/+l18
	 xAQRkfLK5o0+NBeiIjIzTaxaOFdW8gsI2RPg/AyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanko Kaneti <yaneti@declera.com>,
	Charles Mirabile <cmirabil@redhat.com>,
	Alex Elder <elder@riscstar.com>,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>,
	Yixun Lan <dlan@gentoo.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 355/614] clk: spacemit: Set clk_hw_onecell_data::num before using flex array
Date: Tue, 16 Dec 2025 12:12:02 +0100
Message-ID: <20251216111414.223898451@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Mirabile <cmirabil@redhat.com>

[ Upstream commit 23b2d2fb136959fd0a8e309c70be83d9b8841c7e ]

When booting with KASAN enabled the following splat is
encountered during probe of the k1 clock driver:

UBSAN: array-index-out-of-bounds in drivers/clk/spacemit/ccu-k1.c:1044:16
index 0 is out of range for type 'clk_hw *[*]'
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.18.0-rc5+ #1 PREEMPT(lazy)
Hardware name: Unknown Unknown Product/Unknown Product, BIOS 2022.10spacemit 10/01/2022
Call Trace:
[<ffffffff8002b628>] dump_backtrace+0x28/0x38
[<ffffffff800027d2>] show_stack+0x3a/0x50
[<ffffffff800220c2>] dump_stack_lvl+0x5a/0x80
[<ffffffff80022100>] dump_stack+0x18/0x20
[<ffffffff800164b8>] ubsan_epilogue+0x10/0x48
[<ffffffff8099034e>] __ubsan_handle_out_of_bounds+0xa6/0xa8
[<ffffffff80acbfa6>] k1_ccu_probe+0x37e/0x420
[<ffffffff80b79e6e>] platform_probe+0x56/0x98
[<ffffffff80b76a7e>] really_probe+0x9e/0x350
[<ffffffff80b76db0>] __driver_probe_device+0x80/0x138
[<ffffffff80b76f52>] driver_probe_device+0x3a/0xd0
[<ffffffff80b771c4>] __driver_attach+0xac/0x1b8
[<ffffffff80b742fc>] bus_for_each_dev+0x6c/0xc8
[<ffffffff80b76296>] driver_attach+0x26/0x38
[<ffffffff80b759ae>] bus_add_driver+0x13e/0x268
[<ffffffff80b7836a>] driver_register+0x52/0x100
[<ffffffff80b79a78>] __platform_driver_register+0x28/0x38
[<ffffffff814585da>] k1_ccu_driver_init+0x22/0x38
[<ffffffff80023a8a>] do_one_initcall+0x62/0x2a0
[<ffffffff81401c60>] do_initcalls+0x170/0x1a8
[<ffffffff81401e7a>] kernel_init_freeable+0x16a/0x1e0
[<ffffffff811f7534>] kernel_init+0x2c/0x180
[<ffffffff80025f56>] ret_from_fork_kernel+0x16/0x1d8
[<ffffffff81205336>] ret_from_fork_kernel_asm+0x16/0x18
---[ end trace ]---

This is bogus and is simply a result of KASAN consulting the
`.num` member of the struct for bounds information (as it should
due to `__counted_by`) and finding 0 set by kzalloc() because it
has not been initialized before the loop that fills in the array.
The easy fix is to just move the line that sets `num` to before
the loop that fills the array so that KASAN has the information
it needs to accurately conclude that the access is valid.

Fixes: 1b72c59db0add ("clk: spacemit: Add clock support for SpacemiT K1 SoC")
Tested-by: Yanko Kaneti <yaneti@declera.com>
Signed-off-by: Charles Mirabile <cmirabil@redhat.com>
Reviewed-by: Alex Elder <elder@riscstar.com>
Reviewed-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>
Reviewed-by: Yixun Lan <dlan@gentoo.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/spacemit/ccu-k1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/spacemit/ccu-k1.c b/drivers/clk/spacemit/ccu-k1.c
index f5a9fe6ba1859..4761bc1e3b6e6 100644
--- a/drivers/clk/spacemit/ccu-k1.c
+++ b/drivers/clk/spacemit/ccu-k1.c
@@ -1018,6 +1018,8 @@ static int spacemit_ccu_register(struct device *dev,
 	if (!clk_data)
 		return -ENOMEM;
 
+	clk_data->num = data->num;
+
 	for (i = 0; i < data->num; i++) {
 		struct clk_hw *hw = data->hws[i];
 		struct ccu_common *common;
@@ -1044,8 +1046,6 @@ static int spacemit_ccu_register(struct device *dev,
 		clk_data->hws[i] = hw;
 	}
 
-	clk_data->num = data->num;
-
 	ret = devm_of_clk_add_hw_provider(dev, of_clk_hw_onecell_get, clk_data);
 	if (ret)
 		dev_err(dev, "failed to add clock hardware provider (%d)\n", ret);
-- 
2.51.0



