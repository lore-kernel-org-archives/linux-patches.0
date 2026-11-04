Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827053;
	b=X4rGHZ9Uxzyo8cpQpiUPRisINwZwFJUdV4kCEtKXVRA+8uTVTWtro2wXwzsBsCQR/672
	 U5deO+YpKjDcaAcGAC/XJydmDosVMLK8BSLIgd/clUW3ODAqyeGDCALhnEyrpoUzP79Vq
	 c+R4uEHgHpdqriVVx96i8q+H9kr7p/l9j0bC8741j21c0Z4XBRyxxyVgD330mrfpyWUcA
	 WQq+ewpodUFWAHk+OBUgS11TQr9HZqmmA4ad/IDT26XLEGstamGu+LZzkW0P/TQeZfS7O
	 mW1zibwqVjUwKOg1Pf2exSkH9OLjtPVqZF+n5B4tSn/okhpFw4t0bObRjE4cLz9SBVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J5vcD+f/vpEr4xDlxeuinCecYySjIyDCklFZNNmDzP8=;
	b=Fvd7m/PQfEWLFJFVy9c9VCQGsA6AgCC7MzAjZyfOWSPOWo8Aq5TkqnVvxq0FN1cmqH5x
	 iHeunC0swIikZo36MXmyRVMwIWkq/Yi4mvyL2WHlTx1PjhzmEAwz/eGLVqMWjFzACSrDr
	 i/XrGEUUWL/gh/Yv5OgGQ/0XSqNPXcL15IvbX+iiSizuSIQLK1HXc/2Gkg9qq0wj4GKct
	 Unl73DwzzMXrcVGWqe0e4ak82CGJsLd00zszpWHRLj9uNZhJDl0t3wFceWeXS4fqbzstY
	 2TIPD/wqDvif1SYLWd6OzdSIQjXf/loGejLnlSf4ESiHgSgP8LnPQVPZ1zPBU+M4x5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GSLF4iUU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FF2606AB18;
	Wed,  4 Nov 2026 21:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GSLF4iUU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7028D1F000C1;
	Wed,  4 Nov 2026 21:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827052;
	bh=J5vcD+f/vpEr4xDlxeuinCecYySjIyDCklFZNNmDzP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSLF4iUUAu4fKVSGurZ0QUNLy4byfuScaIWNqZFksKUXfwa8OrLb6S8p7TvD2NQly
	 HYTO4EB6QcdBo9T3nLnQOtcxek7elsQhsfr9+H0BjvYVMso2trMdJj4MVz2fT08ml/
	 POv1vUqAn4URB+8kRvjZX/r9PYUxRw6mcZdhRISY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 7.3 165/547] apparmor: fix a use-after-free in aa_lookupn_ns()
Date: Wed,  4 Nov 2026 16:05:49 -0500
Message-ID: <20261104211042.840463627@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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


