Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831465;
	b=OriPwc8GDjYQyYY4dmsabsHF2AAdw2/nXJp7gudVdkw/WxiqmmhhgITN3tKd6PesJ+Hu
	 0wb/KZLa3BYeyFFNJmW6xW/bwefJWRX2Ldp11P9pVaN70P/cmAD6zNuZpnQzHS1wOQz9S
	 6pf3op5JnqRf349AFitQvwDcYtl7M+hiEcuKMGcnzuveSAf9xo3xL1WWXcfn7ocwwiuC4
	 b//4l6e9rowiNcewz5H5TgZNVqolUkK/6+/1hI8ij8nV3jofoxkihs6gZiRDTjjUvw4K1
	 BQ+FOZ16OAFLa8lBVzWmc5hkRcAWVndZLAoIGWzQV2OXyJcDI3/fR+LcZ5rX72AI01Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DLu8ONxoKn/q4xS68Dago4mtGglax0zgNlxbycGOdzE=;
	b=mk4Wv/h2CqAYcknCKxovZFE4ZMIS+/0pvirYOHO6Zj8B4zNy+sVCbX+kVW1CbUoiJLsE
	 IjFgLd+1wSMneIGmkrmfSy9DGiWryluxUoQf9zAzUwnBwOvzU7fVrBjEAqREHrzLhaZPH
	 Sr/5nOWFpKWnRZHbR5lajsKYf+l4FIxoTY4rygjqQu18NPCIC1NDsgZpUbfk+CNCotme5
	 yraQojvr02NO0ABEIl2IYWKlqIdB6zXnTMANknJrzM6EApeOTl/idBl0KW2mOVXlNmRF9
	 YbqXgKWHjkt9P+7v7iZE9Fci57bCLb+qovt9ktXDWQNWu8FU2GCGrQKOYNEvG3Q6wuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sI0WraRN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6D5606A335;
	Wed,  4 Nov 2026 22:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sI0WraRN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BB21F00A02;
	Wed,  4 Nov 2026 22:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831464;
	bh=DLu8ONxoKn/q4xS68Dago4mtGglax0zgNlxbycGOdzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sI0WraRNeBJlm0/v4LaTTZSqhh2Y6SRG1jTvEg7aTrGPXvjx4gJbLd7a5hAehWbfE
	 qMidfFaekAZjHjyynizZVHeQ5P6MyvZ4d0qJLx7EXcmJmY8XS20K9oD76s4lcjekfT
	 53Wbxh3Oj76P4A6UebACzxfkY4wMxtun8h5u21p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.18 0680/1005] apparmor: fix a use-after-free in aa_lookupn_ns()
Date: Wed,  4 Nov 2026 16:06:53 -0500
Message-ID: <20261104211102.679042377@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Binbin Deng <18983559317@163.com>

commit f292873ceb4bd3a1a0f75f884361cd556e457692 upstream.

aa_lookupn_ns() takes a reference on the namespace it finds with
aa_get_ns(), which is kref_get() on the reference count that the
namespace is released through, without checking whether the namespace
is still in use.  A concurrent removal of a ":"-prefixed namespace
looks the same namespace up and only then takes the parent lock to
remove it, so the last reference can be dropped between the lookup and
the aa_get_ns() call: the reference count then reports the increment on
a zero count and the kernel classifies the following use of the object
as a use-after-free.  A user with CAP_MAC_ADMIN can trigger this by
writing a ":<name>" removal and a ":<name>/<profile>" removal to
/sys/kernel/security/apparmor/.remove concurrently.

refcount_t: addition on 0; use-after-free.
WARNING: lib/refcount.c:25 at refcount_warn_saturate+0xc0/0xe0, CPU#6
Call Trace:
 <TASK>
 aa_lookupn_ns+0xa9/0xc0
 aa_remove_profiles+0x4fb/0x730
 ? __kvmalloc_node_noprof+0x219/0x5c0
 ? __pfx_aa_remove_profiles+0x10/0x10
 ? aa_loaddata_alloc+0x65/0x1f0
 ? _copy_from_user+0x2d/0x80
 ? aa_loaddata_alloc+0x111/0x1f0
 profile_remove+0x2ee/0x4a0
 vfs_write+0x21e/0xcf0
 ? rcu_core+0x29c/0x1740
 ? timerqueue_linked_add+0x1f4/0x3d0
 ? __pfx_vfs_write+0x10/0x10
 ? mutex_lock+0x81/0xe0
 ? __pfx_mutex_lock+0x10/0x10
 ? __pfx_rcu_core+0x10/0x10
 ? __pfx_hrtimer_update_next_event+0x10/0x10
 ? mutex_unlock+0x7b/0xd0
 ? fdget_pos+0x24d/0x4b0
 ksys_write+0xf7/0x1c0
 ? __pfx_ksys_write+0x10/0x10
 ? restore_fpregs_from_fpstate+0x37/0xc0
 do_syscall_64+0xf9/0x540
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Fix by rejecting a namespace whose reference count is zero.

Fixes: 3664268f19ea0 ("apparmor: add namespace lookup fns()")
Cc: stable@vger.kernel.org
Signed-off-by: Binbin Deng <18983559317@163.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/include/policy_ns.h |   16 ++++++++++++++++
 security/apparmor/policy_ns.c         |    2 +-
 2 files changed, 17 insertions(+), 1 deletion(-)

--- a/security/apparmor/include/policy_ns.h
+++ b/security/apparmor/include/policy_ns.h
@@ -118,6 +118,22 @@ static inline struct aa_ns *aa_get_ns(st
 }
 
 /**
+ * aa_get_ns_not0 - increment references count on @ns found via lookup
+ * @ns: namespace to increment reference count of (MAYBE NULL)
+ *
+ * Returns: pointer to @ns, if @ns is NULL returns NULL,
+ *          NULL if @ns is being freed
+ * Requires: @ns must be held with valid refcount when called
+ */
+static inline struct aa_ns *aa_get_ns_not0(struct aa_ns *ns)
+{
+	if (ns && aa_get_profile_not0(ns->unconfined))
+		return ns;
+
+	return NULL;
+}
+
+/**
  * aa_put_ns - decrement refcount on @ns
  * @ns: namespace to put reference of
  *
--- a/security/apparmor/policy_ns.c
+++ b/security/apparmor/policy_ns.c
@@ -207,7 +207,7 @@ struct aa_ns *aa_lookupn_ns(struct aa_ns
 	struct aa_ns *ns = NULL;
 
 	rcu_read_lock();
-	ns = aa_get_ns(__aa_lookupn_ns(view, name, n));
+	ns = aa_get_ns_not0(__aa_lookupn_ns(view, name, n));
 	rcu_read_unlock();
 
 	return ns;


