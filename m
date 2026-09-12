Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247F431F9B1;
	Sat, 12 Sep 2026 16:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230304; cv=none; b=pLnBYMzUG0UJTIM7swPuQxpr1pN71C/CBPRCqHvvuc5h5VIV611D2ldgxIBj7WjGVHnGDdH3276k45W1SlVNBcwwnvMm+qx7wsUYyD3Bj5AzuXgRGYH2bz1GOBYZ79aSpcFUCeQGpKrlNGqjuE0d7aXN+LEtp9Tfd8IhqlzBfuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230304; c=relaxed/simple;
	bh=JnKVhSfeT7vL+VHSEBkty7eB9KFehLdhuyojUb99Rgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYn80086nCE3t+FnlSPG5vR3L7MsVkRTIkf0ppZ0fzE0T+cmj6uGodUWidraYNNEKw4RJsdDLHJ8VZZ+bJdDyqkT5Mn4P+TODjwziXX0lLcEHZltrjQ9wv9UIKIG35lE7Aaf5x+3CeNFPuk6PIf+euLTEv6dRIpVGzJ1Xx9SWjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PIvOjydL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PIvOjydL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BFE1F000FF;
	Sat, 12 Sep 2026 16:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230303;
	bh=PWVknSKF1p61KdZwdx16bb1lpZXuMxG6jXRr3fNaFWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PIvOjydLJ532Au0hSLIag/otJevhJ8xdEGjlkIKRipWt26B4UK7mYqy1fWQc2kYCP
	 rLVkcx3R06nfbVSgYCiAqG8Vst5emvgpzjAxQL3RCUIruWsuq/AY4ubNgSqhpN98Nb
	 aD33ORmTqKrbNJNsGP/nzVmOoVwBNsLEvb82hoq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	longlong yan <yanlonglong@kylinos.cn>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0739/1191] clk/x86: pmc_atom: add kasprintf return value check
Date: Sat, 12 Sep 2026 08:57:47 +0200
Message-ID: <20260912065604.880741660@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



