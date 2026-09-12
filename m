Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3C43A7F47;
	Sat, 12 Sep 2026 18:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239200; cv=none; b=QY23fyAYuqrXdxBStlRcB2/YxLnQFyRziUxXKnBOiSe9Crwk5MTBO08Ozc3i6nMcIuyBNVHmME/bKy8bU10eBjriGgFfcV0AEboR+bz1d40kj0NozeEymCE/iHHXOJestmcTIcuOUjg7kZqvb4qmOzp8z+H/kzppUdUZXc0beyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239200; c=relaxed/simple;
	bh=oEezBGrjfvZs2NTfT+VKERbQPteVYGlD7GmgKWkRW50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNq9fzTYZpzDka8+3CyCI4+ZjGP5NkxdLOqOMy8f/c8Pl7Rcf740n4NSSrNCb6fE4yg8Sw4Cgtm6pzRVRvy+dY9wUzh/bT5gYMD3sHWyTn8KPBUTsHcVeIGJVKfmqAxq4Y81qs/h5GbIY1qquMSUs5V0cnSfHU1LDFjeqdzCvYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9cl/UP2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9cl/UP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0181F000FF;
	Sat, 12 Sep 2026 18:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239199;
	bh=kLFz6Q/rrEzdZcoU3KU91Pmm/6w2r1zPDy/hYN4I7kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E9cl/UP29MSRv8nFnVDdIjXp1DzVE0zlc7pdTR6OeZaFKNwQ5zJOoY6KDNasBuMG6
	 Wb+ubuACSXDgBsrmvbY5Bm9t4BafcQ8GOjJcd6F9L/yXrjqIAVnZ10oUFUVoatXMKa
	 6tBIgZP0c7STKffQjEqpMHxEXfo4QpqgxNPUktSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	longlong yan <yanlonglong@kylinos.cn>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 615/935] clk/x86: pmc_atom: add kasprintf return value check
Date: Sat, 12 Sep 2026 09:00:45 +0200
Message-ID: <20260912065540.945749167@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



