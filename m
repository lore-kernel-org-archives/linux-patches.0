Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C38351FD0;
	Fri, 21 Nov 2025 13:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732250; cv=none; b=mlPxI+klWVN2Qy5AUXoko9QBMlXTQFgskd2nNX0sJSTRZ4/TOa5RsbzuVV0gkIVSVc4Z8Mg02P2ulD6SiVPbusb+V0rBSqQN3EVR+q3yVAz1BORoe+xTvNReG9tpS7XIChp/vyAxnqHqHcDNoEpW9Bdfm9fC9BvAIT33qkNhmes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732250; c=relaxed/simple;
	bh=NUR/cAj9OKzsy99JIKaz+JUIl3Ic13NTlu+jWdJc+fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wdp74mwS9tdpxPrHEadATE1L9YHotooiirTYPi2yEHuFa9s5BU3RI1zEswd7gWm8jvSuyup2PZplzMpQJCZqfFZ8hH4sGqof/37O4uRDXwj/hHkuCQGxQRUIOFA7ZH4FT/kwVTE4xXx+rOqxB88HrwWgtZHparODKs3Fxa/h5YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0HSH0ZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0HSH0ZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150A9C4CEF1;
	Fri, 21 Nov 2025 13:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732250;
	bh=NUR/cAj9OKzsy99JIKaz+JUIl3Ic13NTlu+jWdJc+fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0HSH0ZB06dJELP8QqqG91V4+r1ZXQktmX6IKCcXHQlu8/n2l2D9RqUuiI+r/olDO
	 7kcF7D4dEGlncnfVMSL6vuAIzDxKpms5Zo/nHJ1YMu99BbFM1CuXzJ0CoU2tzLWxWm
	 w3wT6m8gwb/Xhk7f+gcm/+MTLE9qgmEM47dUI0EU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Philipp Stanner <phasta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/529] drm/sched: Fix race in drm_sched_entity_select_rq()
Date: Fri, 21 Nov 2025 14:05:53 +0100
Message-ID: <20251121130232.937694018@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -531,10 +531,11 @@ void drm_sched_entity_select_rq(struct d
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


