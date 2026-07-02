Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D68E33D4F0;
	Thu,  2 Jul 2026 16:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010783; cv=none; b=Q5Bc39fiEzZ6jVIA+dyu4UylO4B6IRMuwL14RjdRNgii6+n/3fJk9Al5TEDwR4pCz6MXpcdhd0aBu26AFPEVXtZA0+h5khL9JixE9BQ73petyqNh6FaVT3estz90G9g6At8S8CK/GAq6kVnkHEnAk0xeXCQ27Qxvr6W+/HZoMtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010783; c=relaxed/simple;
	bh=8ESlP4+IJsk+qlTJzETUeYRZHgOTRYoFQd3zXH246Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlJex80jGTY7V1KduElB4Drx8CN8Ojce2Ods3R7ZvLSALW6/LRBMswV5H0W4xhEf6V4M/2SpvGvfg4iDe6HW+kTrEOpGwcPVKKEYW28rYKRuNOC74M0UQ7ME4zch4y+94OGblTblf0kRj9nlZVUh79JnK36MhQYk7WFt3IQQDKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HS+W47SZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HS+W47SZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9333F1F00A3A;
	Thu,  2 Jul 2026 16:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010782;
	bh=uual1bN0DgglC3q8q261Ke8Wp97hP85R+TY7/2mteSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HS+W47SZkuuOvQmUwg8DN9z8oJAGElq/HyFGXVVynDUatnQFR1lK+AHm6Cy0wDvof
	 LJwHSK7eYo4tEvleQtsVqsCwZOifuPooP5CV217nzaadA8BcqQso27uu1j29d3fq95
	 3qQ85nSEFNGbxYt7QajADC6GRlRwM2Y0ZscPtwYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/175] futex/requeue: Prevent NULL pointer dereference in remove_waiter() on self-deadlock
Date: Thu,  2 Jul 2026 18:18:55 +0200
Message-ID: <20260702155116.516620917@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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
@@ -629,6 +629,12 @@ retry_private:
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


