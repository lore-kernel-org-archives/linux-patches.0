Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0128522541C;
	Mon, 20 Apr 2026 15:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700739; cv=none; b=ilnyCbb/PjZw67sfnRy6UwnGITlXhmz+LOpDNluL3hjtKyadpbuBJNCvSn1ls0Jc762wlWApF93nC3doTiH/2gSLe9cT3xx54PAZtYNObYE6fc23VAGj8qJNC4w+8pyEL0fatfzOXNUqpkK7qhszwgbFzQ9cAMcx91w9iNQQr1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700739; c=relaxed/simple;
	bh=r6cQgWd/4gYePcdE1yXGZFi+OQCbo9XXk9u92UVCKlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DnssBi4CD3vrHCYT7s248NbfZiRjOwCSVEx83xZUNqRTq9n22qy03/1Je7hmt7B+IDgnSamb41uEFnjEkSj+qZMpAdPvPnFnhJp5OIrdV/aa+Vjs6aA3LY8GCutpu4LhzYqAJ6QlHs+7NA0n0X7qRC76M/5XZDPw0pyZsvkPuqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oAQC5BAD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oAQC5BAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD78C19425;
	Mon, 20 Apr 2026 15:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700738;
	bh=r6cQgWd/4gYePcdE1yXGZFi+OQCbo9XXk9u92UVCKlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oAQC5BADskx6V6iYiYBJvvaao+/DkSYmF9tsoZhC8IYYjrf+AMHdMjutI24KzD6cz
	 33cDOkxgFbCAUhxAiLRJ1/VrywV1Q7zIHKBexpX/0Ubfi3kXbnZIGEUMIZZ5dUd/kU
	 5St3dANOBtLlykoVvc1Fl+2yBmz/popGdF5YALSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 067/198] drm/vc4: Fix a memory leak in hang state error path
Date: Mon, 20 Apr 2026 17:40:46 +0200
Message-ID: <20260420153938.024310711@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 9525d169e5fd481538cf8c663cc5839e54f2e481 ]

When vc4_save_hang_state() encounters an early return condition, it
returns without freeing the previously allocated `kernel_state`,
leaking memory.

Add the missing kfree() calls by consolidating the early return paths
into a single place.

Fixes: 214613656b51 ("drm/vc4: Add an interface for capturing the GPU state after a hang.")
Reviewed-by: Melissa Wen <mwen@igalia.com>
Link: https://patch.msgid.link/20260330-vc4-misc-fixes-v1-3-92defc940a29@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_gem.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_gem.c b/drivers/gpu/drm/vc4/vc4_gem.c
index 6238630e46793..6887631f2d8be 100644
--- a/drivers/gpu/drm/vc4/vc4_gem.c
+++ b/drivers/gpu/drm/vc4/vc4_gem.c
@@ -170,10 +170,8 @@ vc4_save_hang_state(struct drm_device *dev)
 	spin_lock_irqsave(&vc4->job_lock, irqflags);
 	exec[0] = vc4_first_bin_job(vc4);
 	exec[1] = vc4_first_render_job(vc4);
-	if (!exec[0] && !exec[1]) {
-		spin_unlock_irqrestore(&vc4->job_lock, irqflags);
-		return;
-	}
+	if (!exec[0] && !exec[1])
+		goto err_free_state;
 
 	/* Get the bos from both binner and renderer into hang state. */
 	state->bo_count = 0;
@@ -190,10 +188,8 @@ vc4_save_hang_state(struct drm_device *dev)
 	kernel_state->bo = kcalloc(state->bo_count,
 				   sizeof(*kernel_state->bo), GFP_ATOMIC);
 
-	if (!kernel_state->bo) {
-		spin_unlock_irqrestore(&vc4->job_lock, irqflags);
-		return;
-	}
+	if (!kernel_state->bo)
+		goto err_free_state;
 
 	k = 0;
 	for (i = 0; i < 2; i++) {
@@ -285,6 +281,12 @@ vc4_save_hang_state(struct drm_device *dev)
 		vc4->hang_state = kernel_state;
 		spin_unlock_irqrestore(&vc4->job_lock, irqflags);
 	}
+
+	return;
+
+err_free_state:
+	spin_unlock_irqrestore(&vc4->job_lock, irqflags);
+	kfree(kernel_state);
 }
 
 static void
-- 
2.53.0



