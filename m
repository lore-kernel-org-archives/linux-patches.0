Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2188C216E1B;
	Tue, 26 Aug 2025 13:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215792; cv=none; b=m7SS5KG1qVeSIGqsPbqoXgZ7EGs5A7BAJrOHVNXqB2QXjCpisVnZujOHd7pnbMB3rrea3CEqV2l8iLg4DT+2uLXAHMLJZDlydxc/YnIi+u/UGgwo7sx2SERwzSB4HU58dopT1ksEIQv+OqlmmaMC3V5S/bTBwYf8x+7ExyTaXRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215792; c=relaxed/simple;
	bh=EZ847dgxMCDqulMLDlwipiy0k6QZ3szBTbLb62fl1lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHLNJHzqAjAGMDV0cMWW9FYzThEj0BVpjIbZX/MVXTHjTqx/+Napxu8DMgkXNeg73A09vURt4Ov67P7bR0TU+vonWxg9UL8K/1mjnr7dtmZqkdEmTgC1R05IJEqCSiQxTKuDLTLOK9bi/rRPTPXtV4OfMkm7k0KdH3vS45b0ZDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+8RCsKx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+8RCsKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DD7C4CEF1;
	Tue, 26 Aug 2025 13:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215791;
	bh=EZ847dgxMCDqulMLDlwipiy0k6QZ3szBTbLb62fl1lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+8RCsKx3/SGwvmpkN6w13p6jOnYV/5nQrrnM+pGeqhUzeydy7XsQYxsPkkLiP5cm
	 qIKqTJ7WidjWwlyy7Wa6HG5Ry64/99XuWWk/XpBvno0XdZr/CplD6BDFwuK9M49AuZ
	 mDFGvCkh4a7MljA2W7eN3A1MVHjh8CjjeH65ZIv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	David Lechner <david@lechnology.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 168/644] clk: davinci: Add NULL check in davinci_lpsc_clk_register()
Date: Tue, 26 Aug 2025 13:04:19 +0200
Message-ID: <20250826110950.642743683@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 13de464f445d42738fe18c9a28bab056ba3a290a ]

devm_kasprintf() returns NULL when memory allocation fails. Currently,
davinci_lpsc_clk_register() does not check for this case, which results
in a NULL pointer dereference.

Add NULL check after devm_kasprintf() to prevent this issue and ensuring
no resources are left allocated.

Fixes: c6ed4d734bc7 ("clk: davinci: New driver for davinci PSC clocks")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Link: https://lore.kernel.org/r/20250401131341.26800-1-bsdhenrymartin@gmail.com
Reviewed-by: David Lechner <david@lechnology.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/davinci/psc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/clk/davinci/psc.c b/drivers/clk/davinci/psc.c
index 7387e7f6276e..4e1abfc1e564 100644
--- a/drivers/clk/davinci/psc.c
+++ b/drivers/clk/davinci/psc.c
@@ -278,6 +278,11 @@ davinci_lpsc_clk_register(struct device *dev, const char *name,
 
 	lpsc->pm_domain.name = devm_kasprintf(dev, GFP_KERNEL, "%s: %s",
 					      best_dev_name(dev), name);
+	if (!lpsc->pm_domain.name) {
+		clk_hw_unregister(&lpsc->hw);
+		kfree(lpsc);
+		return ERR_PTR(-ENOMEM);
+	}
 	lpsc->pm_domain.attach_dev = davinci_psc_genpd_attach_dev;
 	lpsc->pm_domain.detach_dev = davinci_psc_genpd_detach_dev;
 	lpsc->pm_domain.flags = GENPD_FLAG_PM_CLK;
-- 
2.39.5



