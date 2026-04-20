Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F0333BBA7;
	Mon, 20 Apr 2026 15:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700266; cv=none; b=W84X1hN/sqfDgDyztY+J+2rS0AzhYWQwQ0cS9gjYodOpk/SQWRtQfxEb++7q7Cvib4LdHmp9qFHfVHy03L1LfhWPp1/zwQfsTKuLUjes7vqgLoDgABzERRRe6q6OFOXchg6w+0Upjmst0yMNik+1frsJvbK7HMvB6GRcJk0PEHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700266; c=relaxed/simple;
	bh=ERC0qNIvvo1KgYZkIWsRJd3/1KC/0N4t0/ry/UaIfrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zz1rDzL4BwZDovbmteriiph2kBzaL3tKVuGZr0LSp4m1bWN4Z37KLozNC2y72mXFJopv+8DTdejdNbYLaNSsF8U/MOvIkcYu56FB5YLL9s7wuU5DokpKdSaKIwxSGQaw6HOAw0YOgonpxAc0F8cSlzvKhITkUXh3GCgo4j0jQI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BueaQSXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BueaQSXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380BEC19425;
	Mon, 20 Apr 2026 15:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700266;
	bh=ERC0qNIvvo1KgYZkIWsRJd3/1KC/0N4t0/ry/UaIfrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BueaQSXzyrslh0xdgLd8CFqi1z6x36AxqVx92VbNe02DKiKAuguN/4TzHQZgpUTSV
	 ExTv3cJY/xKVd23+rCJkp+156pZyMiwaH17EdEW4fFakHIuTtSrGqByNxvJrqboHZa
	 nAKBbwry0e+Koe+2wQEbWnOG5M1gZ1tMtbS9rRPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 073/220] drm/vc4: Fix memory leak of BO array in hang state
Date: Mon, 20 Apr 2026 17:40:14 +0200
Message-ID: <20260420153936.666780594@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index ab16164b5edaf..0562f78e28357 100644
--- a/drivers/gpu/drm/vc4/vc4_gem.c
+++ b/drivers/gpu/drm/vc4/vc4_gem.c
@@ -62,6 +62,7 @@ vc4_free_hang_state(struct drm_device *dev, struct vc4_hang_state *state)
 	for (i = 0; i < state->user_state.bo_count; i++)
 		drm_gem_object_put(state->bo[i]);
 
+	kfree(state->bo);
 	kfree(state);
 }
 
-- 
2.53.0



