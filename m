Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4EE376A0C;
	Wed, 20 May 2026 17:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298702; cv=none; b=snQsZfdrjKWPimvyGtrv/FdeKGqNcGAG6I3MnMqytc/hPLTyXUahWZtfafxdbvjrJj6fbnmadFZ0YdxPxB3KX+8LR/+JJMtlvDJeyZq4yPCuX8TKQ5K8KrO4qO+HG2CXoW/PoxYRiwTDShju7ANgwpo7G+/01sNHixAFwY3Ccyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298702; c=relaxed/simple;
	bh=8WReK9ZGmI/aQk481qPns5xhi6PHarTlYqA5jzSyocQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DhrbSTU5ckTUdO48qmfBU/aL2714udLB4d64tw2UQz9lJEjYNXucbTrSU4BafBAznrtde7hMVzIxPKouHFfvu1BAx+pzqsB/gTXVdZJ5yHEl87BI56blLpPMxcE2zYDJBeHsC7CHOlUP9fXEHYq059vRIepf79TYFSsIpGYm2LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zs2WUAIS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zs2WUAIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4F31F000E9;
	Wed, 20 May 2026 17:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298701;
	bh=ZW7dkN0+rEDYlgtuRp7lDj+Jj5dhSQCjGLJOQaXUGg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zs2WUAIS5OdL/wGEMuYHgsZ0s71IX5OaqnMqwCK0mV1QGc4+/Ety/xjh4KoGEKNuh
	 djRpS39PBdRUrQsOoBSopnIXOuXWICmyCTqCir6OPCe5VEPYvgOROmc9OVK2UzCgul
	 4gqJSbQzrG9mmxLKW90/0ceLOwWxAnd5sX06BKng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 511/957] memblock: reserve_mem: fix end caclulation in reserve_mem_release_by_name()
Date: Wed, 20 May 2026 18:16:34 +0200
Message-ID: <20260520162145.618762034@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

[ Upstream commit c12c3e1507809ad1fc0448f51c933f52e17d13cd ]

free_reserved_area() expects end parameter to point to the first address
after the area, but reserve_mem_release_by_name() passes it the last
address inside the area.

Remove subtraction of one in calculation of the area end.

Fixes: 74e2498ccf7b ("mm/memblock: Add reserved memory release function")
Link: https://patch.msgid.link/20260323074836.3653702-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memblock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index f0f2dc66e9a20..757258d68425a 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2433,7 +2433,7 @@ int reserve_mem_release_by_name(const char *name)
 		return 0;
 
 	start = phys_to_virt(map->start);
-	end = start + map->size - 1;
+	end = start + map->size;
 	snprintf(buf, sizeof(buf), "reserve_mem:%s", name);
 	free_reserved_area(start, end, 0, buf);
 	map->size = 0;
-- 
2.53.0



