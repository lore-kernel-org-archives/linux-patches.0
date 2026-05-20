Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F1D2BE02A;
	Wed, 20 May 2026 16:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295151; cv=none; b=FJtFG0pcntUP2Dr/1zSnVJQyXHZU0CIKo4KXYrs/2NAJwMOJVgNn0aALa+R+o10CipyBhFutODQWfhIvW2F7fqDzgxpC0k7BdIcS+/CDbTNZkLfxvu/WTvSLKCGcoYp8ktU8l39Rji8qwxxZVdtESx4mixIJ+sGdHHKegR4y7tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295151; c=relaxed/simple;
	bh=1R7GXlqgaOSTL8GEQotDj0wq7qcBCpu4cmkTFstFx+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GlOhbmt1FxUtS7PmcqrnF2oGFK81BMY1B/N6Vy4FraDHeA5sVsKSKLihnVl8f8QlsGNP/zM0xEt5mJAM8/+Can8LzrehoY5F3HoZ2f4cOKoNslti776OJQguzyrHGV2JpEhxSw+JGVJBW358QLogEofUFYynNBGePjhNHiX7IEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0MDOTG+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0MDOTG+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952B01F00893;
	Wed, 20 May 2026 16:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295148;
	bh=00jase/Rln7E+zq5cj8CEaibyKtPCJirXmrj0TLTZts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p0MDOTG+r93hDmB68XCHa1cReuGfFpkA1hRzNd62JxdjsHyPN3HVfsv5/ZGsC0FwE
	 OMlWwhAIK5UulFNzL49O+dlEFsPyGT6V+o7+BdXkYSaA+7XKt0TzWY0TpO1NQdQzQD
	 W4DPpGXt3Unog/gyAbbj0cTBKr7zCo0CdJRG2XT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	YiPeng Chai <YiPeng.Chai@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0310/1146] drm/amd/ras: Remove redundant NULL check in pending bad-bank list iteration
Date: Wed, 20 May 2026 18:09:20 +0200
Message-ID: <20260520162155.218679452@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit fd490bb9e1054705e1b35e6f321cdc713e0c7348 ]

ras_umc_log_pending_bad_bank() walks through a list of pending ECC
bad-bank entries. These entries are saved when a bad-bank error cannot
be processed immediately, for example during a GPU reset.

Later, this function iterates over the pending list and retries logging
each bad-bank error. If logging succeeds, the entry is removed from the
list and the memory for that node is freed.

The loop uses list_for_each_entry_safe(), which already guarantees that
ecc_node points to a valid list entry while the loop body is executing.

Checking "ecc_node &&" inside the loop is therefore unnecessary and
redundant.

Fixes the below:
drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras_umc.c:225 ras_umc_log_pending_bad_bank() warn: variable dereferenced before check 'ecc_node' (see line 223)

Fixes: 7a3f9c0992c4 ("drm/amd/ras: Add umc common ras functions")
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: YiPeng Chai <YiPeng.Chai@amd.com>
Cc: Tao Zhou <tao.zhou1@amd.com>
Cc: Hawking Zhang <Hawking.Zhang@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: YiPeng Chai <YiPeng.Chai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/ras/rascore/ras_umc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/ras/rascore/ras_umc.c b/drivers/gpu/drm/amd/ras/rascore/ras_umc.c
index 2abe8553e479e..4fff0b3af75c1 100644
--- a/drivers/gpu/drm/amd/ras/rascore/ras_umc.c
+++ b/drivers/gpu/drm/amd/ras/rascore/ras_umc.c
@@ -222,7 +222,7 @@ int ras_umc_log_pending_bad_bank(struct ras_core_context *ras_core)
 	mutex_lock(&ras_umc->pending_ecc_lock);
 	list_for_each_entry_safe(ecc_node,
 		tmp, &ras_umc->pending_ecc_list, node){
-		if (ecc_node && !ras_umc_log_bad_bank(ras_core, &ecc_node->ecc)) {
+		if (!ras_umc_log_bad_bank(ras_core, &ecc_node->ecc)) {
 			list_del(&ecc_node->node);
 			kfree(ecc_node);
 		}
-- 
2.53.0



