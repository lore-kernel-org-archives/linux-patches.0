Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A87126FD9B;
	Mon, 29 Dec 2025 16:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025172; cv=none; b=uOrrHIL7DTVbJtY4ExTc+t519LoEljlI+nXja5kerIiRgTG5+Zb9hkU0BBdeO7vixs3TX38bGaVh7gZegedxwyjFX9sxjYXXOnhpfibJ9rtP27o+OdEeHcfk2Kh/NrGr2wF4kGYRQp4RwId/0SMnHGDDopKE2T/p/+jpbhirCeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025172; c=relaxed/simple;
	bh=EBjKNLp3XVwiKAznL7fodLi/ZQPT0RKvbex/EyxNhT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q99bKb/RRRdGAC1ki0cA3YFxUtuAFKr/dKEunUr1qCJ1ubueXMGKJa4N+0skz7Bsr4s1419fgjn6O31lqPSleM8u947FGSDuWr2PK3l6ug1g48jOu3U1vG/ov7XbOpqRZdeb9qfFovnO1gcqCR13UVNigpci4zWXWik9LT1np1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfPjlngz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfPjlngz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A27C4CEF7;
	Mon, 29 Dec 2025 16:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025172;
	bh=EBjKNLp3XVwiKAznL7fodLi/ZQPT0RKvbex/EyxNhT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfPjlngzWA/Y1IShpT2+RcfKHGXiTDQTdJCMZvyoxxu0Pbpha2sYFg3nk8w4eFtGf
	 72kYcfmGeF8/B/qsGO5VGMZ6xToxx2M+EZQ4Cu/KxXIhFizJynSVfSogm5GOX8wmxy
	 EVW7nQknPLBYz/cPz8M4NlRmqArSobrrG65HTxq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Alex Zuo <alex.zuo@intel.com>,
	Xin Wang <x.wang@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 119/430] drm/xe: Fix freq kobject leak on sysfs_create_files failure
Date: Mon, 29 Dec 2025 17:08:41 +0100
Message-ID: <20251229160728.745663826@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit b32045d73bb4333a2cebc5d3c005807adb03ab58 ]

Ensure gt->freq is released when sysfs_create_files() fails
in xe_gt_freq_init(). Without this, the kobject would leak.
Add kobject_put() before returning the error.

Fixes: fdc81c43f0c1 ("drm/xe: use devm_add_action_or_reset() helper")
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Alex Zuo <alex.zuo@intel.com>
Reviewed-by: Xin Wang <x.wang@intel.com>
Link: https://patch.msgid.link/20251114205638.2184529-2-shuicheng.lin@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 251be5fb4982ebb0f5a81b62d975bd770f3ad5c2)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_freq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_freq.c b/drivers/gpu/drm/xe/xe_gt_freq.c
index 4ff1b6b58d6b..e8e70fd2e8c4 100644
--- a/drivers/gpu/drm/xe/xe_gt_freq.c
+++ b/drivers/gpu/drm/xe/xe_gt_freq.c
@@ -296,8 +296,10 @@ int xe_gt_freq_init(struct xe_gt *gt)
 		return -ENOMEM;
 
 	err = sysfs_create_files(gt->freq, freq_attrs);
-	if (err)
+	if (err) {
+		kobject_put(gt->freq);
 		return err;
+	}
 
 	err = devm_add_action_or_reset(xe->drm.dev, freq_fini, gt->freq);
 	if (err)
-- 
2.51.0



