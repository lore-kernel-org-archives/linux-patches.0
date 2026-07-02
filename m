Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA0533D4EC;
	Thu,  2 Jul 2026 16:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010115; cv=none; b=ZCgR7gKZmIfG2LA7qCiY8e/YsgCdYAPhuwV5jFPSJtI6pzDf4GmAixihl2lch1l8qiOPg9LqmWJKc+6i6d3S33jjIIVLyHkudIbYDtG2g56WgDB+P6r4zaxUohnKqoZo6AVlpDWWAr9NnGux2umxw6g6BQIpQ3GJV0WkjbVXSBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010115; c=relaxed/simple;
	bh=9zJeoHUy22A+T+/5GYa55Cvn10eqfXJNH4Pz8ukFsf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxjIb6vXQgQXpb3tkR9XhS2wqJJhcdNgE1DiwQ16YoaGsDcmtKnoKpB0j9Ln+S1NyMdc+AtLqs5M+mzs+JUjLpbfuVFXONVvtyWqK+kL7Keb6nwSI/RfJpSHfN0Xc4wobeW1tfromS/sHcM4TVT4QwFHKOfr6OL50DMrXeMsyng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=koKmvtlK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="koKmvtlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C3E1F000E9;
	Thu,  2 Jul 2026 16:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010114;
	bh=nle0EN/1KKeG2E1ukbgjaZMZyUf1jnUwUDeYehw8xYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=koKmvtlKJ7kzxNpqt6ryWKyZwHvQxFWGs9h6XWGAGoV6Owjqll2U2mfaCpiXwfSwS
	 xOTBzJ/tGZw0m0o9D0Ooos0aeFvq7xIgw7L81Mfghab2oNcIdTG5pmE0imvPg30otb
	 4ZGQS2BaXp9V3sq4deQQ1pup/x2GDEa+vczPZqgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 117/129] futex/requeue: Prevent NULL pointer dereference in remove_waiter() on self-deadlock
Date: Thu,  2 Jul 2026 18:20:36 +0200
Message-ID: <20260702155114.565787504@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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


