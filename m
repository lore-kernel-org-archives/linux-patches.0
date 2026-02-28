Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7595B326D63
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300977; cv=none; b=MdZ1O2PkURtHtepgU9C7Ozq6OTDjVgyOweInqlq0RFH4e0RD3ZQTSdl6yTRTNm96LAgN8y6hSZ9e5u89ZcRJAovzWUfmMqk5cxrE7VLk+qDSh4HwQMlDJhPzf8Smr0+ychiMkMnavKMOeJHKteteEENTmU/+rhRYAOoOnidcji0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300977; c=relaxed/simple;
	bh=D4S+aY8GmcexbvRG+yqqg9NcHYPxHmjmOmcxggpODE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rk5XigkEbQiwuH1p/ZH6EX1TD+FkGj9NutPTcFfnrPCM7GjahVVEy+hlHl0n8pmlaqI33FazWPM5oovfW4GMLu/bxvd3B4N3L6dJFHX+eA0YsdPMHqdUTWOmvRsQyu6KNTSiF06QfM0IobRM7lzNjeDW4qlYKzIYCGX2efbrBhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CiNRsFwi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CiNRsFwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AECCC19423;
	Sat, 28 Feb 2026 17:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300977;
	bh=D4S+aY8GmcexbvRG+yqqg9NcHYPxHmjmOmcxggpODE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CiNRsFwiqbL94Rl0Hrdz2P7D0OQi8/4/fWvJn/Cj5HNRyLpMUIEGvr59cA37cKqWX
	 F2Dm9Jg2JINyjkm0JU3G0g+sjS9M/FLWbxdisphAQSjRbol9VYudO6BqwsIkoyFrOm
	 /DdjHF3pUP+FaORxF7awIkwJsG2ICZZ/c1LkRz9pcCNQYbUMu08zXuSKRNgAfEWnEo
	 qLRE5hFORqlkOkStgzzPhd4hS4njUnbNpGywVUgC8yo6WIF5useu/r/GkITSEuxyaT
	 tuCakb/F9kSttfOvvGFwnkSncf+ght1KpEM+S+vnjxvHyK4JKkB2fpi9xaXAsFh2Hr
	 1gIafQjpaIiRg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Matt Roper <matthew.d.roper@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 105/752] drm/xe/ggtt: Use scope-based runtime pm
Date: Sat, 28 Feb 2026 12:36:56 -0500
Message-ID: <20260228174750.1542406-105-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 8a579f4b2476fd1df07e2bca9fedc82a39a56a65 ]

Switch the GGTT code to scope-based runtime PM for consistency with
other parts of the driver.

Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patch.msgid.link/20251118164338.3572146-51-matthew.d.roper@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_ggtt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_ggtt.c b/drivers/gpu/drm/xe/xe_ggtt.c
index 20d9171bd3d0a..2f96983a66b6e 100644
--- a/drivers/gpu/drm/xe/xe_ggtt.c
+++ b/drivers/gpu/drm/xe/xe_ggtt.c
@@ -365,9 +365,8 @@ static void ggtt_node_remove_work_func(struct work_struct *work)
 						 delayed_removal_work);
 	struct xe_device *xe = tile_to_xe(node->ggtt->tile);
 
-	xe_pm_runtime_get(xe);
+	guard(xe_pm_runtime)(xe);
 	ggtt_node_remove(node);
-	xe_pm_runtime_put(xe);
 }
 
 /**
-- 
2.51.0

