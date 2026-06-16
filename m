Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B50450915;
	Tue, 16 Jun 2026 16:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625847; cv=none; b=LlDfQlOV/k6uNMvW62PqRpBXx/Wmh5JowTp4GR+XCf1i6Erim7PdlFrC3b/1dhynOAUUEktxLM/Ys/wvgLXm6VPFFvXui/EsPYD3v6SbYLb6vS5huXnMQfFxCsZgpyDql0vuIyZ2SlOTEW+kkHTae+b5P0sMxSJfTHK4/n/u4M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625847; c=relaxed/simple;
	bh=cPqSIXISTM0qJZYlhrVAB4P31DFNJ+A3HWz4wuEEJs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UV7+1Q2v7MdSHQi6Mq9ZXinF2KUdCEuZLYC5WTkGd0emjLFQt+0nA4SjC/5f9/oedz/kE5dx0/OME1cegS3EAUQR34BLXIL5deoZTOf3821J+bzKqJsqm6tA1w7s02vs4pnIra7PxK2JmQbG0OiLPCTjkae254W6yVZvfejvWEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nW6cOEz9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nW6cOEz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213DF1F000E9;
	Tue, 16 Jun 2026 16:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625846;
	bh=ycAt/1vqeX6/0mc/eF95ZYX1uKXPvZKvwh6u7w6vThs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nW6cOEz9VzRIULZTgX0xKaAmvTcUnq6za7I75tGRZiVBriKu1hlEg77Ksh0HbNAKl
	 UtSBxGQ17Ht6YwE0+ersu72NPKbc6JXaXaRIGfxONUjjB3fWqx8wLrVEBfkASEAMay
	 ppYSvy4SLSsrqvEDwmsZ3FBF07T4wWJJRPEk15Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.18 219/325] futex/requeue: Prevent NULL pointer dereference in remove_waiter() on self-deadlock
Date: Tue, 16 Jun 2026 20:30:15 +0530
Message-ID: <20260616145109.119916624@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


