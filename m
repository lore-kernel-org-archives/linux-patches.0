Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132C93590C3;
	Wed,  3 Dec 2025 16:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778869; cv=none; b=DeLeNOrhB6DkXAsoDfpAM9/D0eL+UVYopEBTXilC6dz31g5oIfXxJLnbxR7f4W/zEAtLGBUrnhPlUEW4HN5OeND54ME4+800xhd+TYSO4UlgIettTCVYAlhAckonwwDoUXZmstBPG6xqsJUU2ZdzdxcKqyAlj5ErBKVldpRA0Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778869; c=relaxed/simple;
	bh=ekZOL1Sg7CW79MuF1BNQiA/Lan4UCCDNJm99pH6DKnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwtpe8Ya+db0wNVoWtAHFf51M3btxQqgS4uDR5nk1MdFZTFmb+6F3SfxWteelzCjsCGzksKJnBFwxGRKpXbsgpqgEhcnXJdu2+E1NmPUB+gKiplheIht41pAPeHJoubt3r8tWFiO8oksKeKQqlh78Zbcpu/eNAr2I1gwv9EtcOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Afbd5EV7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Afbd5EV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD3CC116C6;
	Wed,  3 Dec 2025 16:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778868;
	bh=ekZOL1Sg7CW79MuF1BNQiA/Lan4UCCDNJm99pH6DKnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Afbd5EV776V2lcPqQ/hbybWBoS8btxSSQGueA8t9vWAAhzTlpuf0PJjvvtzUSvpqs
	 CKJd6+usU7d5KpDFGVb4JJlp1C4mcZ08FN0tUebIQ3rxw6PrLA+eLuV0b3tl10xqFS
	 Kn9ZZYC0XJ1BVAh+NIpQW/iWN18sPl3SKQmfNKRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Philipp Stanner <phasta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/568] drm/sched: Fix race in drm_sched_entity_select_rq()
Date: Wed,  3 Dec 2025 16:21:27 +0100
Message-ID: <20251203152443.848965682@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -471,10 +471,11 @@ void drm_sched_entity_select_rq(struct d
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


