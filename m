Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15CF42B74A;
	Tue, 16 Jun 2026 15:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624252; cv=none; b=k4i/yBl07N8jEdYYaLNHAmqXFUWEgrsYzjsmJ2gEblvECMbksZyk1xMXsjwnkTPOyaCMk5kHCiHSLGVmlfVOVU25zlyhRuiP7s0cspQShCojMWlT9aY+bkI4B8BvjwYx3XCAUel9hRqqjCAQkEoEleTV+6njRXRAMPCQLz2UU18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624252; c=relaxed/simple;
	bh=PvVU5T+Rr0XIM3HtmScMCd6F8h0Cv1vbQBZsEbm68oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISlDAdcWo7ii0HeN3qqtv/3nvLD28010tJOv9fSjwX1N54K213HuI1UAct7ThY4cNpr/xogQ1LaFGdIYfe+SEm7YHxF9r5O8wYU4iJcyHpzWs/0Kba9+mrpjbXXLkq4qcNXfLbu5rK2gjCgsf8K6L9ebO1E3jCfp3LDOyBeTk6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ci3CwE4C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ci3CwE4C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CB81F000E9;
	Tue, 16 Jun 2026 15:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624251;
	bh=uBcjF0gRal8ffQdCPB7PPBOUOI+TRonS6Qj7fv9Ld2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ci3CwE4CL5OGq6UkuNLAdVqFHCU3OZtcG13cnxPs3SXxkJQtkycOM351d9fkV5XJE
	 ln9IEaXOeAAQCnh9ylfF7W0hVFSSWKAItmpW/d8/zAEhFmwBYdx7WlLI+UoqQ5zfTu
	 tDNe6c2+uT/aLppelonTSVvUHPf+W+VDzu/ycXc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.0 268/378] futex/requeue: Prevent NULL pointer dereference in remove_waiter() on self-deadlock
Date: Tue, 16 Jun 2026 20:28:19 +0530
Message-ID: <20260616145124.214621466@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ji'an Zhou <eilaimemedsnaimel@gmail.com>

commit 74e144274af39935b0f410c0ee4d2b91c3730414 upstream.

When FUTEX_CMP_REQUEUE_PI requeues a non-top waiter that already owns the
target PI futex, task_blocks_on_rt_mutex() returns -EDEADLK before setting
waiter->task.

The subsequent remove_waiter() in rt_mutex_start_proxy_lock() dereferences
the NULL waiter->task, causing a kernel crash.

Add a self-deadlock check for non-top waiters before calling
rt_mutex_start_proxy_lock(), analogous to the top-waiter check in
futex_lock_pi_atomic().

Fixes: 3bfdc63936dd4773109b7b8c280c0f3b5ae7d349 ("rtmutex: Use waiter::task instead of current in remove_waiter()")
Signed-off-by: Ji'an Zhou <eilaimemedsnaimel@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex/requeue.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/futex/requeue.c
+++ b/kernel/futex/requeue.c
@@ -643,6 +643,12 @@ retry_private:
 				continue;
 			}
 
+			/* Self-deadlock: non-top waiter already owns the PI futex. */
+			if (rt_mutex_owner(&pi_state->pi_mutex) == this->task) {
+				ret = -EDEADLK;
+				break;
+			}
+
 			ret = rt_mutex_start_proxy_lock(&pi_state->pi_mutex,
 							this->rt_waiter,
 							this->task);


