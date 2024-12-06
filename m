Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECDA13C9D9;
	Fri,  6 Dec 2024 15:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497294; cv=none; b=iWGmhqXA9P+B9jJOJ/OL4m8pMWxIQ7LzEfX5fvAfftZyapS3PlPcuNuuWnEqF31CMF9N0kCrE9SvwCOOqvoVWieXdwiwK8k7b/HHvYSw2LE/9+d/S4QQo3DNZKbigV95P8lJdVPkDUC0OA9eZbJpANAoDC0FJdwCODxjSpoq7sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497294; c=relaxed/simple;
	bh=O+46Eo+rZL7Yc8hIjuSnGf+H8vFmgINbwB8UuxjYJrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBX9fGlEw9dZbcgb1cBYAMxUgNNKZ7O6niPA2hfn0BRkgiweC7MyWYB46vSz0Vxf0Le13rg8691OMjNwAsKfeY/sMSKWjG0U/GT2h+dQcUP4KrQBlEZFLcbaLyo7/GMzKroIt34a54EeuDy+VuGJ06QzrasCFb3EbcjOGH32i9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WL/05PlV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WL/05PlV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA64C4CED1;
	Fri,  6 Dec 2024 15:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497293;
	bh=O+46Eo+rZL7Yc8hIjuSnGf+H8vFmgINbwB8UuxjYJrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WL/05PlVlesC33zER5EeqrUN+vUcS/CHHCzS+cTFlrAej3TdiIh5z/S0WKWMurQAk
	 mAzEUp0RKvPjUa4ycpbFhfI+jsGVUCnGCV0RcLqHXH6D4+LYKgTDG9mKEowsNPgUH0
	 MIFW+1MbSfkFBn5ooan3KiqMDsRVqI1KTJyKG0rI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Huafei <lihuafei1@huawei.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 219/676] drm/nouveau/gr/gf100: Fix missing unlock in gf100_gr_chan_new()
Date: Fri,  6 Dec 2024 15:30:38 +0100
Message-ID: <20241206143701.893727643@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Li Huafei <lihuafei1@huawei.com>

[ Upstream commit a2f599046c671d6b46d93aed95b37241ce4504cf ]

When the call to gf100_grctx_generate() fails, unlock gr->fecs.mutex
before returning the error.

Fixes smatch warning:

drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c:480 gf100_gr_chan_new() warn: inconsistent returns '&gr->fecs.mutex'.

Fixes: ca081fff6ecc ("drm/nouveau/gr/gf100-: generate golden context during first object alloc")
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241026173844.2392679-1-lihuafei1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c b/drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c
index 3648868bb9fc5..cd533d16b9663 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c
@@ -443,6 +443,7 @@ gf100_gr_chan_new(struct nvkm_gr *base, struct nvkm_chan *fifoch,
 		ret = gf100_grctx_generate(gr, chan, fifoch->inst);
 		if (ret) {
 			nvkm_error(&base->engine.subdev, "failed to construct context\n");
+			mutex_unlock(&gr->fecs.mutex);
 			return ret;
 		}
 	}
-- 
2.43.0



