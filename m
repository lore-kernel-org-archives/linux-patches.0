Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436B678C9C;
	Sat, 12 Sep 2026 14:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224003; cv=none; b=hIgI5r3bKFNf2ZMb643ysrVqtTLkxAQ3Dhoxh+7l28i8TqAot9auFhq00w3gOZjlN6UpBc7ipUcPHsXRTEylJ1UsO4KPS9Wkv67QxfCurIEL2ezqOAB6H5XlTNQv9XQyHBc6jPYN3/JweKGdzDnJduWr3ClGbv19JSOXEW48sOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224003; c=relaxed/simple;
	bh=DjflaX705WkkUnch60vH7PuL6lwlD98v9U5f7JtSZso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgCANVLtw/LvUAY80m6SkHEgWOvMCa+SLYqzRgbqtV1QJAZAP0jF3/wYxN2ETW8xAopnU5e+ybc+IPcwyzhgSaPB5N40bnC+CrB0CL5b0EnUhEVq064atZFRzso5KiFUKTF0ziWBCulIuKysgiKGt1egDmJ/+X0JiNn9Ko8W25Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BlyXznJ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BlyXznJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0231F000FF;
	Sat, 12 Sep 2026 14:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224002;
	bh=OgmExvL3ccXPBwnj9Lipb6GVGVWN0jOlyTA+cspCq6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BlyXznJ3vrsbKdg5KRZqSoAlLHePOJi4fBnEO6xUU1rIUzNELFZimtGtA1pu+ft7q
	 cdkLVn0xAfFiJOtJEnBDIAdYQDMw/ntUE4iZvDzid+Jkg3NJ9o+puR1hHGur1v7lqT
	 JFhrinPEsaBlQZnp6F3iI9d4buLXILmvOBAixfzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	longlong yan <yanlonglong@kylinos.cn>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0902/1424] clk/x86: pmc_atom: add kasprintf return value check
Date: Sat, 12 Sep 2026 08:55:34 +0200
Message-ID: <20260912065627.525451135@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2974dd0ec6f4d..4dc6aa202701e 100644
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



