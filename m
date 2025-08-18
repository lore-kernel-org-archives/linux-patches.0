Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985FF3203BA;
	Mon, 18 Aug 2025 13:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523931; cv=none; b=LX92+szx4Y9+HxFgyMF9nw4HDegjV2hhlTYp5+3WDTuwv9P4PY1fRmc2h+15hNsBkkbyk00nvBq7wzBvabMwDaIFRUp+DnD/ZZ3iSPHFOk1IJTNOVlJSV6r2poCH7DFy9uzzRLWylmZcbC/jAZYSo2ozEzd7IxftqoDDpK6lAa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523931; c=relaxed/simple;
	bh=fFWFU7yA1jegddCUFJKghYioP3ekDnP1eJ5G342Qpxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iPxjfUaGyG3FAKWP/i9LWDb0LRM0Y9Uw6zMm2KlZ6nkXQ3po2mg5rGQ0jB5RgzRfLUOTg1i+Tf3qOFXX5KWxwGWKN9Y/R94Ziy+iSzi4jRUdu6bTAcqqxxD7aZE7e03mrVqzNrffc5uVWL1VUi8Oy/PFrCI320TI9tzXeUbDv8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNLpnbt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNLpnbt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D46C4CEEB;
	Mon, 18 Aug 2025 13:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523931;
	bh=fFWFU7yA1jegddCUFJKghYioP3ekDnP1eJ5G342Qpxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNLpnbt6qXsWgdYglqwX+FjIxOSe2bOfeTCp5XinrgMBHiPzWTOjd/9afoc+rmO5W
	 WGptsp5BwCTBH6/euL7BI6uRjBrYnOhlf0HRXrkVHXXc2FiLzCLTjhcN6ht0aVOIKP
	 XfKf7KrHzDzdw8xYJLiV5TEt/R+br5EBk9huVgYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emily Deng <Emily.Deng@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 316/515] drm/ttm: Should to return the evict error
Date: Mon, 18 Aug 2025 14:45:02 +0200
Message-ID: <20250818124510.598324820@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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
index 7e5a60c55813..bb84528276cd 100644
--- a/drivers/gpu/drm/ttm/ttm_resource.c
+++ b/drivers/gpu/drm/ttm/ttm_resource.c
@@ -558,6 +558,9 @@ int ttm_resource_manager_evict_all(struct ttm_device *bdev,
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



