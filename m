Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9778B14A0A7;
	Tue, 23 Jan 2024 00:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969207; cv=none; b=HH1hu1pbYm4zOseZhifUrjnqcghRUSWIwr9L0xqvblQjmZ2oNuZnupU/Lnl26lTqg6zkGu1j6KS6jCOVIf0Kn0900czkcipruZ/j7PnSSGl1uPtKfzxtvRTQ6xlmWWdjzo3giaD4K4P5TI58Ysmbq7pHazcprhc0ddcI9Hxwm50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969207; c=relaxed/simple;
	bh=hkIWcxuySXFrrotn/FVp6CrceO7Z4YdiES2EVaOTQLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krNnUx0xxmM9leJDqpK8uO2VVrN6kOQKc1mC4i2263USQ5BEbpdMB8nqMx7ArvQy6KqRWTCOWcTHs21CBfppYxrMyjc4qT8XHC1BFNSuKhVKTxz7f8NCM7xDTWca63JiseWKwDwdjis5JN9ajSnHCPEcOtSHj5ODIm/DbdFtfAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fMdeSsFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fMdeSsFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A638C433A6;
	Tue, 23 Jan 2024 00:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969207;
	bh=hkIWcxuySXFrrotn/FVp6CrceO7Z4YdiES2EVaOTQLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fMdeSsFUEgk4zT6v73aHmD1A5cnyTp1kO9o0Dd91CLWBxDKdcWIJ+Rlr7x8vAIDOG
	 ypOcj6eF1Y4A4mKcZEhN0Kyh548tdpiQJNt7I1yAmSus5PRZCEXC/AGEWBe4PiGTud
	 3N+td/rCJz7jOqM04xj61s337b8I0ijEoyITkbGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Marchevsky <davemarchevsky@fb.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 099/641] bpf: Add KF_RCU flag to bpf_refcount_acquire_impl
Date: Mon, 22 Jan 2024 15:50:03 -0800
Message-ID: <20240122235821.137157684@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Marchevsky <davemarchevsky@fb.com>

[ Upstream commit 1500a5d9f49cb66906d3ea1c9158df25cc41dd40 ]

Refcounted local kptrs are kptrs to user-defined types with a
bpf_refcount field. Recent commits ([0], [1]) modified the lifetime of
refcounted local kptrs such that the underlying memory is not reused
until RCU grace period has elapsed.

Separately, verification of bpf_refcount_acquire calls currently
succeeds for MAYBE_NULL non-owning reference input, which is a problem
as bpf_refcount_acquire_impl has no handling for this case.

This patch takes advantage of aforementioned lifetime changes to tag
bpf_refcount_acquire_impl kfunc KF_RCU, thereby preventing MAYBE_NULL
input to the kfunc. The KF_RCU flag applies to all kfunc params; it's
fine for it to apply to the void *meta__ign param as that's populated by
the verifier and is tagged __ign regardless.

  [0]: commit 7e26cd12ad1c ("bpf: Use bpf_mem_free_rcu when
       bpf_obj_dropping refcounted nodes") is the actual change to
       allocation behaivor
  [1]: commit 0816b8c6bf7f ("bpf: Consider non-owning refs to refcounted
       nodes RCU protected") modified verifier understanding of
       refcounted local kptrs to match [0]'s changes

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
Fixes: 7c50b1cb76ac ("bpf: Add bpf_refcount_acquire kfunc")
Link: https://lore.kernel.org/r/20231107085639.3016113-2-davemarchevsky@fb.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 56b0c1f678ee..6950f0461634 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2520,7 +2520,7 @@ BTF_ID_FLAGS(func, bpf_obj_new_impl, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_percpu_obj_new_impl, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_obj_drop_impl, KF_RELEASE)
 BTF_ID_FLAGS(func, bpf_percpu_obj_drop_impl, KF_RELEASE)
-BTF_ID_FLAGS(func, bpf_refcount_acquire_impl, KF_ACQUIRE | KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_refcount_acquire_impl, KF_ACQUIRE | KF_RET_NULL | KF_RCU)
 BTF_ID_FLAGS(func, bpf_list_push_front_impl)
 BTF_ID_FLAGS(func, bpf_list_push_back_impl)
 BTF_ID_FLAGS(func, bpf_list_pop_front, KF_ACQUIRE | KF_RET_NULL)
-- 
2.43.0



