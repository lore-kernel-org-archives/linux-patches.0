Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51C726FA40;
	Tue, 25 Mar 2025 12:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906387; cv=none; b=GCod6SWljlZoSoImY2/4/T/dUwHP05/sCC/I8HtF+g2dWyXy8z04S2tc6TS36nDM6z4ZhcbEcCKfLyK2TYmlmOaA37qA/F64zvF/1iupegSGv1NJVfURZcYpOLo/XGeBrPW/vdWjk69ZDs46rzzUCe2Dr/qhV6vmfhIqo9J/yZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906387; c=relaxed/simple;
	bh=3or3sOsK7q+0BQYFeb1Az3bUc23d6u3k9SbCDWcTpTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewTG8Ge6XrBEJqypx33ANqFGEBNHdZL8y/dmxtf/+L4XkzsenRK6vABekkwDP72AaR5zUJVHok3pO0YnEvFwfM+dDKoTf+R2mlKkhO2GIBmtDepOV35tS4P3QLqx/5lv2brbQ23E1AfVcf7mRMxQxVjzoZvGu26Xrgu67b5PmFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scOa1tWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scOa1tWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7616DC4CEE4;
	Tue, 25 Mar 2025 12:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906387;
	bh=3or3sOsK7q+0BQYFeb1Az3bUc23d6u3k9SbCDWcTpTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scOa1tWWpSY2W9WO15SOeqRQmsbiagh46VWjWFI33zpMI8OVRTfuzB/BHTnnX3Fg4
	 p5u04EfH1xmInUmMLdTwnb41dlgjT6joGlOhnSNF4sQIYcApjXqp8NDL1cIpzNlb+h
	 V5kZI/obyUAzZYa1VWrkALws79H803YdegS43+g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	qianyi liu <liuqianyi125@gmail.com>,
	Philipp Stanner <phasta@kernel.org>
Subject: [PATCH 6.12 090/116] drm/sched: Fix fence reference count leak
Date: Tue, 25 Mar 2025 08:22:57 -0400
Message-ID: <20250325122151.511972112@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: qianyi liu <liuqianyi125@gmail.com>

commit a952f1ab696873be124e31ce5ef964d36bce817f upstream.

The last_scheduled fence leaks when an entity is being killed and adding
the cleanup callback fails.

Decrement the reference count of prev when dma_fence_add_callback()
fails, ensuring proper balance.

Cc: stable@vger.kernel.org	# v6.2+
[phasta: add git tag info for stable kernel]
Fixes: 2fdb8a8f07c2 ("drm/scheduler: rework entity flush, kill and fini")
Signed-off-by: qianyi liu <liuqianyi125@gmail.com>
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250311060251.4041101-1-liuqianyi125@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -259,9 +259,16 @@ static void drm_sched_entity_kill(struct
 		struct drm_sched_fence *s_fence = job->s_fence;
 
 		dma_fence_get(&s_fence->finished);
-		if (!prev || dma_fence_add_callback(prev, &job->finish_cb,
-					   drm_sched_entity_kill_jobs_cb))
+		if (!prev ||
+		    dma_fence_add_callback(prev, &job->finish_cb,
+					   drm_sched_entity_kill_jobs_cb)) {
+			/*
+			 * Adding callback above failed.
+			 * dma_fence_put() checks for NULL.
+			 */
+			dma_fence_put(prev);
 			drm_sched_entity_kill_jobs_cb(NULL, &job->finish_cb);
+		}
 
 		prev = &s_fence->finished;
 	}


