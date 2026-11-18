Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053922;
	b=ZGuqYFhCmS+v96x83xWrlCrFHbgM52HHCxkIylaVvbybY7WciF9R5kg1WbvUCV1MjYNC
	 n34SmNHsSJqOwOPznfiitxsbAzSHc7brpzAQYK1TFXw4kACtHkDP6ml5leOJ5qMKYm0A0
	 p9a7CydJvMQ8dk/UB9f3P0qT/qj2jEulBt6ukBuI6U3iRtk2VhtmGqlCRpVvIVNOXncoT
	 wPT1IVWKcSwY/ZPAzSNc7CtgZw0V2YfaX9MgXShmjG0JFm9sfy3QaI55VFZBNBlxIdBBn
	 N8C4WQI69FO+CS/4BEgqv8lxbhrQukYrQdlTdk2lyZv0h5vJTUWrIyqgzJatreGF9PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y6STywZZk79sikN+KF8FTfDFhxiOhcAtghYlwQLiXtc=;
	b=zzTdcGxX0Pr3ifJ1J3tN2oQoE87pcQ7YgeLIHDSNrVr2YH+bLRpA8716hkYr79lZi/wh
	 UECq4qjuXp0KH+e1VKPovsXhLczZohY+Wn2FTJaPQUEQsmYrCem1v4ls18LehOvZrHET3
	 uZh4ulc7pb2FWu6IXCMoTjXVz2ogJ2d2iKATbZXBzMErx0BeLpIQtgRIKxeyWe5Ew8osD
	 /afw+VDpLsPX2/lFKkDZc5GvrP6X3Z05C4I5xVMUKpCVN1OcWhdziYfxNT1WRMtLa/iSn
	 A7OPHdpbFkHGgA5vTe9if4NYGLF7Z8TPJqrlO2ymjLpSamwAnbfzvLyDjfZ3lGXUqRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="c/FZvrlb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1177606A31C;
	Thu, 19 Nov 2026 02:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c/FZvrlb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC911F000C5;
	Thu, 19 Nov 2026 02:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053921;
	bh=y6STywZZk79sikN+KF8FTfDFhxiOhcAtghYlwQLiXtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c/FZvrlb/FAYUAb4wnszOxGyxSGnRzdJN7LPTeZAFkMr3r3UxyY8irssORHb2d8NV
	 Uu/nuOkUIXMCdNlCuma7Q70qiY8YDWHkPwRdfFXzgOKWaIioF64I8VqaKj0MDsP2UM
	 hw/7PWvfBLcoJabwuBS39so01IrrmOpJiD2VUW38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrei Vagin <avagin@google.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Alexey Gladkov <legion@kernel.org>,
	Kees Cook <kees@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1091/2214] signal: restore the override_rlimit logic
Date: Wed, 18 Nov 2026 15:46:07 +0100
Message-ID: <20261118150055.868132495@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Gushchin <roman.gushchin@linux.dev>

[ Upstream commit 9e05e5c7ee8758141d2db7e8fea2cab34500c6ed ]

Prior to commit d64696905554 ("Reimplement RLIMIT_SIGPENDING on top of
ucounts") UCOUNT_RLIMIT_SIGPENDING rlimit was not enforced for a class of
signals.  However now it's enforced unconditionally, even if
override_rlimit is set.  This behavior change caused production issues.

For example, if the limit is reached and a process receives a SIGSEGV
signal, sigqueue_alloc fails to allocate the necessary resources for the
signal delivery, preventing the signal from being delivered with siginfo.
This prevents the process from correctly identifying the fault address and
handling the error.  From the user-space perspective, applications are
unaware that the limit has been reached and that the siginfo is
effectively 'corrupted'.  This can lead to unpredictable behavior and
crashes, as we observed with java applications.

Fix this by passing override_rlimit into inc_rlimit_get_ucounts() and skip
the comparison to max there if override_rlimit is set.  This effectively
restores the old behavior.

Link: https://lkml.kernel.org/r/20241104195419.3962584-1-roman.gushchin@linux.dev
Fixes: d64696905554 ("Reimplement RLIMIT_SIGPENDING on top of ucounts")
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Co-developed-by: Andrei Vagin <avagin@google.com>
Signed-off-by: Andrei Vagin <avagin@google.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Alexey Gladkov <legion@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

override_rlimit is set.  This behavior change caused production issues.

For example, if the limit is reached and a process receives a SIGSEGV
signal, sigqueue_alloc fails to allocate the necessary resources for the
signal delivery, preventing the signal from being delivered with siginfo.

Stable-dep-of: b14fcabd34e0 ("ucount: take the rlimit reference before checking the limit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/user_namespace.h | 3 ++-
 kernel/signal.c                | 3 ++-
 kernel/ucount.c                | 6 ++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 45f09bec02c48..733f2a97589b2 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -131,7 +131,8 @@ static inline long get_rlimit_value(struct ucounts *ucounts, enum rlimit_type ty
 
 long inc_rlimit_ucounts(struct ucounts *ucounts, enum rlimit_type type, long v);
 bool dec_rlimit_ucounts(struct ucounts *ucounts, enum rlimit_type type, long v);
-long inc_rlimit_get_ucounts(struct ucounts *ucounts, enum rlimit_type type);
+long inc_rlimit_get_ucounts(struct ucounts *ucounts, enum rlimit_type type,
+			    bool override_rlimit);
 void dec_rlimit_put_ucounts(struct ucounts *ucounts, enum rlimit_type type);
 bool is_rlimit_overlimit(struct ucounts *ucounts, enum rlimit_type type, unsigned long max);
 
diff --git a/kernel/signal.c b/kernel/signal.c
index c4091812ea89b..5d110fd089d10 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -426,7 +426,8 @@ __sigqueue_alloc(int sig, struct task_struct *t, gfp_t gfp_flags,
 	 */
 	rcu_read_lock();
 	ucounts = task_ucounts(t);
-	sigpending = inc_rlimit_get_ucounts(ucounts, UCOUNT_RLIMIT_SIGPENDING);
+	sigpending = inc_rlimit_get_ucounts(ucounts, UCOUNT_RLIMIT_SIGPENDING,
+					    override_rlimit);
 	rcu_read_unlock();
 	if (!sigpending)
 		return NULL;
diff --git a/kernel/ucount.c b/kernel/ucount.c
index 2e2c9c2096781..1459c1c579dc0 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -301,7 +301,8 @@ void dec_rlimit_put_ucounts(struct ucounts *ucounts, enum rlimit_type type)
 	do_dec_rlimit_put_ucounts(ucounts, NULL, type);
 }
 
-long inc_rlimit_get_ucounts(struct ucounts *ucounts, enum rlimit_type type)
+long inc_rlimit_get_ucounts(struct ucounts *ucounts, enum rlimit_type type,
+			    bool override_rlimit)
 {
 	/* Caller must hold a reference to ucounts */
 	struct ucounts *iter;
@@ -314,7 +315,8 @@ long inc_rlimit_get_ucounts(struct ucounts *ucounts, enum rlimit_type type)
 			goto dec_unwind;
 		if (iter == ucounts)
 			ret = new;
-		max = get_userns_rlimit_max(iter->ns, type);
+		if (!override_rlimit)
+			max = get_userns_rlimit_max(iter->ns, type);
 		/*
 		 * Grab an extra ucount reference for the caller when
 		 * the rlimit count was previously 0.
-- 
2.53.0



