Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AED2EA16D;
	Tue, 22 Jul 2025 13:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192296; cv=none; b=l5koiGANzIZ6OjeyTh4/xtFs2ylctUfJ5biCo/k2NA7Yf0da/UO2LNVfvlkFOkGF5v6w/evU6ctbVExgDcT3gosXJfYIPPS2GgueuJb/9v4+NGrCYAPueFUXKgF4NO5+uMatcdwqCbw5HCFkEU1K10TgEBCpxBazkGkr2QA2+fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192296; c=relaxed/simple;
	bh=ryi5EDFlGNOpWFXh5wWYEyteMOJS3Sga7q3JvKpNMG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQbwqTGN4rxjENlZ7mIfGkJDkkCtPbHcFJ9aIh08XrtqdtZPuS3kirnE/4mBATWZhgDuMqxYJy9AUxkCZZzBJcIJEJ0ujb/j1NcITG7B7FRx+a+Xpmk3PGnZHBmaFwYC8XzWusH7+H9IZVEu2wybq3KGxk3BPq1R6vqpUOxazMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCZAMS/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCZAMS/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC95C4CEF5;
	Tue, 22 Jul 2025 13:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192296;
	bh=ryi5EDFlGNOpWFXh5wWYEyteMOJS3Sga7q3JvKpNMG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCZAMS/bnNs1ggLnqFvhlipdo4djiQKOu0oWN9q4WYkaJNJO9aUsyRc8aBLuKAAJZ
	 0WD0mwDhg7liliaBKqXMlmsXqXsBBO4Esa52CT3pquQXlTHyGid/T9kpuujXjXYWYH
	 zOd0dFOc/f7GRQoKTSo2y5Fp7NrPIuWR5JbuqAjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eeli Haapalainen <eeli.haapalainen@protonmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 023/111] drm/amdgpu/gfx8: reset compute ring wptr on the GPU on resume
Date: Tue, 22 Jul 2025 15:43:58 +0200
Message-ID: <20250722134334.258726477@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eeli Haapalainen <eeli.haapalainen@protonmail.com>

commit 83261934015c434fabb980a3e613b01d9976e877 upstream.

Commit 42cdf6f687da ("drm/amdgpu/gfx8: always restore kcq MQDs") made the
ring pointer always to be reset on resume from suspend. This caused compute
rings to fail since the reset was done without also resetting it for the
firmware. Reset wptr on the GPU to avoid a disconnect between the driver
and firmware wptr.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3911
Fixes: 42cdf6f687da ("drm/amdgpu/gfx8: always restore kcq MQDs")
Signed-off-by: Eeli Haapalainen <eeli.haapalainen@protonmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2becafc319db3d96205320f31cc0de4ee5a93747)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
@@ -4656,6 +4656,7 @@ static int gfx_v8_0_kcq_init_queue(struc
 			memcpy(mqd, adev->gfx.mec.mqd_backup[mqd_idx], sizeof(struct vi_mqd_allocation));
 		/* reset ring buffer */
 		ring->wptr = 0;
+		atomic64_set((atomic64_t *)ring->wptr_cpu_addr, 0);
 		amdgpu_ring_clear_ring(ring);
 	}
 	return 0;


