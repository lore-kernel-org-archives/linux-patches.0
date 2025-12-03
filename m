Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6472B343D8C;
	Wed,  3 Dec 2025 15:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777478; cv=none; b=GPBBiJuwnXzk/A8oeXCNqYMaFTJb/S4R8y+M0MKBJEwLHj1x/ehZ1t/UO+YXJ204/jFQk7bek0K0thUrTOO1wEYTAZcrdDwwq9D5dGYrGmYfFXXNBn9kNTAhkz1FexpSCt5He3+2yS+OEACqhKmmyBDxAtJKSN2t2oCuOOieYMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777478; c=relaxed/simple;
	bh=R2revpk2iQmIZAGPbwI41WGY4+9POVu/wEytarGLP/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6wrcqA5yhr7i3bT83CIxdUZaSESplRrm8DXK1vFAXqEbl8GcVHGKIUMTEdVrLOo31C/rrh9WAb8KEf3ckUvQlmDz16hZEqadkARP6hboS8sdLL/2sCx0oWHr3Fx22ys/QMan1XHNqKWWzSCau63LBECu25jOIUYYPCPTEcA+Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAHteO97; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAHteO97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E514CC4CEF5;
	Wed,  3 Dec 2025 15:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777478;
	bh=R2revpk2iQmIZAGPbwI41WGY4+9POVu/wEytarGLP/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAHteO97gYf+lj917NlE9+4xETGiLoVDwSAeccUbKRTXOdwoIqHqe8t8lzY314GKI
	 zS5fa6NHkC4ecsTzIrEa3nBAn8+c7HnVPx0MVEXauw2GJAYPWSHb0XqnC4JVVKtcol
	 fBi0ZBpqGZ4GlKH1qdmbzWyv9D6Ysno+cOQRqhXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Philipp Stanner <phasta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/392] drm/sched: Fix race in drm_sched_entity_select_rq()
Date: Wed,  3 Dec 2025 16:23:20 +0100
Message-ID: <20251203152415.953895791@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ adapted lock field name from entity->lock to entity->rq_lock ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -456,10 +456,11 @@ void drm_sched_entity_select_rq(struct d
 		drm_sched_rq_remove_entity(entity->rq, entity);
 		entity->rq = rq;
 	}
-	spin_unlock(&entity->rq_lock);
 
 	if (entity->num_sched_list == 1)
 		entity->sched_list = NULL;
+
+	spin_unlock(&entity->rq_lock);
 }
 
 /**


