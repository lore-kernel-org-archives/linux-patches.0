Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFFF224F6;
	Tue,  8 Apr 2025 11:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111140; cv=none; b=Jm8tgaPpslaefnyNePZaJvuyConYSbZqbDuV8QQ54tGv2Nij8Z7MG0FAxmtu/tnbZuMURpZ18y5Kf6JrMYzR1HhLX+r89mUQI0dwFbbg98ZsRUfz1MMgLcA3NEFTgxCrKdeY2gf+NVEeLpuOmrv7UfvJuGMOve3l8aDWkiVNvmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111140; c=relaxed/simple;
	bh=nrOV5JrIHHq3gO9Lv+lJh0A+5sP6zRGOfSD/xkHbTyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyxYkrB7Rb+ysM47rl11jZM6DmnlRYxPqE6QslFxJJjwkZpOOHB7yckjHu/4HhkGWBlUIEX3nO144r/JkvB8uxbq4gt7Fq0vFaLecweTdEBYnArXu6oKIHU/DZLubSgU+teMNFPKqvszz/nvine0Nczice+f2RZ7f3jqVNckPJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tWC31sq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tWC31sq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48315C4CEE5;
	Tue,  8 Apr 2025 11:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111140;
	bh=nrOV5JrIHHq3gO9Lv+lJh0A+5sP6zRGOfSD/xkHbTyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWC31sq3Qjs2ExsXRsJkLz6OMXJNy1tYVarJZ5Vym5o7uFcL+XpDDRVzZX6y2gM55
	 uELTUU80M+Bc0HFM1jEH2a2UsvgW3IuDXVl29mWBeR3inV406urCkI/euB6zimxCRR
	 yKEldty7BsoYLwXhPC7LWdEpkH0bB8lK0STsI1+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 323/731] drm/msm/a6xx: Fix a6xx indexed-regs in devcoreduump
Date: Tue,  8 Apr 2025 12:43:40 +0200
Message-ID: <20250408104921.789439299@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 06dd5d86c6aef1c7609ca3a5ffa4097e475e2213 ]

Somehow, possibly as a result of rebase gone badly, setting
nr_indexed_regs for pre-a650 a6xx devices lost the setting of
nr_indexed_regs, resulting in values getting snapshot, but omitted
from the devcoredump.

Fixes: e997ae5f45ca ("drm/msm/a6xx: Mostly implement A7xx gpu_state")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/640289/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
index 0fcae53c0b140..159665cb6b14f 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
@@ -1507,6 +1507,8 @@ static void a6xx_get_indexed_registers(struct msm_gpu *gpu,
 
 	/* Restore the size in the hardware */
 	gpu_write(gpu, REG_A6XX_CP_MEM_POOL_SIZE, mempool_size);
+
+	a6xx_state->nr_indexed_regs = count;
 }
 
 static void a7xx_get_indexed_registers(struct msm_gpu *gpu,
-- 
2.39.5



