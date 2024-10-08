Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F431DE3A2;
	Tue,  8 Oct 2024 12:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391049; cv=none; b=IUQoZ8WtT/kaFMZBr6mzv/L3q8zJFDcxYlSFGbhs0qrpqpv3DeGFT9ndxae0a+wcD5jApMvQ9MQB+KumiAv0hW2AQzmrdk2hbx8rGFFDZrw2sGqczX7SMzdrN74S0lWrRM8dSs2vGR1YTISXweHtMuEnmfSBkLKd8qVL4XFVzss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391049; c=relaxed/simple;
	bh=fGie67DVEQdyX6oHw0Bqe0CwD0OpNE17WVae2c071OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mAJ3VnHS2ijY8pZAZIOqLXAG/6D2106jEvNobdVwr9eZPhO+1p7VnxBN/vo+T047dPZ8q0j0utU5NnFifj05U0+H+76AE5ZSJr1Kj0RKtsTUmGmk5LEXOXdXFgXt7CXQ+nP/IW4WmbDXiW0yoekPa60fXMDaUhFreuk0ZCpm+gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qyBdriky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qyBdriky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1EBC4CEC7;
	Tue,  8 Oct 2024 12:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391048;
	bh=fGie67DVEQdyX6oHw0Bqe0CwD0OpNE17WVae2c071OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qyBdrikyNkg1YQMSqKWa2cvedhVzsZlaQdEbUY081tO9o7bZCpPIKExkWSU6AyBCy
	 DGWrBrbVrG8uGB2g4E0K97+Fw5u8tVBDJebwnQLXixaHFoRdrvNldOxKdyyDZnuakL
	 IXv1ghETjc0fv96qtMYL3zypcM4qxLV1VSicd30Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Subject: [PATCH 6.10 475/482] drm/sched: revert "Always increment correct scheduler score"
Date: Tue,  8 Oct 2024 14:08:58 +0200
Message-ID: <20241008115707.204584994@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit abf201f6ce14c4ceeccde5471bdf59614b83a3d8 upstream.

This reverts commit 087913e0ba2b3b9d7ccbafb2acf5dab9e35ae1d5.

It turned out that the original code was correct since the rq can only
change when there is no armed job for an entity.

This change here broke the logic since we only incremented the counter
for the first job, so revert it.

Signed-off-by: Christian König <christian.koenig@amd.com>
Acked-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240930131451.536150-1-christian.koenig@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -586,6 +586,7 @@ void drm_sched_entity_push_job(struct dr
 	ktime_t submit_ts;
 
 	trace_drm_sched_job(sched_job, entity);
+	atomic_inc(entity->rq->sched->score);
 	WRITE_ONCE(entity->last_user, current->group_leader);
 
 	/*
@@ -613,7 +614,6 @@ void drm_sched_entity_push_job(struct dr
 		rq = entity->rq;
 		sched = rq->sched;
 
-		atomic_inc(sched->score);
 		drm_sched_rq_add_entity(rq, entity);
 		spin_unlock(&entity->rq_lock);
 


