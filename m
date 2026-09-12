Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D53DCA6F;
	Sat, 12 Sep 2026 10:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208439; cv=none; b=SmRRED+RCSBeXEwSjdp2Py/xlQk1ioNbKS5ztC306W9PtvnvewW3pVwXfHilfDaPK/HMVI1oHL9T5pT3WM7ms6l7/XyGCknioGQkKI1UxDy9zdlBOthFmeTwULSQq2aFkEAbnzFfDFxo+DR5peFttbOwBU5XC5wuHlo/4iJWs58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208439; c=relaxed/simple;
	bh=KlIaVSlTMfJ2onv76KwUe3190wr6m70HplZUjAKT/mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BgTd2y+g2U2+QrQLcegwSosMpP7YuL+Rl09qjkjNP543+oUHoFFUwT6WwcJHZQ5zTzPGCS3OWPq8e3QAaQBNHY51Vl107k8URpVQoK0OpHY+j/P9Mc2y63FXVoB7sTJY2GpobSvCZnGvoFI5Xi0tIGZZo8mzkMui/LB9DlK2Oao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFx66Vao; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFx66Vao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41AB1F000FF;
	Sat, 12 Sep 2026 10:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208437;
	bh=KvVC/w3iEySuzICZHKIDv2p1T9wkdHFnDlBniw342zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bFx66VaoFjJf/kqiQaBidPNdz8XYVOuZMHCwzGTlQ4s9FXSRcCfAStA4KnLOEqW/d
	 oHIVjviHPDL34rNbJ8doyHlLbH+qpDbXhHaAJTu/fSQfSiHClC8+xs6ipeIsllg9Fy
	 6sYFaTObyELIzmGHENu7Ax3aEvmt66beEpBr/gOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	longlong yan <yanlonglong@kylinos.cn>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0617/1518] clk/x86: pmc_atom: add kasprintf return value check
Date: Sat, 12 Sep 2026 08:46:26 +0200
Message-ID: <20260912065637.385852380@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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



