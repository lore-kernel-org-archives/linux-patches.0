Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EA439B48E;
	Thu, 15 Jan 2026 17:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497667; cv=none; b=aGe23Eyg3EygqtaSMFLj1x14OWXFq1OhOHUBGDm6JZWa9pt2f1Bz90pbTNOJX3DvgpaJzDD6nVRldJTu67D2hVtLUtH6dJPT0ekub88ZrlMe1yRacsGQ9HH+A5d09goKOy8PFXIvLIgmzir4ga6BsKDh6SgJjJSEG71PIguv7CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497667; c=relaxed/simple;
	bh=YhJCnVoObTjvqArUhQlX1PI8LmKVzhYto7jw6jZrQI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htv2F2PzBMxsXfNPf4SINVGSwBgTNXwI7SEod+1wsU+VYAhifWXoiBpO/GR13HHmZgcwLbSOW22nzOZVXtBvG/9iqHKV2uocUcRmlAYoCWa0v7ortOGyxE12eKxUiPtZRBy5WhYBWv63QsCKcnDQBm1icxOp+G8yByU60Ju5Peg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hpSyuA+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hpSyuA+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50754C116D0;
	Thu, 15 Jan 2026 17:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497667;
	bh=YhJCnVoObTjvqArUhQlX1PI8LmKVzhYto7jw6jZrQI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hpSyuA+/oYf0ug3RQMw7ELMJ3Gmy3GUOgXCJE9CrPPA960GbtfTjXMYRCBPOvfIWS
	 CqQ+kMh5NJ5PCs8VszDTGGxHOx+PQHMu90EAASJEOW0S6BW/gLO5397LqFppJMqAzN
	 eyHOPIlI39L3pNDGHAD28bRbim8sAVco8eLRb+Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianglei Nie <niejianglei2021@163.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/554] staging: fbtft: core: fix potential memory leak in fbtft_probe_common()
Date: Thu, 15 Jan 2026 17:43:20 +0100
Message-ID: <20260115164251.101976389@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
index 54620ae6919bc..67604a4d9a39f 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -1228,8 +1228,8 @@ int fbtft_probe_common(struct fbtft_display *display,
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



