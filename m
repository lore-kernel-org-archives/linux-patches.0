Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E89614C585;
	Tue, 20 Feb 2024 21:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463351; cv=none; b=C6mlH2taXaiqLIPh9rWhEBhTU2NZH8yhCvdMgvX2VNUJNh39rahqqkbluLeMk/RC5XsD5dlcq2P3sCpwgVScqPHuLq+CQHOHv7aZKt4/NPyUXorqldjZbAUfSzJUW/ukoPR5JtSjLL0m0dFrQVNEt9SkmumZhDQus7KNxY0+vHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463351; c=relaxed/simple;
	bh=Bhidpc859a3lPHBADZc40P2wji5msKS36NMhUhejWLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DYrgalKet4k9yzKGb7Qy4wmo3oGx6ux/Lu7mZ66UYGb+MgSLCJ7FXXrQ3A7NUGi3nZaDlOl1Glshak2Eby/wD8neZ5oI2RJmkCVSa+grjTNs0JIwLA+tn6GQxDfkAT9wY6TCb9mMZ+4mHyUR9OOdfvGXs3pBf+SnzvhzqhrAAJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBEqPVwk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBEqPVwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F434C433C7;
	Tue, 20 Feb 2024 21:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463351;
	bh=Bhidpc859a3lPHBADZc40P2wji5msKS36NMhUhejWLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBEqPVwk3FzqJZFiR1Rfd96o94Q29+n+QjL1LKjm5RCbWLh4ojVRZ/+vpV264ZaGu
	 y2WVQQSj2CnEdHuid0n1OYQMvIagXvZPNiqUt1qe/s7rbYLZ7WtmRKbpX2mWU8BvQu
	 AGMkkFOe7Otu7gLNba6nctenBfXpDgexzbOBGvAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/331] drm/msm/gem: Fix double resv lock aquire
Date: Tue, 20 Feb 2024 21:52:13 +0100
Message-ID: <20240220205638.124418938@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 03facb39d6c6433a78d0f79c7a146b1e6a61943e ]

Since commit 79e2cf2e7a19 ("drm/gem: Take reservation lock for vmap/vunmap
operations"), the resv lock is already held in the prime vmap path, so
don't try to grab it again.

v2: This applies to vunmap path as well
v3: Fix fixes commit

Fixes: 79e2cf2e7a19 ("drm/gem: Take reservation lock for vmap/vunmap operations")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Acked-by: Christian König <christian.koenig@amd.com>
Patchwork: https://patchwork.freedesktop.org/patch/576642/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_prime.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem_prime.c b/drivers/gpu/drm/msm/msm_gem_prime.c
index 5f68e31a3e4e..0915f3b68752 100644
--- a/drivers/gpu/drm/msm/msm_gem_prime.c
+++ b/drivers/gpu/drm/msm/msm_gem_prime.c
@@ -26,7 +26,7 @@ int msm_gem_prime_vmap(struct drm_gem_object *obj, struct iosys_map *map)
 {
 	void *vaddr;
 
-	vaddr = msm_gem_get_vaddr(obj);
+	vaddr = msm_gem_get_vaddr_locked(obj);
 	if (IS_ERR(vaddr))
 		return PTR_ERR(vaddr);
 	iosys_map_set_vaddr(map, vaddr);
@@ -36,7 +36,7 @@ int msm_gem_prime_vmap(struct drm_gem_object *obj, struct iosys_map *map)
 
 void msm_gem_prime_vunmap(struct drm_gem_object *obj, struct iosys_map *map)
 {
-	msm_gem_put_vaddr(obj);
+	msm_gem_put_vaddr_locked(obj);
 }
 
 struct drm_gem_object *msm_gem_prime_import_sg_table(struct drm_device *dev,
-- 
2.43.0



