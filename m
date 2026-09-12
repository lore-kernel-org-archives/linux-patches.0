Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E428A242D65;
	Sat, 12 Sep 2026 12:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216338; cv=none; b=RNKDcB97wUyZZl4boZocT+r/37n4M2BmP/C05rFxxQoPwk1GMkOzLSda3o6WBj0v+2DuQmPRWz01wnbTaGL2nNQkFtAYUVEaQVugHgY83l8nEhFETefVcBq+2eftq0heO8ZQYDUgkW2iNp3L8xD7xP/S5fdUNni05WDbhVonSHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216338; c=relaxed/simple;
	bh=gtEffzchd1MzCauAfMz7TJMKDed4CQPGz3hcJezbN+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZYhKSZfH8WdKB0pyHNbZ116/pACe2tw2B0DH61vF3Apzt6wdE9JYgTB9wOZ+iCx4FE49chs8GOapnpMfDrQ6cpgdrmUPCMPTzoFHdPW2hbbrNrrh/kr4gM/zyNe83HKKtgl4CoHsmNHGa6WwHqW7+yWkZANGMji8K0kiZV1TBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ET0WSWGq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ET0WSWGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17931F000FF;
	Sat, 12 Sep 2026 12:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216336;
	bh=0WHlsu3mcA4X9pFKXwAZaDp8BNyIGBtG2f378cD+Mug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ET0WSWGqnaqWEiXc0VMIKfZ7QCfU09/9DVsL3ZfyMfWjTokcZszePFlPmX43n2HBE
	 1Ap+2PXrLqmNNbwdawu7AbhzQI8ue+g30qcviXvBd91enO3x40qH+vbIMWM8xExnHi
	 xZz40lZ0SP+MnuA9KHiPWtEfqKMetcChG144e7LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	longlong yan <yanlonglong@kylinos.cn>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0716/1376] clk/x86: pmc_atom: add kasprintf return value check
Date: Sat, 12 Sep 2026 08:52:22 +0200
Message-ID: <20260912065623.500304361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 99291ba65da73..08c83e0abc41d 100644
--- a/drivers/clk/x86/clk-pmc-atom.c
+++ b/drivers/clk/x86/clk-pmc-atom.c
@@ -160,6 +160,9 @@ static struct clk_plt *plt_clk_register(struct platform_device *pdev, int id,
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



