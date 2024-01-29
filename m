Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE3775606;
	Mon, 29 Jan 2024 17:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548604; cv=none; b=lbhHU1/dAzvP/Oa86WsZzt5ZVgFQEBPV63lPyYKH/pkWSZX/fD2ggWjYYhJ12heWzQBSj5uzR9xrHZ7SqEhEzGEa4mVdQGmGIF+5DAY0eP4XHpidHrQvkCmuIPbcELsXSoqsneRrmMLYawWxSgF7x4AeBnraGMlzKuLkPlb31fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548604; c=relaxed/simple;
	bh=+yGgYmdzVuY9TGqQhGUfh/XNb9t06uadYTQCEZ5M2hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcFLbZ4NTgRt3EDCeBBhGlGRYvR8uvrvmxP6RoJBL4ayPN5q1Yv5H9VzK1MIKRXzErpJ9WJDlxGKGWR9+sct8+/oqdbj585cZC+sIZq2o0UXtlN0v4KKiLCYpK8IGBWv92H6RQ94Fr91ab3Q9kx1NJI4h11nTp9o2kZ50NyTMLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fBMmxvNM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fBMmxvNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3753C43390;
	Mon, 29 Jan 2024 17:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548604;
	bh=+yGgYmdzVuY9TGqQhGUfh/XNb9t06uadYTQCEZ5M2hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fBMmxvNMrcgTnRj6hOK5V9jHadkv8zaJ8DnZ5JowOGxvPHFIQ5Wi/wrLB/yV74sTA
	 8VjMLC1reXS/vs9nWiDstKE6Z/GxMLjVgCPlW8mFD6lpmgNuBtuH2v7dlJky59kh2H
	 quOYgPdU6JCJD4J55Gm7mNfusl/U9hLKK+2JOXx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Likun Gao <Likun.Gao@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 266/331] drm/amdgpu: correct the cu count for gfx v11
Date: Mon, 29 Jan 2024 09:05:30 -0800
Message-ID: <20240129170022.646290962@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6353,6 +6353,9 @@ static int gfx_v11_0_get_cu_info(struct
 	mutex_lock(&adev->grbm_idx_mutex);
 	for (i = 0; i < adev->gfx.config.max_shader_engines; i++) {
 		for (j = 0; j < adev->gfx.config.max_sh_per_se; j++) {
+			bitmap = i * adev->gfx.config.max_sh_per_se + j;
+			if (!((gfx_v11_0_get_sa_active_bitmap(adev) >> bitmap) & 1))
+				continue;
 			mask = 1;
 			counter = 0;
 			gfx_v11_0_select_se_sh(adev, i, j, 0xffffffff, 0);


