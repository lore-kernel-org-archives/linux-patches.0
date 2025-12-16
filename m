Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F1956B81;
	Tue, 16 Dec 2025 11:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884516; cv=none; b=nACCJ4tZZxJJC6yal6orUYvOFJUCHsg8OF6sa+D53o+tI5PAJ5+PJ+ma6QcStYrnbqJghVn5VnDfucs8tQNgYyWJcXGInBURWmJfgt7ANfD6WAYa1cwQIQbLxbbAoZJaFLFdurg6jZ25kxCRziGdabaSykV4Tvv+aoIc8gE8/wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884516; c=relaxed/simple;
	bh=IRmOuIRdJ6zf0874unu21phAc1YO6i28V1XJUDcuXPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hp0vyu3uzocaBb+gzEDpm/OLYWk8ALwi+vODB+Pw4PKT0OueNWOUJfzQGAHfMZGvBSOtZFMu4/YQD9DXTeU/Zhci5AprkEOUTEs2SBULhObSBfV3oHTlzU/GYq5LYbY93SZnCmiaM2kEkoKJODdhc3nAcJ9cCojFdXmmxLXOPpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPNNnDdj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPNNnDdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607E8C4CEF1;
	Tue, 16 Dec 2025 11:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884515;
	bh=IRmOuIRdJ6zf0874unu21phAc1YO6i28V1XJUDcuXPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TPNNnDdjDc24aYK7XfreubElzanWr7bctEv3H4xRexvxiDyhd+SCYnzX7bzAmNKAY
	 QX6Ym+QCl8iryUNvCOCn0oJFujmnHGfPaTVqC/ms4iGCT7Z+1t/DL2N2DP9PIbhBKn
	 PiPVJKQZHXp1NEXqJv4FiUcCAizq4bAZCYVGlwkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianglei Nie <niejianglei2021@163.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 218/354] staging: fbtft: core: fix potential memory leak in fbtft_probe_common()
Date: Tue, 16 Dec 2025 12:13:05 +0100
Message-ID: <20251216111328.816979235@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit 47d3949a9b04cbcb0e10abae30c2b53e98706e11 ]

fbtft_probe_common() allocates a memory chunk for "info" with
fbtft_framebuffer_alloc(). When "display->buswidth == 0" is true, the
function returns without releasing the "info", which will lead to a
memory leak.

Fix it by calling fbtft_framebuffer_release() when "display->buswidth
== 0" is true.

Fixes: c296d5f9957c ("staging: fbtft: core support")
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Link: https://patch.msgid.link/20251112192235.2088654-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fbtft/fbtft-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index 8fab5126765d4..69649c0ef8739 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -1170,8 +1170,8 @@ int fbtft_probe_common(struct fbtft_display *display,
 	par->pdev = pdev;
 
 	if (display->buswidth == 0) {
-		dev_err(dev, "buswidth is not set\n");
-		return -EINVAL;
+		ret = dev_err_probe(dev, -EINVAL, "buswidth is not set\n");
+		goto out_release;
 	}
 
 	/* write register functions */
-- 
2.51.0



