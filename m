Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5B51F37D4;
	Fri, 31 Oct 2025 14:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919597; cv=none; b=espnc59DoFKX380GziLI/bMKX96n2hM3M4c/HPF//Zl3L0SDQfcwZfWE/b7M3zgvDWe0VX+cLshUv5dBfPQ8OE+PRmUWKM4Ibaj0O9iUvBIigA27cNE45n/8RbnVaNgBVEciFoHd4rAUfN0hAvfKV/9q84BH4Z6Xzfe9Qj6qXhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919597; c=relaxed/simple;
	bh=ViM5kREDR5KgLONr7f6Ti1Es6AcD81cNYLuN9qL0K4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOI8jwIOl1PpVS91aOb5O86piWkjVBJiShJBDJtMjLD7op3uztJAt8xdVFnNx4/xYfjc01LOIlMYNn/5YvShJnThnBqmeaOlP75pRT2LpN7ftl1IE15MDdnItaP/CvgzG1BE9EoSbvI0bR/8WHj2DBtAyT/KwtjZfHwUtYF2IUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/BjKOA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/BjKOA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CCDC4CEE7;
	Fri, 31 Oct 2025 14:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919596;
	bh=ViM5kREDR5KgLONr7f6Ti1Es6AcD81cNYLuN9qL0K4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/BjKOA+zVyu8jfMvmJfKI9SshqtEZTfmpyvYKwgmcntIfYGaZ/e2gF3UzalDxrzb
	 YPJgdu5ayU18Vbm7sTb1Ve72ITJPkLZDQ1ahaG2lcaAdyBqLlaguWh3vuCIiVxN3X9
	 qbaWZjUh1csrvALp6ln1uxB93o4AOh6gb348tz9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haofeng Li <lihaofeng@kylinos.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 04/35] timekeeping: Fix aux clocks sysfs initialization loop bound
Date: Fri, 31 Oct 2025 15:01:12 +0100
Message-ID: <20251031140043.669504040@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haofeng Li <lihaofeng@kylinos.cn>

[ Upstream commit 39a9ed0fb6dac58547afdf9b6cb032d326a3698f ]

The loop in tk_aux_sysfs_init() uses `i <= MAX_AUX_CLOCKS` as the
termination condition, which results in 9 iterations (i=0 to 8) when
MAX_AUX_CLOCKS is defined as 8. However, the kernel is designed to support
only up to 8 auxiliary clocks.

This off-by-one error causes the creation of a 9th sysfs entry that exceeds
the intended auxiliary clock range.

Fix the loop bound to use `i < MAX_AUX_CLOCKS` to ensure exactly 8
auxiliary clock entries are created, matching the design specification.

Fixes: 7b95663a3d96 ("timekeeping: Provide interface to control auxiliary clocks")
Signed-off-by: Haofeng Li <lihaofeng@kylinos.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://patch.msgid.link/tencent_2376993D9FC06A3616A4F981B3DE1C599607@qq.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timekeeping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index b6974fce800cd..3a4d3b2e3f740 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -3070,7 +3070,7 @@ static int __init tk_aux_sysfs_init(void)
 		return -ENOMEM;
 	}
 
-	for (int i = 0; i <= MAX_AUX_CLOCKS; i++) {
+	for (int i = 0; i < MAX_AUX_CLOCKS; i++) {
 		char id[2] = { [0] = '0' + i, };
 		struct kobject *clk = kobject_create_and_add(id, auxo);
 
-- 
2.51.0



