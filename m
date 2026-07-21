Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6873ED3B2;
	Tue, 21 Jul 2026 19:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661743; cv=none; b=BBxekLF3/7gT0iM3F19hrD8q4u8iWbvvW5hP12NO0kZkxt896FQ6J4wSHXV5ZhAxCYbOz+y3+An6D6sUoRIoaV5QLOVHwOhRQHKYpEVeenxj1ruz/FePTaWBthxfawgzbAFaI6cHXtW1T/h3yvPFbbgYc331wwgPjJQ9rP3mrno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661743; c=relaxed/simple;
	bh=ORVbnNepUnSFWtNTszQkkXZwP1D5pZBNEND/v32deOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcFgXOyVg0k6lHDsHKpDdqQLI+FRMwswu5oMSc0xXfO/9RRbmbZh2FZUKbEFww0s5tvfRVMNMAw7+SAAg6Yo7KtweFdH5/UbzGB/2FXq9lAmS5gN6OXliBh2VmwCuH/hzkirFtr0ACS6hMF4kBEDAqxs/76/sgfwkdLmW9G42HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4dl31xH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4dl31xH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B98D1F000E9;
	Tue, 21 Jul 2026 19:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661741;
	bh=iocpM3aK6yBZVJq8GelzfZfG5KMspG3LKKUMYVGTiJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i4dl31xH/eTrT+geJ3tY26Aq6GjRjJAU0E5BJJXwcueaXPZ3NHLd6BqnOrmowQzJ2
	 +n8gi/bLKNxkph5YrikRP4hjxRAjbEeyKJus6GBb6MzMtz99zDRcX+BEmnBcxyxwUL
	 oTmR8sV4LtDtZOLvSqf9YofEz5b7Tv9qLT2VjWjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0179/1276] drm/tegra: dc: Fix device node reference leak in tegra_dc_has_output()
Date: Tue, 21 Jul 2026 17:10:22 +0200
Message-ID: <20260721152450.101354294@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 90d3d30a841514..c32e20e461696b 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -100,8 +100,10 @@ bool tegra_dc_has_output(struct tegra_dc *dc, struct device *dev)
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



