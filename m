Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4BE31E10E;
	Mon, 18 Aug 2025 13:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522362; cv=none; b=gQEyDyLJpTrEwMa36vTQ16Qxlm3eLBSaY4P0Vd2DFFX3y7n37kt9YN3DL+uNz/7ebe0aba6sRtuzJSCnm/SZEWK4vVkqpkiPA4dkyNp+/cXqcXDlj6VDasC8Y8qtyxXpmC3TMZnSQkLhYKU2AU4LFSjQ2wu+dx/eMgC115PoPnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522362; c=relaxed/simple;
	bh=QnAW6/JExWKwhTpxrkxg2sC6dtpk/fB/lAfzbjQa20w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CYRTLiGAscYw5xQfNvqPBCktt/mq5OlQG8QvCZiDADJMd1xSFXk1ZUkDykNemndBio/VgrxzSkx53kJtgd8KNgK7FQu+UJXHTQhz1M90v0bMtP4qG+mfC4VCSxgcLgm3Glf8/w6qC71HGooSAcnC9Ugda2SJ0X6u33/LHOOpFzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4dPIeTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4dPIeTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD33CC113D0;
	Mon, 18 Aug 2025 13:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522362;
	bh=QnAW6/JExWKwhTpxrkxg2sC6dtpk/fB/lAfzbjQa20w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4dPIeTA2a0Vpuuxayb/x7UZLYl3gLVWGjCs+vDepXMnTSGVf338sV+0l4LXInTeU
	 nwrU5FWazDamhy0AfUil3y6sfSo+wLHe6ngiay3YalNXqSuVSK50yTmm1fMfHPydq7
	 jFOg8w4rOAO1y8BR1/CD8tcOpxFN+z/Ism+muDpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emily Deng <Emily.Deng@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 261/444] drm/ttm: Should to return the evict error
Date: Mon, 18 Aug 2025 14:44:47 +0200
Message-ID: <20250818124458.614428070@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6d764ba88aab..53f258f39ceb 100644
--- a/drivers/gpu/drm/ttm/ttm_resource.c
+++ b/drivers/gpu/drm/ttm/ttm_resource.c
@@ -501,6 +501,9 @@ int ttm_resource_manager_evict_all(struct ttm_device *bdev,
 		cond_resched();
 	} while (!ret);
 
+	if (ret && ret != -ENOENT)
+		return ret;
+
 	spin_lock(&man->move_lock);
 	fence = dma_fence_get(man->move);
 	spin_unlock(&man->move_lock);
-- 
2.39.5



