Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A928E46D541;
	Tue, 21 Jul 2026 15:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648984; cv=none; b=V41fxasXTlkpGKsxPGA4rcg8zKzuj+8B8KHbPDVNvsJCJRw+WPG1sVyNVCWS6bEnN1RwkJCqiyP5g/ix9cKWVCEyWWD/a2jhQkV2F/k5snTXxy8EYCs6Y3eacm3WwnLH7fI1WGXDFZtCDSTTxOTCNC0v5vvhea+oJ2BL9jQfQCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648984; c=relaxed/simple;
	bh=kXxii69bXEkGF7K71I5wFF4M3z2yl9N7qIMa4d7RXTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVMiEPDw+ARcsQeoYt/qL7AgThqsMdG2F9yaYUIwWM+uovpxf4clKHfIv50y0kkPwto0NBkw4iTiFvuI4g96ldlN3tRT+SpqOWMV8LyaWrJCzRSKOsqkuWY3LuszPXNrTQwfcHBDcYlkODjdWLMehgv3ladQm7ssTbs1P4Y7/KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8zoqWga; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8zoqWga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EC21F00A3A;
	Tue, 21 Jul 2026 15:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648983;
	bh=5j4CdvaGbwAvWD7GtDcgKZ/pf+RC81saGCKr63stXLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m8zoqWga7EaGB99bttc7uVDwgc2y/quI/HMR+T5TXXhCm7ufZ++A1IvijpBS4gDAf
	 syfWJF46xWgBPFB6/o116co0DPyyw9xNAvQHXSCWHEdlZFT2b+Rz1248oKvz3+9Ilm
	 ZqiDQ3mEKFb3RSyiXU9O1s/9gt3Cmbxw1Knt30RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Matlack <dmatlack@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0404/2077] liveupdate: Reference count incoming FLB data
Date: Tue, 21 Jul 2026 17:01:17 +0200
Message-ID: <20260721152602.245621193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Matlack <dmatlack@google.com>

[ Upstream commit d8e47bd066d7e626f9f45d416182d585b7e18b9b ]

Increment the incoming FLB refcount in liveupdate_flb_get_incoming() so
that the FLB structure cannot be freed while the caller is actively using
it. Add an additional liveupdate_flb_put_incoming() function so the
caller can explicitly indicate when it is done using the FLB data.

During a Live Update, a subsystem might need to hold onto the incoming
File-Lifecycle-Bound (FLB) data for an extended period, such as during
device enumeration. Incrementing the reference count guarantees that the
data remains valid and accessible until the subsystem releases it,
preventing future use-after-free bugs.

Fixes: cab056f2aae7 ("liveupdate: luo_flb: introduce File-Lifecycle-Bound global state")
Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://lore.kernel.org/r/20260423174032.3140399-3-dmatlack@google.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/liveupdate.h  |  6 ++++++
 kernel/liveupdate/luo_flb.c | 32 +++++++++++++++++---------------
 lib/tests/liveupdate.c      |  3 +++
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 8d3bbc35c828b8..88722e5caf020b 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -240,6 +240,8 @@ void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 			       struct liveupdate_flb *flb);
 
 int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp);
+void liveupdate_flb_put_incoming(struct liveupdate_flb *flb);
+
 int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb, void **objp);
 
 #else /* CONFIG_LIVEUPDATE */
@@ -280,6 +282,10 @@ static inline int liveupdate_flb_get_incoming(struct liveupdate_flb *flb,
 	return -EOPNOTSUPP;
 }
 
+static inline void liveupdate_flb_put_incoming(struct liveupdate_flb *flb)
+{
+}
+
 static inline int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb,
 					      void **objp)
 {
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index 59c5f31ab76740..8f5c5dd01cd048 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -165,7 +165,7 @@ static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
 	bool found = false;
 	int err;
 
-	guard(mutex)(&private->incoming.lock);
+	lockdep_assert_held(&private->incoming.lock);
 
 	if (private->incoming.finished)
 		return -ENODATA;
@@ -206,12 +206,14 @@ static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
 	return 0;
 }
 
-static void luo_flb_file_finish_one(struct liveupdate_flb *flb)
+void liveupdate_flb_put_incoming(struct liveupdate_flb *flb)
 {
 	struct luo_flb_private *private = luo_flb_get_private(flb);
+	struct liveupdate_flb_op_args args = {0};
 
-	if (refcount_dec_and_test(&private->incoming.count)) {
-		struct liveupdate_flb_op_args args = {0};
+	scoped_guard(mutex, &private->incoming.lock) {
+		if (!refcount_dec_and_test(&private->incoming.count))
+			return;
 
 		if (!private->incoming.retrieved) {
 			int err = luo_flb_retrieve_one(flb);
@@ -220,16 +222,14 @@ static void luo_flb_file_finish_one(struct liveupdate_flb *flb)
 				return;
 		}
 
-		scoped_guard(mutex, &private->incoming.lock) {
-			args.flb = flb;
-			args.obj = private->incoming.obj;
-			flb->ops->finish(&args);
+		args.flb = flb;
+		args.obj = private->incoming.obj;
+		flb->ops->finish(&args);
 
-			private->incoming.data = 0;
-			private->incoming.obj = NULL;
-			private->incoming.finished = true;
-			module_put(flb->ops->owner);
-		}
+		private->incoming.data = 0;
+		private->incoming.obj = NULL;
+		private->incoming.finished = true;
+		module_put(flb->ops->owner);
 	}
 }
 
@@ -312,7 +312,7 @@ void luo_flb_file_finish(struct liveupdate_file_handler *fh)
 
 	guard(rwsem_read)(&luo_register_rwlock);
 	list_for_each_entry_reverse(iter, flb_list, list)
-		luo_flb_file_finish_one(iter->flb);
+		liveupdate_flb_put_incoming(iter->flb);
 }
 
 static void luo_flb_unregister_one(struct liveupdate_file_handler *fh,
@@ -509,6 +509,8 @@ int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp)
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
+	guard(mutex)(&private->incoming.lock);
+
 	if (!private->incoming.obj) {
 		int err = luo_flb_retrieve_one(flb);
 
@@ -516,7 +518,7 @@ int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp)
 			return err;
 	}
 
-	guard(mutex)(&private->incoming.lock);
+	refcount_inc(&private->incoming.count);
 	*objp = private->incoming.obj;
 
 	return 0;
diff --git a/lib/tests/liveupdate.c b/lib/tests/liveupdate.c
index e4b0ecbee32fe6..4c08a7c6fb788a 100644
--- a/lib/tests/liveupdate.c
+++ b/lib/tests/liveupdate.c
@@ -105,6 +105,9 @@ static void liveupdate_test_init(void)
 			pr_err("liveupdate_flb_get_incoming for %s failed: %pe\n",
 			       flb->compatible, ERR_PTR(err));
 		}
+
+		if (!err)
+			liveupdate_flb_put_incoming(flb);
 	}
 	initialized = true;
 }
-- 
2.53.0



