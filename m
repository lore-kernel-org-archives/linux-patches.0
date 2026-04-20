Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869D633A70A;
	Mon, 20 Apr 2026 16:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701373; cv=none; b=bn9wpXpb11g9GIg+0Idlj4juwI4bvfhrwTndq7MGv9jPe3WHeOaPwt/LyuvTNdvbGxFWftMwDs/1RaaneNYgbDfHQpjxcrptpQ6mnl58lto1pTqzh2FlzLV9vG7/WEzJt5BVWzI5+3+ZEdHI8ZCHK51Q4Dx6S1sB7Rs6gSdnFpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701373; c=relaxed/simple;
	bh=EvRUKGFd+6162K8alWLBvwu0oufIHSFzsNqge7r3yCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W7TAOdO5ziRQHok0jaCcCd9922dymLI2/h/ORRx8HAlaBxZDHGZ0QmhpVBYqwc2f4RxUeXo5URHbypevUB7dX1+JSx0IY30B15rcOwIjiCSJaYYGx99+YFzgk7xBydONzJ1jD73m+AqKrnoex8hYvt7z6Kt5EC4Ac7wR3ik+v14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRMjQXun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRMjQXun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2BBC19425;
	Mon, 20 Apr 2026 16:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701373;
	bh=EvRUKGFd+6162K8alWLBvwu0oufIHSFzsNqge7r3yCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRMjQXun1Ix9mTrsw8wEYFXUN9QlSdq8n2s9lr/KdBY1ofc5oIe6wptVu8GzdG44g
	 2GxuLUUd5Ue2/X+kJK4vQl511vMuF7qeR/+AD1gBuTOgHnjiokkhRClHsOpt4va+Cx
	 Go87jrkDrRypkVBAg8KnyTUIVwdeSQzy4PO5i9sA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/162] drm/vc4: Fix memory leak of BO array in hang state
Date: Mon, 20 Apr 2026 17:41:17 +0200
Message-ID: <20260420153928.659495926@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit f4dfd6847b3e5d24e336bca6057485116d17aea4 ]

The hang state's BO array is allocated separately with kzalloc() in
vc4_save_hang_state() but never freed in vc4_free_hang_state(). Add the
missing kfree() for the BO array before freeing the hang state struct.

Fixes: 214613656b51 ("drm/vc4: Add an interface for capturing the GPU state after a hang.")
Reviewed-by: Melissa Wen <mwen@igalia.com>
Link: https://patch.msgid.link/20260330-vc4-misc-fixes-v1-2-92defc940a29@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_gem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/vc4/vc4_gem.c b/drivers/gpu/drm/vc4/vc4_gem.c
index be9c0b72ebe86..373d310c7b6a5 100644
--- a/drivers/gpu/drm/vc4/vc4_gem.c
+++ b/drivers/gpu/drm/vc4/vc4_gem.c
@@ -60,6 +60,7 @@ vc4_free_hang_state(struct drm_device *dev, struct vc4_hang_state *state)
 	for (i = 0; i < state->user_state.bo_count; i++)
 		drm_gem_object_put(state->bo[i]);
 
+	kfree(state->bo);
 	kfree(state);
 }
 
-- 
2.53.0



