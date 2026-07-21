Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF1745BD4E;
	Tue, 21 Jul 2026 15:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649045; cv=none; b=bUH88dT2v9yqVGVToyqZa4b7EcQNPSGCXmP3QNEwfI3NbyEnNx32bd231e0jm3irGPrRmszZwjRh6xJ+A1kIG6U1/VnKMWbg47ukjv5pqqMrntbnM+nmh/XDLs+MKU4sGM7Dkmda7tZDa+x1dnqTuDkU4xoVUHLmjiCUeZkxvcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649045; c=relaxed/simple;
	bh=aN2X2vYWXPpGfCRVs5AuZwgKJGeyUX3uls6UWBOXgik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2eTt6+3dETEQ52laaBGO5qz69gR9JhIkMOSGGYSG45EcfEO9gJGuwLE7c3u2f/6DvVQsC98CGH3bdoKTOT2VJ+wunvZ04ttMQhJymzQU3iQwKYY7KJU+441VmLb9+x/go3nJZIsFHJOo0yt/xgF/xgCHwZr54d/2Op4xx1Zsus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwaxYqVn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwaxYqVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3E71F000E9;
	Tue, 21 Jul 2026 15:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649044;
	bh=87bKEDZxHSylky/QZvnzqshyj4X7NhI+YpjZj6Ii4po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zwaxYqVnfIUzta2IuoFnQr7McRLEtL4Z7oQ9nCWSGFlsc8xYt4wUpTDt2JbeySmj5
	 F58yppRNgwSGhzk9jxIIyU2lCb4lF7xnOUKnyrlE3wr0Zv2lRYjhxo5spKYpMNHocI
	 TbFsPzdt3z4Zx1/WPhJFEeXtmYzOyFU9gVbVy+is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko <sashiko@sashiko.dev>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0429/2077] bpf: Reject exclusive maps as inner maps in map-in-map
Date: Tue, 21 Jul 2026 17:01:42 +0200
Message-ID: <20260721152602.865043531@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 9a3c3c49c333760c8944dadacbe114c1884546ef ]

An exclusive map (created with excl_prog_hash) is bound to a single
program by hash: check_map_prog_compatibility() refuses to load any
program whose digest does not match map->excl_prog_sha. That check
only runs for maps a program references directly, i.e. its used_maps.
A map reached at runtime through a map-of-maps is never in used_maps,
and bpf_map_meta_equal() does not consider excl_prog_sha, so an
exclusive map can be inserted into a non-exclusive outer map and
then looked up and mutated by an unrelated program, bypassing the
exclusivity guarantee.

For the signed loader this defeats the metadata map exclusivity check
added in the signed loader: the cached map->sha[] is validated against
the signed hash while another program on a hostile host rewrites the
frozen map's contents through the outer map.

Fixes: baefdbdf6812 ("bpf: Implement exclusive map creation")
Reported-by: sashiko <sashiko@sashiko.dev>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260601150248.394863-2-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/map_in_map.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index 645bd30bc9a9d5..d2cbab4bdf644a 100644
--- a/kernel/bpf/map_in_map.c
+++ b/kernel/bpf/map_in_map.c
@@ -20,7 +20,8 @@ struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd)
 	/* Does not support >1 level map-in-map */
 	if (inner_map->inner_map_meta)
 		return ERR_PTR(-EINVAL);
-
+	if (inner_map->excl_prog_sha)
+		return ERR_PTR(-ENOTSUPP);
 	if (!inner_map->ops->map_meta_equal)
 		return ERR_PTR(-ENOTSUPP);
 
@@ -101,6 +102,8 @@ void *bpf_map_fd_get_ptr(struct bpf_map *map,
 	inner_map = __bpf_map_get(f);
 	if (IS_ERR(inner_map))
 		return inner_map;
+	if (inner_map->excl_prog_sha)
+		return ERR_PTR(-ENOTSUPP);
 
 	inner_map_meta = map->inner_map_meta;
 	if (inner_map_meta->ops->map_meta_equal(inner_map_meta, inner_map))
-- 
2.53.0



