Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C704538F656;
	Sat, 12 Sep 2026 19:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242888; cv=none; b=aukj85OgwqNjnvCehZ7V/MW8vkq5pftarxOONvK0h6vwSLbEclB223upelLcKcH4QvaO7Twzk4KmA8+JgzHj0Q3LZ1wpHkuG+58gpH2Pe+dQePHQTQcvdgj5BKgLpmTWyvJCqEi3lYkkCQXL15WnzxDExFeOryBsek/SfaL8Dpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242888; c=relaxed/simple;
	bh=3rkwUW/gBF2N5SlTJhBEJ3ow6aYNasq/MzXwLZvpLXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAp5w25npO3utjPBPAckaJmv96hTYLG+WKr8j6esFJWwLraQDyZj2xgi7g/HEcrZ0y2S7+/5rWh6IIDnkAZC9s/qvkM0Wa7yJkNdoJ11vYR4xIS89xcoEvVo14EtR4tDWAhymzU1LrFLBbuqVTIU7SEZiWVc5egDdsw0a3U/n2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8Mre9aW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8Mre9aW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0301F000FF;
	Sat, 12 Sep 2026 19:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242887;
	bh=DNvnxRu16q0H9lLTZ5+Rx5JA3cM5ROcCtrV/Mla1rD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l8Mre9aWT4E4ZLtAzViasbQUCz9/IFPwRrYbf0h/ZmqsRbrdo4P8JrGnK6HVrZijo
	 HO51pdVtTqJ2MVufKKU3C18+kVtmo/j5cUdP7Lp0C0L8aSvNe/Z15bCTw6IMoyocMr
	 UWRhG3CT6soEf+KoeBMg9QeCkRglbxqcZvVMyZlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	longlong yan <yanlonglong@kylinos.cn>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 531/798] clk/x86: pmc_atom: add kasprintf return value check
Date: Sat, 12 Sep 2026 09:02:39 +0200
Message-ID: <20260912065529.303276584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: longlong yan <yanlonglong@kylinos.cn>

[ Upstream commit 18e9d14cbac33db1c1fb933c26a736eef53dd538 ]

The kasprintf() function returns NULL on memory allocation failure, but
the code in plt_clk_register() was not checking this return value. If
kasprintf fails, init.name would be NULL and could cause NULL pointer
dereference when clkdev_hw_create() uses it.

Add proper error checking for the kasprintf() return value and return
ERR_PTR(-ENOMEM) on failure.

Fixes: 1141d9d08184 ("clk: x86: Add Atom PMC platform clocks")
Signed-off-by: longlong yan <yanlonglong@kylinos.cn>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/x86/clk-pmc-atom.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/x86/clk-pmc-atom.c b/drivers/clk/x86/clk-pmc-atom.c
index e746e3f8d05a9..00e8f24ff1329 100644
--- a/drivers/clk/x86/clk-pmc-atom.c
+++ b/drivers/clk/x86/clk-pmc-atom.c
@@ -171,6 +171,9 @@ static struct clk_plt *plt_clk_register(struct platform_device *pdev, int id,
 		return ERR_PTR(-ENOMEM);
 
 	init.name =  kasprintf(GFP_KERNEL, "%s_%d", PLT_CLK_NAME_BASE, id);
+	if (!init.name)
+		return ERR_PTR(-ENOMEM);
+
 	init.ops = &plt_clk_ops;
 	init.flags = 0;
 	init.parent_names = parent_names;
-- 
2.53.0



