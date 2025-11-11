Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5FB4C97;
	Tue, 11 Nov 2025 00:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822684; cv=none; b=TthAHblPjbvUdq4loiwkaNt0limZxR9zklQp2ufP5DUselvWZIhRQhP7l0rCnT8edbp/gkAclC4OiCIWdF7Tjv7n2g1gz7hQQtykOWlasRHnfeSLlZVA9ggIv1G8aotmJoZvheHRbfEJ9U0TguJ3SlW9kX0GcsqVkE/ELBodwEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822684; c=relaxed/simple;
	bh=Rh7LKzMXzjCNGVffEXQN/Mrd1C67EyLxdiWhGpWbO50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fr1xKdYUznbkhwEGHk2BcUNo2DNcPCCyn5nh32P0ESydUTlcv7lbQZyBwMlKGQ9V8hZvhs0DSZXt3ymxxeyRzWCGcewLiIyMd1jKaovcmIYF70RIxFh1530skmJM2Ulu6HAmUK2CLky1oqiQI5vtFl485TTaey3TkSK+ldOt4yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0MJHZTwC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0MJHZTwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE57C19422;
	Tue, 11 Nov 2025 00:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822684;
	bh=Rh7LKzMXzjCNGVffEXQN/Mrd1C67EyLxdiWhGpWbO50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0MJHZTwCTzwR3bv15HDOeltmbCz938hgWlvaIs84g2BZ2XaF3hBnCcKXJIa9Z59K7
	 oiNiaE0uwNOm/Q4bCI69cncbGwj+72yY8JQpEvEuXU3fqu7YKfiRO4Xc8joZOJlrns
	 eyoBOY0FtsEQECXTGFS+yfUPlTFkYMr9X+jwfErY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Philipp Stanner <phasta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/565] drm/sched: Fix race in drm_sched_entity_select_rq()
Date: Tue, 11 Nov 2025 09:39:01 +0900
Message-ID: <20251111004528.880167215@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Stanner <phasta@kernel.org>

[ Upstream commit d25e3a610bae03bffc5c14b5d944a5d0cd844678 ]

In a past bug fix it was forgotten that entity access must be protected
by the entity lock. That's a data race and potentially UB.

Move the spin_unlock() to the appropriate position.

Cc: stable@vger.kernel.org # v5.13+
Fixes: ac4eb83ab255 ("drm/sched: select new rq even if there is only one v3")
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Link: https://patch.msgid.link/20251022063402.87318-2-phasta@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -558,10 +558,11 @@ void drm_sched_entity_select_rq(struct d
 		drm_sched_rq_remove_entity(entity->rq, entity);
 		entity->rq = rq;
 	}
-	spin_unlock(&entity->lock);
 
 	if (entity->num_sched_list == 1)
 		entity->sched_list = NULL;
+
+	spin_unlock(&entity->lock);
 }
 
 /**


