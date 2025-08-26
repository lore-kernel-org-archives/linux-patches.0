Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691E735082F;
	Tue, 26 Aug 2025 14:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217821; cv=none; b=iDuzVChEwy2poWT8wpPoHvoVXDWHRgi+WWE53M25yHSPmZEw9zkQLXOKVU9wKPOQZVWKcZhMP5VOfmVC00ZtmBHSfGjeXvbr0shEctrYaithYOONozALECJjZpYblFP6GG6XIaWwYqz+Spzxa+Pd+t96TkLRf/o5L0iNsB5te+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217821; c=relaxed/simple;
	bh=c66/yoow2rJUf4gZZMNCdUCnXZEqozf6XRGPYUH/llc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PG4HE/WULbcjuK+QQbt04F7zGwUlqsyWKHuo5tZIy22m2QTuJcDKyitjDgbv+8EQt/HpEyNkeaolv/aV+pmAyiCsFWHQAoDqSV8a0FZMt1E0IdCv1CgsPZeM2qCNx6/NA8M36ZhhFhJEh3p5Hx9+UTr/tgXn7kbX/uaduv8kppo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QSKa2bFq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QSKa2bFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3086C4CEF1;
	Tue, 26 Aug 2025 14:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217821;
	bh=c66/yoow2rJUf4gZZMNCdUCnXZEqozf6XRGPYUH/llc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QSKa2bFqQR7GWt4Qlkd4n2KzZIGruBsQZj3kPFaZ+USneMNSba6vVgWB+X/cukqXV
	 tsNhzExy3X4CP+MiowioNCxHH7SZs9roZ/BLkiOrT8SaeQKWHIzw+iUWS7OYOylh9b
	 ggG6haeusAt/rzVxAygbTnqLJtRpW8aGq0VV6B3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emily Deng <Emily.Deng@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 287/523] drm/ttm: Should to return the evict error
Date: Tue, 26 Aug 2025 13:08:17 +0200
Message-ID: <20250826110931.522704226@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emily Deng <Emily.Deng@amd.com>

[ Upstream commit 4e16a9a00239db5d819197b9a00f70665951bf50 ]

For the evict fail case, the evict error should be returned.

v2: Consider ENOENT case.

v3: Abort directly when the eviction failed for some reason (except for -ENOENT)
 and not wait for the move to finish

Signed-off-by: Emily Deng <Emily.Deng@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20250603091154.3472646-1-Emily.Deng@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_resource.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/ttm/ttm_resource.c b/drivers/gpu/drm/ttm/ttm_resource.c
index b325b9264203..e6db512ff581 100644
--- a/drivers/gpu/drm/ttm/ttm_resource.c
+++ b/drivers/gpu/drm/ttm/ttm_resource.c
@@ -113,6 +113,9 @@ int ttm_resource_manager_force_list_clean(struct ttm_bo_device *bdev,
 	}
 	spin_unlock(&glob->lru_lock);
 
+	if (ret && ret != -ENOENT)
+		return ret;
+
 	spin_lock(&man->move_lock);
 	fence = dma_fence_get(man->move);
 	spin_unlock(&man->move_lock);
-- 
2.39.5



