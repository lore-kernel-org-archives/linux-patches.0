Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99CE15218A;
	Tue,  2 Jul 2024 17:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940233; cv=none; b=Owi+z3ObplcQIfGDpDW6nNlg++KoCFmVvuQim3vntYciGs5iGUI8tthCqnsrPNfJH73S+DnnF77HkP882T/DcL2meVH2xAW/clNyJVQbY8AzL6tDx/bL8QbTHA9nWgSTcuT3frpyb6m7cCslEOhP6dMQd8QElm+XwlNXXYyT1Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940233; c=relaxed/simple;
	bh=QnWx7qCNheZ4bAGH35ZAWclXPqQCYW8ofQtbTP8ObmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=keqaMAkNz4pSqsZOaB+Xhx+Hcs/vQLhyRJbYzG7TfN/wrIwZLodnm9b2RPH3UW8rT8vqOmLKC1eplmUgIBs4S0/fNzBL/QkVbwDrcvhcjZzN5hWM+ItHjqYrbwgpq/LAeLJhsuB0DBZRA/P9zdynJGhe2WEoYPTH2KHQ02Tq53Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJdRB8K7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJdRB8K7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C493C116B1;
	Tue,  2 Jul 2024 17:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940233;
	bh=QnWx7qCNheZ4bAGH35ZAWclXPqQCYW8ofQtbTP8ObmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJdRB8K7+/B4Ei6e+tID9+LjNLRjsg2ms9PqoCDr6uqVLfYpXuqQUYFBKhoylxbz9
	 tYW4GeTLtHJ+FDVVGYbB0uAz5a0KcUr7oaf7zYaOfuz90jFgcnyLkJf4lNJ0ogysET
	 31dnaKYABAIOs12NNy5CyTc9cq8boOhnKx5v0XFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 093/222] drm/xe: Check pat.ops before dumping PAT settings
Date: Tue,  2 Jul 2024 19:02:11 +0200
Message-ID: <20240702170247.528950365@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit a918e771e6fbe1fa68932af5b0cdf473e23090cc ]

We may leave pat.ops unset when running on brand new platform or
when running as a VF.  While the former is unlikely, the latter
is valid (future) use case and will cause NPD when someone will
try to dump PAT settings by debugfs.

It's better to check pointer to pat.ops instead of specific .dump
hook, as we have this hook always defined for every .ops variant.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Piotr Piórkowski <piotr.piorkowski@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240409105106.1067-2-michal.wajdeczko@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_pat.c b/drivers/gpu/drm/xe/xe_pat.c
index e148934d554b0..351ab902eb600 100644
--- a/drivers/gpu/drm/xe/xe_pat.c
+++ b/drivers/gpu/drm/xe/xe_pat.c
@@ -457,7 +457,7 @@ void xe_pat_dump(struct xe_gt *gt, struct drm_printer *p)
 {
 	struct xe_device *xe = gt_to_xe(gt);
 
-	if (!xe->pat.ops->dump)
+	if (!xe->pat.ops)
 		return;
 
 	xe->pat.ops->dump(gt, p);
-- 
2.43.0



