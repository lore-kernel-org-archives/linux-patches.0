Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E789C3491D6;
	Tue, 11 Nov 2025 01:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823232; cv=none; b=oHNYd+2dSfmu/Flv2K/ylY2jF0No2s0QtCq0lgxjoqTgcA+z6SkWjVjqz0ARspNS+mFdVKNhlA6rW3dxc+iRxMOX3kY355ygZWWh2+cDO9H6Rn6/ev/HK40rVq6JjBhgNjNgszaQiWro/1n+ks60+6jZ0q4HHw4pFdyakjP3UkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823232; c=relaxed/simple;
	bh=R4a64Cn9l3pHCoriGvKoQ7aK1LW4fDtH3Aly4O4lU3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+wh+Hg8NJqIAuwxJqAXvRDB8tS9d0BEotfjasdMzU2NXrpGgYSlf/aVsH6IYGv6H277l3Iau1FLgV8a5yNlLcSMoyZfOGRURa267WLw+gsUJsXOA6jRRDt4kD6WbbVKwxVvwrKIycq5O9JOxi9/uFhPTXNrl0Cr+LMMmfzFCoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJt+n+0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJt+n+0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75286C116B1;
	Tue, 11 Nov 2025 01:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823231;
	bh=R4a64Cn9l3pHCoriGvKoQ7aK1LW4fDtH3Aly4O4lU3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJt+n+0H7Z1lOrUPuzkwNPqP0dn4oF8Gp5njMReXOqT4m0ECtMBhKb5Ui2bUgWlSi
	 gIY1g7697yqmn9pRy9f+JeJyzdPS5ia0e42Lv3bJGS4Crgyh7OzqGyNipjhe9zJ2Ml
	 kmQgtXJvDCGEYu3CdegsAbQXoIbvfFH8n21wvyfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 258/849] drm/amd/pm: Use cached metrics data on arcturus
Date: Tue, 11 Nov 2025 09:37:08 +0900
Message-ID: <20251111004542.669235131@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 9ad46f545d15c..599eddb5a67d5 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -1897,7 +1897,7 @@ static ssize_t arcturus_get_gpu_metrics(struct smu_context *smu,
 
 	ret = smu_cmn_get_metrics_table(smu,
 					&metrics,
-					true);
+					false);
 	if (ret)
 		return ret;
 
-- 
2.51.0



