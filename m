Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826801D88D7;
	Tue, 27 May 2025 17:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365424; cv=none; b=TpUvj31h8pxJqv465Yh2Sxdgw1SF1PizPpW9lsWvwfpY3cip0a8tEPjtFCgW8LTZjXNE0HBMb3fe+a48WoiBTf4AIC6B5+R1c4hzczBhFBFs/g799YCuTjfCe31lqbUUNoXplEeb9WFRrTHJ4J7czrtzh+ndbUU7IOYgZTKs5mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365424; c=relaxed/simple;
	bh=u5iIQk6z1z11wK/T3cDLh4IsQz0IgY74ZJN8iNGuA/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asHCaL7AAtuRBLStqRrp4DqxSABWW74doocePOWr3b55/6E8FZrkjUwhQpASYvUm846kqyO5mLiKnBwMsx7Uuw2pZ6aBOngqbQ3NjciSs38UtELsmnidJ/G1xHCDd79iMzYL1ljsBJm44oJWbrGkf4tuePeALGIRkCKv0hSYKSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zH0OToja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zH0OToja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92530C4CEE9;
	Tue, 27 May 2025 17:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365424;
	bh=u5iIQk6z1z11wK/T3cDLh4IsQz0IgY74ZJN8iNGuA/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zH0OTojaxtIRMi5k5Leii4z5ME16aud9H/zuBSEmqrfBFYTACGJWkcvvEdhtFu4lq
	 psRpKuh5kUUzXcQoxzniLzwtont20Q0df/nEtTLlbQpLrQT8SKEFDJwpr/njO5Zbdf
	 JSV+N4+HUkvGJdplD/5jjVsJAi44tWCV0jLjxcRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francois Dugast <francois.dugast@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 371/626] drm/xe: Fix xe_tile_init_noalloc() error propagation
Date: Tue, 27 May 2025 18:24:24 +0200
Message-ID: <20250527162500.100642247@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit 0bcf41171c64234e79eb3552d00f0aad8a47e8d3 ]

Propagate the error to the caller so initialization properly stops if
sysfs creation fails.

Reviewed-by: Francois Dugast <francois.dugast@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250213192909.996148-4-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_tile.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_tile.c b/drivers/gpu/drm/xe/xe_tile.c
index dda5268507d8e..349beddf9b383 100644
--- a/drivers/gpu/drm/xe/xe_tile.c
+++ b/drivers/gpu/drm/xe/xe_tile.c
@@ -173,9 +173,7 @@ int xe_tile_init_noalloc(struct xe_tile *tile)
 
 	xe_wa_apply_tile_workarounds(tile);
 
-	err = xe_tile_sysfs_init(tile);
-
-	return 0;
+	return xe_tile_sysfs_init(tile);
 }
 
 void xe_tile_migrate_wait(struct xe_tile *tile)
-- 
2.39.5



