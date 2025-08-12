Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DDF260583;
	Tue, 12 Aug 2025 19:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026087; cv=none; b=pOwCfgbVe+jIjFo5huP3egxLJwKe0tdH64SdWN55A9HuU7aIvfoj90uMU821aPTiHh3LuDBf2WOJxnL83yk/Tb7JVqihVdhw2UH1FTkQ4E4vlA1ufM3RIwSOlC0URt5tfN3tG6IhXAiDucvVlZPF1eqUGy5Vc7W+QMkTZh9JGIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026087; c=relaxed/simple;
	bh=88CHSiOUisG1uuWUcDfroIuK54PIz4afGaqqIt6E6RY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8na4Eh+ZXfXT2mLkMqi3paUAIFwq2Jrrx+iD9hfpLhcFZ18NhFZLqewlrF2pxqFP5vQF0P8hygqf/0zFDEBxs+l5xgPpYeXYzfcrKRWdi1PQ6i2u/qvx1HnZed87A0djMSgpgDzg0AY724DrTSsrqUZCISqeWCz/TMxm2Hr0os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5WKBRY/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5WKBRY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D24DC4CEF0;
	Tue, 12 Aug 2025 19:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026086;
	bh=88CHSiOUisG1uuWUcDfroIuK54PIz4afGaqqIt6E6RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s5WKBRY/r8wWMb605C75KYIZTCfD0tddJ1HPCvDF4VrBHaU8U+s0FeeUFAGR2Q0E8
	 48vJrxcrlJEf1ZiX3RS4MXq8aPtqHMpJqP1u7U4qw537uUbtKVhmuEtDL1j8gRLNyv
	 6+14tsUunz7z/HlAJFvojJS/oC2fpU/kcDEAXqW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	David Lechner <david@lechnology.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 233/480] clk: davinci: Add NULL check in davinci_lpsc_clk_register()
Date: Tue, 12 Aug 2025 19:47:21 +0200
Message-ID: <20250812174407.054522750@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index b48322176c21..f3ee9397bb0c 100644
--- a/drivers/clk/davinci/psc.c
+++ b/drivers/clk/davinci/psc.c
@@ -277,6 +277,11 @@ davinci_lpsc_clk_register(struct device *dev, const char *name,
 
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



