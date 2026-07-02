Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D4C35F8C9;
	Thu,  2 Jul 2026 16:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010284; cv=none; b=VZFYXLWrkcXOwoxqazafg8WQ7fOX7o4MIQucQlNech/al3W270X8V290AI9+Kz6a7p3RNRcivMPRZnYqGHg4jlnu/hiduAHpPwRnBxMEivf/KXupI+f6Bhm0X4UcUggVMY7rNCPY4G3TnvCwPEv0tNBjNRjSO6dU/lK4OcDLeMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010284; c=relaxed/simple;
	bh=9KNYRO28VzrCTdJHLM5+9zFUwdI5sfMSe7lT5Fv5i9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvqS8v7ifKfbEYY/335kcWFpUPutx9d86NXd3SPXWpzurbLEutu/xQ11R+KB8kcsuu1JrQbIKJ0Aepj7RmxbpYW394nQo7BcU2/YheF8/AbbprAixTuiigosQHTw+OE9Q/ju8bKddIg94ITYKeO1SloPXDM636jcw2NF+O9AlDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZDQFdD9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZDQFdD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB7C1F00A3A;
	Thu,  2 Jul 2026 16:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010282;
	bh=4cGAG1cI0XicQ3Qw7vg0/K+v1l05cH4K5CMa6c5nzgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VZDQFdD9RzVrPCqzcBLYejT+O25S/9Nfg+5VyxlDBpwN/L+UyfmHePWzUgX+e1YFf
	 ae14Guk+SYh8iZ29OqlcZetXFpv4T/GiiMVQo1cn0rxipKgElGfeTNiRSx9eb6j1zP
	 Idrmp/lvt3qfcpps7edV/tm1LXuESQJgE60AdEwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/204] futex/requeue: Prevent NULL pointer dereference in remove_waiter() on self-deadlock
Date: Thu,  2 Jul 2026 18:18:26 +0200
Message-ID: <20260702155119.684087884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

From: Ji'an Zhou <eilaimemedsnaimel@gmail.com>

[ Upstream commit 74e144274af39935b0f410c0ee4d2b91c3730414 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex/requeue.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/futex/requeue.c
+++ b/kernel/futex/requeue.c
@@ -633,6 +633,12 @@ retry_private:
 			continue;
 		}
 
+		/* Self-deadlock: non-top waiter already owns the PI futex. */
+		if (rt_mutex_owner(&pi_state->pi_mutex) == this->task) {
+			ret = -EDEADLK;
+			break;
+		}
+
 		ret = rt_mutex_start_proxy_lock(&pi_state->pi_mutex,
 						this->rt_waiter,
 						this->task);


