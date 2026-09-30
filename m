Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29313A1687;
	Wed, 30 Sep 2026 16:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784427; cv=none; b=kVEcji4H1XSx2/pBNVqDpzXLhIRYN3bq1TKRIXBMJS8NpBE8nw9uzBwF2wQlKcB8Ri1j8K+lhe3t2TOB2KlEQfPvPrsb+mWCcZfNEUbN8LMMcSlYs0zXXEWWuq35rOyi8F+JZ/n2evtUQzbG14PgGoFrTLzFP6CCOTrTvdTo6sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784427; c=relaxed/simple;
	bh=QzE+wjZtLCBPZM6E1Ed5Mlouf7nEz6wj2ydNxM7KELw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpjPmsBmkz4IpOKI4Fm629wQQlIgJmsWd6f4buwRPJ/juxOkrPklSFDAlaY5XD7ILdqBgTQnWTMXkZjvHeSeZi7NfC++y1JwaWlnhIvOSeiFjZUuoHk7Cg5d1tqc5ksIbUBXb6pZoiFOgGNVrLgL4uSStGt9gfQZzsSY3MNGLks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WvyDO2qf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WvyDO2qf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1E81F00899;
	Wed, 30 Sep 2026 16:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784422;
	bh=A5ONL529yP6NcLU/WLIfF1b7495/XvKdyX5H2Wx3PnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WvyDO2qfZuiHcz8zorVypQCWzWZ1I/mzLGzA79Rfp2u6/jW5H5DS6vV4aymNRBBTI
	 qnB5HFTJp1RvEmUKCQ5TAQF6mHaBPFIreAQXdACet0tPSdRUaXMony/B2p5yeg/cAF
	 BqTNn1uDMxxqGfNVfMZOcT2dYpaXZKfK43ybvZaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 149/982] drm/amd/pm: bound pp_dpm_set_pp_table() memcpy
Date: Wed, 30 Sep 2026 17:14:45 +0200
Message-ID: <20260930152420.016139407@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit f193e71fa9fab2e68ef85201b106e8f580d3a25b ]

The powerplay path allocates hardcode_pp_table once with kmemdup(...,
soft_pp_table_size). memcpy(..., size) used the sysfs store count (up to
PAGE_SIZE) with no upper bound, causing heap overflow. Reject
writes where size exceeds soft_pp_table_size.

Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
index 1f8b744d6b178..e4494d963e356 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
@@ -681,6 +681,9 @@ static int pp_dpm_set_pp_table(void *handle, const char *buf, size_t size)
 	if (!hwmgr || !hwmgr->pm_en)
 		return -EINVAL;
 
+	if (size > hwmgr->soft_pp_table_size)
+		return -EINVAL;
+
 	if (!hwmgr->hardcode_pp_table) {
 		hwmgr->hardcode_pp_table = kmemdup(hwmgr->soft_pp_table,
 						   hwmgr->soft_pp_table_size,
-- 
2.53.0



