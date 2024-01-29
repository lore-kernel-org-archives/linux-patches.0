Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A3015AAB1;
	Mon, 29 Jan 2024 17:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548352; cv=none; b=q387/xTAOv130eUjkJQmrTjnVog3hfPCj6GqdGEayqGD1ed0mHb63YZURhOq0JBjITJtmhvqQGuXbgGWBZb7ZumRqagG5BrteGoEpkCK9QLw1m3AQzykTzI8Qb0SYsoegh/CcDTR9qSD0Al/pkbsBdoL66CYABfEbd2ljrnIU5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548352; c=relaxed/simple;
	bh=+HKOR7pne07O1ACbCe/dlZBHX8DkdTMYHu5xGiihD7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRPqNKabWcVNRI5wPGY9/VHpm8fdyaISB4JJUtBdUGtB9JPOiNDdZsmkmVT3/V9MK/wB22NHYADQbewdEN5N57HqFxJCEKKCes2enltXh72m8CmpufrCl9U4OFhZOC+Mg1z8/4sPjGMJy3KXL9kNTRxbWyzqaaQONymbFY0P9Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Pp+9HSB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Pp+9HSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F5EC433C7;
	Mon, 29 Jan 2024 17:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548351;
	bh=+HKOR7pne07O1ACbCe/dlZBHX8DkdTMYHu5xGiihD7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Pp+9HSBcCbpVrE+B8dhSLgovKDl2gMauel9DXgDYPGk+O9eMSTYTe8jz/oBqRybt
	 /yNOPJCZGFpU4roGSVPUjybNhvGaVF2adoNrEHaKWhHet0We06NogA9rSlBW46xW/6
	 MTGnMgVdVySnunNP5oIJTN3YgnZXxqSHL6jgqbEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 317/346] drm/exynos: gsc: minor fix for loop iteration in gsc_runtime_resume
Date: Mon, 29 Jan 2024 09:05:48 -0800
Message-ID: <20240129170025.801150400@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 34cdabc30b4f..5302bebbe38c 100644
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



