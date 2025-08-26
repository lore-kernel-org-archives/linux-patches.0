Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230E11B0420;
	Tue, 26 Aug 2025 12:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213064; cv=none; b=dCnShr+b/z07FOGc+R0c4LaHRn6ja0a3MimGRgBGuk09CUZhf6s3e1kY7MmGIvid/xEPSw84AaC0rsBC7YAenZFRqd78CUNt1zNGzyllqlU7OMoZG42YEaLxPb/yqzO/vKi2SAmS1D16F/7NOa4DH5z+ZSucOnz4vlZcVYIoBw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213064; c=relaxed/simple;
	bh=guvfyCVATM+ek7F70VHSEvUEz+NQa8vrAwk2vz6K1sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NaxW+N2RfsDlRfYnwCJil6XPOdRCdqvXHvriFOy6HobC+j8X7XbdbRs+b1aI7yA6hvB388Z/RGBDQRFiKZP9hLZL2o1FHWPAyEpkPajfqj30rNS1hRnr8ug4ZiXnGpJfTFhvOh6ZCYAW9ByS3G+NzX0NWxbswbliNQGWSmMuwa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LVmtH59b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LVmtH59b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81C2C4CEF1;
	Tue, 26 Aug 2025 12:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213064;
	bh=guvfyCVATM+ek7F70VHSEvUEz+NQa8vrAwk2vz6K1sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LVmtH59bPUUZ+41bpXE3Je4aXGfuHpaJDZg2Yq+BMILW6H+Pld4hC6U0g5SLWg/zh
	 iSuA5eqzl5I7IPxmGsw4vQSs4biw1msANODPjELy8cVZAAYqvjoXp0C2UPHi8ymlxD
	 i3S+AreaW7sa//cvvf2yca/2xJv/t3Eo8yOlpfRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emily Deng <Emily.Deng@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 207/587] drm/ttm: Should to return the evict error
Date: Tue, 26 Aug 2025 13:05:56 +0200
Message-ID: <20250826110958.203662771@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 46ff9c75bb12..8f2423a15c71 100644
--- a/drivers/gpu/drm/ttm/ttm_resource.c
+++ b/drivers/gpu/drm/ttm/ttm_resource.c
@@ -437,6 +437,9 @@ int ttm_resource_manager_evict_all(struct ttm_device *bdev,
 	}
 	spin_unlock(&bdev->lru_lock);
 
+	if (ret && ret != -ENOENT)
+		return ret;
+
 	spin_lock(&man->move_lock);
 	fence = dma_fence_get(man->move);
 	spin_unlock(&man->move_lock);
-- 
2.39.5



