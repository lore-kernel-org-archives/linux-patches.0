Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1298C34D4CE;
	Fri, 21 Nov 2025 13:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732436; cv=none; b=IhjWYrJkeIjtZASq2Y82/uCcDE5dv+K6pAE5rx/XXaSnJJ7XyF1/IHWiI7Zv5AtrQVbYAhaX5lX+1pPKBmszPHTQz7S0231Z5SyaWNZoUouKefUyU0y1KybGQOKP5X3msI9nB7UuEq/DcM7inLF1woXKVlCAnRZIW6jEnAHp4pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732436; c=relaxed/simple;
	bh=EkkuPeUZjF/Qwq4/ppj27LYGMjzjtHU6HwVG+b4oVWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqfND65n9U4enleO0cX0wC0iOoGifdVnsm2HRNPO7V7ARPrwota+oXCCgwVNlO/BT3JZ8YeG7JUVzECwhjSAXZb23wD9K1236jVxkEunVbyRlWzc6XiaqqQN3D6HmC2PP8ptpuyeiqvLIB+uoi1NWIIYBDdXwSu3kl0NdpeI89U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NpBYNV3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NpBYNV3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78490C4CEF1;
	Fri, 21 Nov 2025 13:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732435;
	bh=EkkuPeUZjF/Qwq4/ppj27LYGMjzjtHU6HwVG+b4oVWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NpBYNV3J+SMYu57qMbpauHQfIuDv3s7xzD7CnTpKiW3WyKWldKKGXdyyEWfgALYSP
	 pX8o+7sn9mP3QjCtM42Bf2OcePg35S/lcc5GhVWrKimcyuB8egaB6JKauKuZXeMChO
	 xbXXejfRkbbXE55sEFJHAsGeTPTOJuZnvYZfcH2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/529] drm/amd/pm: Use cached metrics data on arcturus
Date: Fri, 21 Nov 2025 14:06:59 +0100
Message-ID: <20251121130235.293248567@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0cdf3257b19b3..a47898487de09 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -2376,7 +2376,7 @@ static ssize_t arcturus_get_gpu_metrics(struct smu_context *smu,
 
 	ret = smu_cmn_get_metrics_table(smu,
 					&metrics,
-					true);
+					false);
 	if (ret)
 		return ret;
 
-- 
2.51.0



