Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532FF158A17;
	Tue, 23 Jul 2024 18:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759718; cv=none; b=KRwBwirx7yRPvYPBze41WVme2IV8qVmw/bzTD7F67uloLLOK5lncGb0BXIwW1gnosrk6y9PPM91GXWNhZGKUntfWCjjudRewftkOFGFGZJoDkB+HYCgnZ2t+/YyKvSHRHb7fj838lCh7dZl0hr6wtTVmZpkYA8mX5qcoObcjP+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759718; c=relaxed/simple;
	bh=QZZ9q+4YpSgPZ9J++LhtjGIj0vXwJLAxAico0/UeJeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEH+txaVXogd2iiJhSZQgFdHlEl0XRwhp0vLIV68VnyfmnXedyFs7WL9CbLjIKEdz+GgUG8q4b4u7Eab1bOhpOHfJHwZaEtLVwJnMyrullPaYc4NKf3tXeHWYjoj/c8eiaepuNQdSFzGgDDw/8w9iLCQZ5uxmC/5qiFGfAUMstE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kzrmHKSX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kzrmHKSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF06C4AF0E;
	Tue, 23 Jul 2024 18:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759718;
	bh=QZZ9q+4YpSgPZ9J++LhtjGIj0vXwJLAxAico0/UeJeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kzrmHKSX4XY12KFI7qV5IdpIwdnlURuvxnWOaYT4/AaFz6pXNRiP4fsgDWWcdS9WH
	 +2A+BAqldAfdgrs3X2mhxUDppWy27gIkeyB96tSDfa5FFUtdN3aL3EGUAH7TrWHqNG
	 +hO+1Nc796HqPkjnOLhR+GJ/wlGNFwBcZBx4fNwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/129] drm/radeon: check bo_va->bo is non-NULL before using it
Date: Tue, 23 Jul 2024 20:24:13 +0200
Message-ID: <20240723180408.849934773@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

From: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>

[ Upstream commit 6fb15dcbcf4f212930350eaee174bb60ed40a536 ]

The call to radeon_vm_clear_freed might clear bo_va->bo, so
we have to check it before dereferencing it.

Signed-off-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_gem.c b/drivers/gpu/drm/radeon/radeon_gem.c
index 3fec3acdaf284..27225d1fe8d2e 100644
--- a/drivers/gpu/drm/radeon/radeon_gem.c
+++ b/drivers/gpu/drm/radeon/radeon_gem.c
@@ -641,7 +641,7 @@ static void radeon_gem_va_update_vm(struct radeon_device *rdev,
 	if (r)
 		goto error_unlock;
 
-	if (bo_va->it.start)
+	if (bo_va->it.start && bo_va->bo)
 		r = radeon_vm_bo_update(rdev, bo_va, bo_va->bo->tbo.resource);
 
 error_unlock:
-- 
2.43.0



