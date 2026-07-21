Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24011231829;
	Tue, 21 Jul 2026 22:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673571; cv=none; b=R49S8Mw4sbaOqFIsS62YHHkZwhxLE+m3WZ3f60gcuK70w9cheSPl7Dn7DhWJdjSvpjlAe2vUTBFiUF07ZRp9ZwmvQJTPQTdJsTIAib8oUBc4sSOIY2AHfoEt9cyl2KPJWGLgl/7jXR2lSg3Rqzka2xlBywCYGeLjyoYifkCAuDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673571; c=relaxed/simple;
	bh=xtzBEr0A+oZOwu2/noMWEy+UcwjXpiELIXa2d5RyDQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJkUxD4ut5slmn4fAZYe5+BQc0y1mOAXxQU6gGahVc4GpzKPdn3i0TmNzQ/5MegVpbmFh4/hd4V+RkOmbafKM70oVgoz0NSgMly6whif8gD29ShOdKNhR8qdK+yPI9ZVeClolfVkURHoAd+loFBkzjtu6+48SVtdXeT4kM1jjnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uqof2RAv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqof2RAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F8B1F000E9;
	Tue, 21 Jul 2026 22:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673570;
	bh=hFDxN73/eJjlaAONHoIa5b/upXqEwCgKZgfiJValLdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uqof2RAvGze7upF+EaW2f4MeaNJkT47HYbRG2dt43cSRLKQHqtWoEEPwRp6b6njqZ
	 LAzgg4HNkbJeRKpy0ertueSfOI5zYAJziJTECPEu8TI1dyK5U0wbeXWVsh/5KUc+HU
	 r//4SlZu5uxXgxpkAI7v58rQcNfPPjo0RnjMxfok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 211/699] drm/tegra: dc: Fix device node reference leak in tegra_dc_has_output()
Date: Tue, 21 Jul 2026 17:19:30 +0200
Message-ID: <20260721152400.457706018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 63a3998d792ab5c45304bf879e385a31fa923b61 ]

The of_for_each_phandle() macro increments the reference count of the
device node it iterates over. If the loop exits early, the reference must
be released manually.

In tegra_dc_has_output(), the function returns true immediately when a
match is found, failing to release the current node's reference.

Fix this by adding a call to of_node_put() before returning from the loop.

Fixes: c57997bce423 ("drm/tegra: sor: Add Tegra186 support")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Acked-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260128-dc-v1-1-a88205826301@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/dc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index dbcbe91a462a9c..cff8f545515f46 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -93,8 +93,10 @@ bool tegra_dc_has_output(struct tegra_dc *dc, struct device *dev)
 	int err;
 
 	of_for_each_phandle(&it, err, np, "nvidia,outputs", NULL, 0)
-		if (it.node == dev->of_node)
+		if (it.node == dev->of_node) {
+			of_node_put(it.node);
 			return true;
+		}
 
 	return false;
 }
-- 
2.53.0



