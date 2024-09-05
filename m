Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27380635;
	Thu,  5 Sep 2024 09:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529788; cv=none; b=tziKCZcV8P/TEXGvzKF99JHRP6yedE3jCEscLjovwbygxKb854ls/cBhvJTadW2yXmdsbyIhGu9DOPDWFlTAK/oIqMkuchRGsgiNDxueuBIFhfX3fwex0dYV1daIvUm0Yj8skCoqrwFgfIvlMQf6s7ZbZt2KdYvk9qCnaTJpbwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529788; c=relaxed/simple;
	bh=LSUrCYBnbUD+va0v5j+4JC9Touqq8G8AC0zGGjgWU5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUFs0AnetR0kDBYEQ2DGYfbe/wbAGoFMGXEs5SeumSUxCNDScxHg7G7Vtm/WWnhe0K6KJzhIUobKLTThzQ5wIbv3wm5KvJSmZwF1bLABW81wRkdKsMgLvByE/0YTQZ65hK5kUlyaefnxYurPv/egbiQ83bfRXCZnIvDU3KaXIcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFqXjirV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFqXjirV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E0DC4CEC3;
	Thu,  5 Sep 2024 09:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529788;
	bh=LSUrCYBnbUD+va0v5j+4JC9Touqq8G8AC0zGGjgWU5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFqXjirVbRuuT1GJg/hQjvQDhW2xKhbX00V8PImFZ3x4ea9bRxzReeCsh1OMeOsN9
	 xNJsyDFESa7mHinjoxq7bAerqXqBUvz9fsS9vJWO6p1a+DNyfz8R7wgVgdC+kXe/c+
	 1G2Vf6nAwxh+cYdRI9pnojllTqVhbe0EYV8MOFV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Maina <quic_rmaina@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Chris Lew <quic_clew@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 125/184] hwspinlock: Introduce hwspin_lock_bust()
Date: Thu,  5 Sep 2024 11:40:38 +0200
Message-ID: <20240905093737.107835101@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Maina <quic_rmaina@quicinc.com>

[ Upstream commit 7c327d56597d8de1680cf24e956b704270d3d84a ]

When a remoteproc crashes or goes down unexpectedly this can result in
a state where locks held by the remoteproc will remain locked possibly
resulting in deadlock. This new API hwspin_lock_bust() allows
hwspinlock implementers to define a bust operation for freeing previously
acquired hwspinlocks after verifying ownership of the acquired lock.

Signed-off-by: Richard Maina <quic_rmaina@quicinc.com>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Chris Lew <quic_clew@quicinc.com>
Link: https://lore.kernel.org/r/20240529-hwspinlock-bust-v3-1-c8b924ffa5a2@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/locking/hwspinlock.rst     | 11 ++++++++++
 drivers/hwspinlock/hwspinlock_core.c     | 28 ++++++++++++++++++++++++
 drivers/hwspinlock/hwspinlock_internal.h |  3 +++
 include/linux/hwspinlock.h               |  6 +++++
 4 files changed, 48 insertions(+)

diff --git a/Documentation/locking/hwspinlock.rst b/Documentation/locking/hwspinlock.rst
index 6f03713b7003..2ffaa3cbd63f 100644
--- a/Documentation/locking/hwspinlock.rst
+++ b/Documentation/locking/hwspinlock.rst
@@ -85,6 +85,17 @@ is already free).
 
 Should be called from a process context (might sleep).
 
+::
+
+  int hwspin_lock_bust(struct hwspinlock *hwlock, unsigned int id);
+
+After verifying the owner of the hwspinlock, release a previously acquired
+hwspinlock; returns 0 on success, or an appropriate error code on failure
+(e.g. -EOPNOTSUPP if the bust operation is not defined for the specific
+hwspinlock).
+
+Should be called from a process context (might sleep).
+
 ::
 
   int hwspin_lock_timeout(struct hwspinlock *hwlock, unsigned int timeout);
diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index 0c0a932c00f3..6505261e6068 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -305,6 +305,34 @@ void __hwspin_unlock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
 }
 EXPORT_SYMBOL_GPL(__hwspin_unlock);
 
+/**
+ * hwspin_lock_bust() - bust a specific hwspinlock
+ * @hwlock: a previously-acquired hwspinlock which we want to bust
+ * @id: identifier of the remote lock holder, if applicable
+ *
+ * This function will bust a hwspinlock that was previously acquired as
+ * long as the current owner of the lock matches the id given by the caller.
+ *
+ * Context: Process context.
+ *
+ * Returns: 0 on success, or -EINVAL if the hwspinlock does not exist, or
+ * the bust operation fails, and -EOPNOTSUPP if the bust operation is not
+ * defined for the hwspinlock.
+ */
+int hwspin_lock_bust(struct hwspinlock *hwlock, unsigned int id)
+{
+	if (WARN_ON(!hwlock))
+		return -EINVAL;
+
+	if (!hwlock->bank->ops->bust) {
+		pr_err("bust operation not defined\n");
+		return -EOPNOTSUPP;
+	}
+
+	return hwlock->bank->ops->bust(hwlock, id);
+}
+EXPORT_SYMBOL_GPL(hwspin_lock_bust);
+
 /**
  * of_hwspin_lock_simple_xlate - translate hwlock_spec to return a lock id
  * @hwlock_spec: hwlock specifier as found in the device tree
diff --git a/drivers/hwspinlock/hwspinlock_internal.h b/drivers/hwspinlock/hwspinlock_internal.h
index 29892767bb7a..f298fc0ee5ad 100644
--- a/drivers/hwspinlock/hwspinlock_internal.h
+++ b/drivers/hwspinlock/hwspinlock_internal.h
@@ -21,6 +21,8 @@ struct hwspinlock_device;
  * @trylock: make a single attempt to take the lock. returns 0 on
  *	     failure and true on success. may _not_ sleep.
  * @unlock:  release the lock. always succeed. may _not_ sleep.
+ * @bust:    optional, platform-specific bust handler, called by hwspinlock
+ *	     core to bust a specific lock.
  * @relax:   optional, platform-specific relax handler, called by hwspinlock
  *	     core while spinning on a lock, between two successive
  *	     invocations of @trylock. may _not_ sleep.
@@ -28,6 +30,7 @@ struct hwspinlock_device;
 struct hwspinlock_ops {
 	int (*trylock)(struct hwspinlock *lock);
 	void (*unlock)(struct hwspinlock *lock);
+	int (*bust)(struct hwspinlock *lock, unsigned int id);
 	void (*relax)(struct hwspinlock *lock);
 };
 
diff --git a/include/linux/hwspinlock.h b/include/linux/hwspinlock.h
index bfe7c1f1ac6d..f0231dbc4777 100644
--- a/include/linux/hwspinlock.h
+++ b/include/linux/hwspinlock.h
@@ -68,6 +68,7 @@ int __hwspin_lock_timeout(struct hwspinlock *, unsigned int, int,
 int __hwspin_trylock(struct hwspinlock *, int, unsigned long *);
 void __hwspin_unlock(struct hwspinlock *, int, unsigned long *);
 int of_hwspin_lock_get_id_byname(struct device_node *np, const char *name);
+int hwspin_lock_bust(struct hwspinlock *hwlock, unsigned int id);
 int devm_hwspin_lock_free(struct device *dev, struct hwspinlock *hwlock);
 struct hwspinlock *devm_hwspin_lock_request(struct device *dev);
 struct hwspinlock *devm_hwspin_lock_request_specific(struct device *dev,
@@ -127,6 +128,11 @@ void __hwspin_unlock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
 {
 }
 
+static inline int hwspin_lock_bust(struct hwspinlock *hwlock, unsigned int id)
+{
+	return 0;
+}
+
 static inline int of_hwspin_lock_get_id(struct device_node *np, int index)
 {
 	return 0;
-- 
2.43.0



