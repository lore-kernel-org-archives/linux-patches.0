Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C96B1586DC;
	Mon, 29 Jan 2024 17:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548237; cv=none; b=fWGCMu9vn/qqKkuYPjX6lwIIOt975PnbH+OT15fChgQIUREbupJjHFriKA+A992FfBO++bp7/251QWYWoVwDsP2AwNnrIuRAyTDLqYOJUPcrqvREOGnUkWYEWrkHamSo1LBWbSYgjTk3cspDI0sKTIpV8s8yfTPIlfYfLw4auBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548237; c=relaxed/simple;
	bh=sGcDKUNMziU7HJZkNDZH8zzSKkmj4FvprNE+4rSjiqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9HCFiJ27Yj1/tvfkqVoGaEK4fxvwCQSin/5QpwQ++OiPe39+GdfHn6eOgDehpqHy4uP1CtQr40nHUYRmyJIJn1x2ZLOB3UwzNwEH4RklWqDJ9WKceKmlbLmDB06oK/TuLyfSKH3ynNDahA9zQpbZnT4XSfNz2NHEjsNa6qhFLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=maZWEJ7X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="maZWEJ7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CC2C433F1;
	Mon, 29 Jan 2024 17:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548237;
	bh=sGcDKUNMziU7HJZkNDZH8zzSKkmj4FvprNE+4rSjiqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=maZWEJ7X7QvHPBsvsstfcItNk7cx42ns14v/BFV6FQsk5xOSgxrrtMcRh3nrwmyPD
	 Ry4bks7Q6sqEngp68L20093J5/2W0cyxaJ3JbHRDjjcbYLqzqvLwwPXdYL+GORZ3jD
	 qJRgrYqUsnhOVyzgh7eRb6DQfB6anbrU0Hg/WcdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Likun Gao <Likun.Gao@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 264/346] drm/amdgpu: correct the cu count for gfx v11
Date: Mon, 29 Jan 2024 09:04:55 -0800
Message-ID: <20240129170024.155435660@linuxfoundation.org>
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

From: Likun Gao <Likun.Gao@amd.com>

commit f4a94dbb6dc0bed10a5fc63718d00f1de45b12c0 upstream.

Correct the algorithm of active CU to skip disabled
sa for gfx v11.

Signed-off-by: Likun Gao <Likun.Gao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -6328,6 +6328,9 @@ static int gfx_v11_0_get_cu_info(struct
 	mutex_lock(&adev->grbm_idx_mutex);
 	for (i = 0; i < adev->gfx.config.max_shader_engines; i++) {
 		for (j = 0; j < adev->gfx.config.max_sh_per_se; j++) {
+			bitmap = i * adev->gfx.config.max_sh_per_se + j;
+			if (!((gfx_v11_0_get_sa_active_bitmap(adev) >> bitmap) & 1))
+				continue;
 			mask = 1;
 			counter = 0;
 			gfx_v11_0_select_se_sh(adev, i, j, 0xffffffff, 0);


