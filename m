Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C102FD1B2;
	Tue, 12 Aug 2025 17:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020650; cv=none; b=WIs3SYQFUMO2qxy7421tjrkuZnAk9jWJ0z+WkHwPP7qS6Ui/zsGe3zjrAZ1X07c4+tC4xsRonFI00Q3530lOJNKJtYdb6K9wPwGT+ZvpY2TyOXtopL/B7C/G4HQ753zHMeS7u7nOgAzmJeJBGJlsBNltiE1kpShCc/5WG90kGjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020650; c=relaxed/simple;
	bh=Mfud8kKay1I5pXQeI3CuR/B77/f30/Qf7kfmQgVUJec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZln0ISbLbG2Rxk+H6g0tvxTMoPENX7FlDihIf0nBIxn/m9OvDhh5KNSG2rU783ThagU74bj1CXVXU+GHCyGZY5G0et1X5+AzF6eG0dBODx/pk4EQ4uSEpwY8AmW90vLXceF7Br+USktIuragd7r33cGgPZJN+bzY99ZlcHI1nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ElmjnBH6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ElmjnBH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3628DC4CEF0;
	Tue, 12 Aug 2025 17:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020650;
	bh=Mfud8kKay1I5pXQeI3CuR/B77/f30/Qf7kfmQgVUJec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElmjnBH6VkTlYmtGvUSwobRPIIHc9fSMzk942SvoEIqBLg148Xn15llhaJm0P8l74
	 LtP3knkXfTRA50ACp+omGBwwxiP3IiyugCjbOAz//XmG3xq36o9rcK07xhciq+03Vo
	 QKQw4QNqcdHSJbKsTgBWokin4bPCqIUOnDu5THso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	David Lechner <david@lechnology.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/253] clk: davinci: Add NULL check in davinci_lpsc_clk_register()
Date: Tue, 12 Aug 2025 19:28:51 +0200
Message-ID: <20250812172954.783724900@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 42a59dbd49c8..ecb111be56f7 100644
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



