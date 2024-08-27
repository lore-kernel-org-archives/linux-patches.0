Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0610FDDC1;
	Tue, 27 Aug 2024 14:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770168; cv=none; b=j89imqTeCvgoVuyAtyBjXmqIeF5cR1lxfD0+6LVeMnwn1y1Q/vnaPQhPwrneWEdebqRuN3LEz5ZjZ/Eq4vWouInhNrv6OjBwlcam4SpYkWZqfOZDvcXXme50qtQacEny35AfwQq+e2+npatzOdN4VsbLoGDYbz8CEdZl+K3HHpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770168; c=relaxed/simple;
	bh=s/M7E2uq2vv4yQCV5JWTvk6zKJbN1Rhwt9N5mOaJYfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfQj/EbKvvwmRQ9Pao+tlF8m1j013Rrlp2UIe9ehV20stHE4Kspzir2bGGOHV71DGWBb7QU2zHiNh9mltF2zwJ+7D87nf327Px0haq729l7PVO+VlAy3IEYb0/u51WQBwLscLBtk9UJbYKHA/Cq0x6V/a2vRraTcyUU2311dS7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WgqscGBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WgqscGBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB29C4AF1B;
	Tue, 27 Aug 2024 14:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770167;
	bh=s/M7E2uq2vv4yQCV5JWTvk6zKJbN1Rhwt9N5mOaJYfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WgqscGBOHhD0Q7A/tEfbA+RuVpX3TuoBKNhu2nSzeCLY11N1WFXKcnbu4bdZelZbR
	 S9hKQvn+RawfRqQWasclC1Qvi10U96vVKqr8NP1WUXeJmK52XOHqEN5fnSjesS90or
	 Z2o5cjCnujQlwd0OLWHpR3cGUBLKDXRZIiWh9CJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashish Mhetre <amhetre@nvidia.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/341] drm/tegra: Zero-initialize iosys_map
Date: Tue, 27 Aug 2024 16:35:51 +0200
Message-ID: <20240827143847.980417207@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 3868ff006b572cf501a3327832d36c64a9eca86a ]

UBSAN reports an invalid load for bool, as the iosys_map is read
later without being initialized. Zero-initialize it to avoid this.

Reported-by: Ashish Mhetre <amhetre@nvidia.com>
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230901115910.701518-2-cyndis@kapsi.fi
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
index a4023163493dc..a825fbbc01af6 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -177,7 +177,7 @@ static void tegra_bo_unpin(struct host1x_bo_mapping *map)
 static void *tegra_bo_mmap(struct host1x_bo *bo)
 {
 	struct tegra_bo *obj = host1x_to_tegra_bo(bo);
-	struct iosys_map map;
+	struct iosys_map map = { 0 };
 	int ret;
 
 	if (obj->vaddr) {
-- 
2.43.0



