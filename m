Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812F330F535;
	Wed,  3 Dec 2025 16:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779038; cv=none; b=BBBg3kg0TUJPP5THDYxiF3hNGH5dQoJWkKYoZOSqDIrauhs4KwfTWNylG+dUl9L5h5Ijrw3kBv0RL5krjKOUV4bo0kaKgYbyczkQ+4cP0JD8hdTY7kF2nKfO2X+Vk1Ek1NRgNCI6ZhbFLKNPhu+iy+jzbnpfLrcyycNhUK/oZHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779038; c=relaxed/simple;
	bh=c1jEJKDPrgEEVo5/IeTw0eKKL2TlzH4y940gSBl7fVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzmn9j21aUeQ7qbhIgR0dzYnOvEb62i8YprXJ5rrG5RxwbCXu7OklUzeA/NtGwyV2vKLklyS11ijYbOh3ASTpnSb83rDXBCxc3lz+n/+H5CT1mYpfQLkQNHlc2qf0PO2GiP7qarSlXoPvxhjiY8LacFxYrjhPV0yyl/azmhAllk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KtBqbCr5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtBqbCr5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD27C4CEF5;
	Wed,  3 Dec 2025 16:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779038;
	bh=c1jEJKDPrgEEVo5/IeTw0eKKL2TlzH4y940gSBl7fVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KtBqbCr5LiF9cMxrowDKF17o0oqipiujdmauZxHinla2OZ3r6DkNJA1Pbv7FlDetK
	 TmmOAgf/KhGFtMNmaAmFzWtOPjdWV689evyJVXJRwfhIEk9VBhpslmwVWA8ZSKeFuC
	 2aX/mZpTNUZgFJvKviDEGKZJhkRdf/z94lseQHTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/568] drm/amd/pm: Use cached metrics data on arcturus
Date: Wed,  3 Dec 2025 16:22:17 +0100
Message-ID: <20251203152445.671242507@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 2f3b1ccf83be83a3330e38194ddfd1a91fec69be ]

Cached metrics data validity is 1ms on arcturus. It's not reasonable for
any client to query gpu_metrics at a faster rate and constantly
interrupt PMFW.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
index ff4447702b125..ff3b2c86b0c1c 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -2375,7 +2375,7 @@ static ssize_t arcturus_get_gpu_metrics(struct smu_context *smu,
 
 	ret = smu_cmn_get_metrics_table(smu,
 					&metrics,
-					true);
+					false);
 	if (ret)
 		return ret;
 
-- 
2.51.0



