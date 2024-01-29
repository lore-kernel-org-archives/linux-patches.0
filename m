Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0AB15AAD9;
	Mon, 29 Jan 2024 17:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548397; cv=none; b=eHG1SpnCCH/WyWuLOgaiOzSNICT7eS7gFwOwE90Ye8UZwLiVBoQP+/oNQLYc1VT0HZcTmpxsl0JNJS37cDen0R/8euGCDmfHOEfellTXOuilXtedZFyCtEdLE7l196yfA3zf+U3gkSvCj9oRF+/gu5LptBaWprNUBsgO+ntP/ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548397; c=relaxed/simple;
	bh=LxfZnP+0GWyY1lI8azeZE0E3Hh0WTx+wAA69PkiuIvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyWpenNNCc5vzVQH97zn8GLs6KxPzj0/4C/TBTxG55ikGrAHm/Az+WXwab01qbSgM3XaOaNeLuUmNC+7s8voqHtsWhACYD7efzSz6PgzUtkIUGs1nYnwbreA+qpagN0LJBIbHFQpE5ju9jeA5UIJDNHOQJrVAuT0LxhWlNrIjrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jwu8R+/m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jwu8R+/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01ABDC433C7;
	Mon, 29 Jan 2024 17:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548397;
	bh=LxfZnP+0GWyY1lI8azeZE0E3Hh0WTx+wAA69PkiuIvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jwu8R+/mhA8MNv9y26+vHLQO05iJOM2HY57PFL+SmFCuop1kf6YixAecRd/sjF/2/
	 lwn6v8eCN/FKmDEf/aYpYbpD/w1f0qP8uzu6Vpp7EcZt8gwQa9B+ssG/E6pWvVt6SZ
	 xh2dpHLXc8D7glGRDO0YY570NxFlIU9ihwyp5i0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 174/185] drm/exynos: gsc: minor fix for loop iteration in gsc_runtime_resume
Date: Mon, 29 Jan 2024 09:06:14 -0800
Message-ID: <20240129170004.177122972@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 4050957c7c2c14aa795dbf423b4180d5ac04e113 ]

Do not forget to call clk_disable_unprepare() on the first element of
ctx->clocks array.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 8b7d3ec83aba ("drm/exynos: gsc: Convert driver to IPP v2 core API")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_drm_gsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_gsc.c b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
index 964dceb28c1e..68ea92742b06 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gsc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
@@ -1342,7 +1342,7 @@ static int __maybe_unused gsc_runtime_resume(struct device *dev)
 	for (i = 0; i < ctx->num_clocks; i++) {
 		ret = clk_prepare_enable(ctx->clocks[i]);
 		if (ret) {
-			while (--i > 0)
+			while (--i >= 0)
 				clk_disable_unprepare(ctx->clocks[i]);
 			return ret;
 		}
-- 
2.43.0



