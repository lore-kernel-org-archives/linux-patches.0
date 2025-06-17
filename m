Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216512EA14F;
	Tue, 17 Jun 2025 15:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175284; cv=none; b=N5mqwWKefK/NSiX6TUNgYYgdOCbKKUqwLu+FZ39wqB0UbaaQ7JAojKKaoG/4yezxlpoAyy51dZwSWyEpnp4nbqxdQISNOiZT7u3JdH+kWqd8LAvEWWmElHXztOEjmtKrjeU9qAxcYwk5wOt2UG2mqfGj6X4HInwlu6eJLem048E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175284; c=relaxed/simple;
	bh=dVcKa67pkXNf20oihiI6q2gWjP9yAMDBha9zzalTAXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rwes8+xvQfYf41Dh5X5XBNwe/cenCxbhpSvoDeAUrRGFrBkqhdUvGFrsaAhqEEdhN8HCOWLQMysHopk1bL3Op+tQrVjo2df/mlhTDkQWPTSKzPvakThOf5eWjhwaY4Uk48XRWRx5Ji1RPKWF0TO+hiy6Yeetgmg1FT7MISm/xkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6Olthrh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6Olthrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853E6C4CEF0;
	Tue, 17 Jun 2025 15:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175284;
	bh=dVcKa67pkXNf20oihiI6q2gWjP9yAMDBha9zzalTAXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P6Olthrhm/LnK9+x1r0mrUYAmBlOBkz3ivQjVf2fYdo7LCXvpwNPhpXJHRe308Agy
	 pNF6aTpUAbL+KjqBqjB1akzOScXe8c0sMV5JMmTzX7E9vLE9Hov2qTzNu2hXEljK39
	 1zWPL2Un5ASTlYTjP/6PjADPknibBPV95Bn7n4pY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 070/780] ASoC: Intel: avs: Fix kcalloc() sizes
Date: Tue, 17 Jun 2025 17:16:18 +0200
Message-ID: <20250617152454.367141504@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit d20df86b056b95845f6ed52da1010059202a0c23 ]

rlist, clist, and slist are allocated using sizeof(pointer) instead of
sizeof(*pointer). Fix the allocations by using sizeof(*pointer) and
avoid overallocating memory on 64-bit systems.

Fixes: f2f847461fb7 ("ASoC: Intel: avs: Constrain path based on BE capabilities")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://patch.msgid.link/20250426141342.94134-2-thorsten.blum@linux.dev
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/path.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/avs/path.c b/sound/soc/intel/avs/path.c
index cafb8c6198bed..8f1bf8d0af8f9 100644
--- a/sound/soc/intel/avs/path.c
+++ b/sound/soc/intel/avs/path.c
@@ -131,9 +131,9 @@ int avs_path_set_constraint(struct avs_dev *adev, struct avs_tplg_path_template
 	list_for_each_entry(path_template, &template->path_list, node)
 		i++;
 
-	rlist = kcalloc(i, sizeof(rlist), GFP_KERNEL);
-	clist = kcalloc(i, sizeof(clist), GFP_KERNEL);
-	slist = kcalloc(i, sizeof(slist), GFP_KERNEL);
+	rlist = kcalloc(i, sizeof(*rlist), GFP_KERNEL);
+	clist = kcalloc(i, sizeof(*clist), GFP_KERNEL);
+	slist = kcalloc(i, sizeof(*slist), GFP_KERNEL);
 
 	i = 0;
 	list_for_each_entry(path_template, &template->path_list, node) {
-- 
2.39.5



