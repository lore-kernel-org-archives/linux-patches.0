Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4B34C97;
	Tue, 11 Nov 2025 00:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822404; cv=none; b=UasS5LyKf2Wu9IGhNeV1U/MfAQfGk916wPIuW7tJpLp+ltS0U1ELiHXOKDu2/61EfowG/XAqY4la8dDznPdohUbNVNqiWFEm8Lh7NaI+0CvssE9HHB0A2h71v7W+nHehcvy9GF3GOkL+ccj6Kd7HGyswDltBfLRXCaKqLiRoSSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822404; c=relaxed/simple;
	bh=JsVEzLrH0rkkkzI8oss3/dNpmy95IXtwFGPQYEH3PEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDBdDtsflrJic76YEAS3Fxk7G/2rm/xSzJVR8P0OFFr5C8ocmy+m2ffVF0xkQdlBcJ1dT5EO4KZVZz8BwM+x9JkJqKu7+SREiFszlSU1mWE/pNGm2AAYBz6WSbbXPGi7+/JxXx4fq7jdvtEgmVboZbFERFuNmcbu53wFvCPDUWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvRFj63D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvRFj63D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1B4C19421;
	Tue, 11 Nov 2025 00:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822404;
	bh=JsVEzLrH0rkkkzI8oss3/dNpmy95IXtwFGPQYEH3PEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvRFj63DdZLOZ4gIRDGLNZBpDd9S4MGtZeCldH3oklHak1AEdT0p3sLN84JQloQm2
	 aCkpv1d6oHa9LgBzYF4FzKs2IEfXU/jOMNn0ySFETgauPhbzjEPbR5ga7mWHFpyEAr
	 x+yAIk2q6TC38L7lVGIdwUIBvxOfVdOZUrCqSQ/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Philipp Stanner <phasta@kernel.org>
Subject: [PATCH 6.17 101/849] drm/sched: Fix race in drm_sched_entity_select_rq()
Date: Tue, 11 Nov 2025 09:34:31 +0900
Message-ID: <20251111004538.847593803@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Stanner <phasta@kernel.org>

commit d25e3a610bae03bffc5c14b5d944a5d0cd844678 upstream.

In a past bug fix it was forgotten that entity access must be protected
by the entity lock. That's a data race and potentially UB.

Move the spin_unlock() to the appropriate position.

Cc: stable@vger.kernel.org # v5.13+
Fixes: ac4eb83ab255 ("drm/sched: select new rq even if there is only one v3")
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Link: https://patch.msgid.link/20251022063402.87318-2-phasta@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -553,10 +553,11 @@ void drm_sched_entity_select_rq(struct d
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


