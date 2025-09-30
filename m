Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03A7846F;
	Tue, 30 Sep 2025 15:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245767; cv=none; b=o0tM3u36Z3tFaKcbqHs0E4XjEDGQKfDAeD8vVqlZfi/+EmBd73X6WutFPvDWmr0NGJ2o7sozjYiN7SrItJIitjx7zeYVdicQvePU6TrjbWewRCAWvsHWOVMOXfyX5ANsvfePl75h+I8ALii/CFS7rBTg8kS0D0r/7vmLjKTPjmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245767; c=relaxed/simple;
	bh=hcMTHqJvgv54wFaBVKnGDm+i1DdExOIMLTO4V1Wd6uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwSUHJcTAnCNSPbBmp+zUVLKsFXZnr/HssJ2iRpXuu+yLHB/NBAEvkYR9mxxKr/jGxSNnUsKHXzCTbRYLfIlq6m4D+dONJgoBuVYjOOlAA7x9BBQ+9v0huvhQZ+p7kPuguT/yw3qbwDg0suou54UiD+Kb72ltA3hJrPA/IMf4ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wn0uru/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wn0uru/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C54DC4CEF0;
	Tue, 30 Sep 2025 15:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245766;
	bh=hcMTHqJvgv54wFaBVKnGDm+i1DdExOIMLTO4V1Wd6uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wn0uru/UntfonZ+rUYNGvM4Ls7dT4+tfskbaDxjoQgoeJXiVW1wYFUJhrxI28mzn9
	 LN3KLcTPaaUKXFh0PC0p/5rg3QPDsMxZhMaQjjAmTOys+mmn1MTVBB+17OqKwk8FSe
	 7l0zsyxI/Y0WCUJYoL5RnNmhpbuGCQNUgcqhWgmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 43/91] vhost: Take a reference on the task in struct vhost_task.
Date: Tue, 30 Sep 2025 16:47:42 +0200
Message-ID: <20250930143822.961025954@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit afe16653e05db07d658b55245c7a2e0603f136c0 ]

vhost_task_create() creates a task and keeps a reference to its
task_struct. That task may exit early via a signal and its task_struct
will be released.
A pending vhost_task_wake() will then attempt to wake the task and
access a task_struct which is no longer there.

Acquire a reference on the task_struct while creating the thread and
release the reference while the struct vhost_task itself is removed.
If the task exits early due to a signal, then the vhost_task_wake() will
still access a valid task_struct. The wake is safe and will be skipped
in this case.

Fixes: f9010dbdce911 ("fork, vhost: Use CLONE_THREAD to fix freezer/ps regression")
Reported-by: Sean Christopherson <seanjc@google.com>
Closes: https://lore.kernel.org/all/aKkLEtoDXKxAAWju@google.com/
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Message-Id: <20250918181144.Ygo8BZ-R@linutronix.de>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/vhost_task.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
index 8800f5acc0071..5a2116356428f 100644
--- a/kernel/vhost_task.c
+++ b/kernel/vhost_task.c
@@ -100,6 +100,7 @@ void vhost_task_stop(struct vhost_task *vtsk)
 	 * freeing it below.
 	 */
 	wait_for_completion(&vtsk->exited);
+	put_task_struct(vtsk->task);
 	kfree(vtsk);
 }
 EXPORT_SYMBOL_GPL(vhost_task_stop);
@@ -148,7 +149,7 @@ struct vhost_task *vhost_task_create(bool (*fn)(void *),
 		return NULL;
 	}
 
-	vtsk->task = tsk;
+	vtsk->task = get_task_struct(tsk);
 	return vtsk;
 }
 EXPORT_SYMBOL_GPL(vhost_task_create);
-- 
2.51.0



