Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF12B269831;
	Tue,  8 Apr 2025 12:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116279; cv=none; b=ONdQ88SG/51f5WXW1lA9//zbnNWrcRtUH6Lphc7q9bMYB1uzPyfoiWd4lekMUIpCYUOv6Ksn8liGbXwMIkxJ+7x0R2s8P8fJ2ZLlcMJpSMtuD0G2VoxtZ75AIiGZLCdllWH9ZUaLDnq6V4CD3tMqY4QycJ9SJPQTYC3JGC0sV7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116279; c=relaxed/simple;
	bh=S51EXWuRNsXkPebjfZ4/J7K9XN+qAq5oCOKFBtWgW/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwLp53Qm2LA2k9stBue5qeWf1Yasx7OVxdmBNrygM2C5r/vjNl1THkd66cmCZ/tBRaiZmJPJjQFRod6CCDnUOpTlHqzMwzI4q01+p5aZeApdeAYVOee9H0+0ZlUzGYs/CYorfIZq+810CWs4eO4sWGBx6UmIt25kHbQ+hf+FyyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ELnP8DwO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELnP8DwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16173C4CEE5;
	Tue,  8 Apr 2025 12:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116278;
	bh=S51EXWuRNsXkPebjfZ4/J7K9XN+qAq5oCOKFBtWgW/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELnP8DwOYVNa72dCNpeqDZ+wlvLePhEAt/KKxDjSLXJbX0i8eWue9DbxBQ3itewY5
	 CorpNLr7ZMPtwqaRDvPqToh9WtQBM3E4v97UjObmbIX2CYlp54F54mPHRPb1KMyl4o
	 zR8QqL1SxMEPlcWfvDPdxf1S+iOF8WCmcwy386Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/423] drm/msm/a6xx: Fix a6xx indexed-regs in devcoreduump
Date: Tue,  8 Apr 2025 12:46:46 +0200
Message-ID: <20250408104847.608029843@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



