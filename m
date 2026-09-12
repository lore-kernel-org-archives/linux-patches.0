Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029883803CF;
	Sat, 12 Sep 2026 07:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199802; cv=none; b=IerS7gqlvT39ALF13ySHfyRDHuuckGZYK9LxCe2W0STu5DG2J4MqJ0wotUXY0hW9hi8k9doBV5ZUE9KWDK1uSpA5e079l/ZITBsGipGXm/m3d0wwvGpSFd8CsqCjUPpn5Ymz119QEeHg/aGrZ3tlVLi+q5XeFoorI/sI7QE+nvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199802; c=relaxed/simple;
	bh=HYKHl+dPJxFA68M9iHvKGmjqgVrrI+TzeeF2v1BSd1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSuOca3PAJ0gFpoTOJ5ATkj2/Q4vlCnMSDJtmM8BLUvpzvf2LExwou7myiSFLZ1t7R/k9ctk1s+/38wQaG1ZgtzYHzu7FxiyzTLk46FKQAy1mjRYApSPjg6PF7KXVNqzIMyRMHWbFfBnLIaJBOrezaHSSUUk0u2lurHd+9FLZUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fduTKfp2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fduTKfp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3941F000FF;
	Sat, 12 Sep 2026 07:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199800;
	bh=2rZiEkRcRGeCQCTwnv4L/OhkCxCzWlGbBBFxjflDaYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fduTKfp2yPJEN8AzEuNEWzSMv4sgM4YzMeuLCunWqzhS14xrGfWtwJRrc9nBAwSma
	 /qb94BMRt/q0pmQnKXQzQ/eE+6WgM+B7iHET13bdo70WwqSY5nrwkwyY+dj5dBLg3E
	 3CyTLMxTGR9mrBJUjJyaiMbK0rjwxKJsiizZFsX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0659/1815] liveupdate: Reference count outgoing FLB data
Date: Sat, 12 Sep 2026 08:40:09 +0200
Message-ID: <20260912065704.351289131@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Matlack <dmatlack@google.com>

[ Upstream commit 36882f3392395704c8a3fe7fac831fb6f5737e7d ]

Increment the outgoing FLB refcount in liveupdate_flb_get_outgoing() so
that the FLB structure cannot be freed while the caller is actively
using it. Add an additional liveupdate_flb_put_outgoing() function so
the caller can explicitly indicate when it is done using the outgoing
FLB.

During a Live Update, the kernel may need to fetch the outgoing FLB
outside of the scope of a file handler's preserve() and unpreserve()
callbacks. In that situation there is no way for the caller to protect
itself against the outgoing FLB from being freed while it is using it.
Incrementing the reference count in liveupdate_flb_get_outgoing()
ensures it cannot be freed.

This change also aligns the outgoing FLB lifecycle management with the
incoming FLB, since the latter uses the same get/put semantics.

Fixes: cab056f2aae7 ("liveupdate: luo_flb: introduce File-Lifecycle-Bound global state")
Assisted-by: Gemini:gemini-3-pro-preview
Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://patch.msgid.link/20260528174140.1921129-2-dmatlack@google.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/liveupdate.h  |  5 +++++
 kernel/liveupdate/luo_flb.c | 10 +++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 88722e5caf020..c344bf987b63a 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -243,6 +243,7 @@ int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp);
 void liveupdate_flb_put_incoming(struct liveupdate_flb *flb);
 
 int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb, void **objp);
+void liveupdate_flb_put_outgoing(struct liveupdate_flb *flb);
 
 #else /* CONFIG_LIVEUPDATE */
 
@@ -292,5 +293,9 @@ static inline int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb,
 	return -EOPNOTSUPP;
 }
 
+static inline void liveupdate_flb_put_outgoing(struct liveupdate_flb *flb)
+{
+}
+
 #endif /* CONFIG_LIVEUPDATE */
 #endif /* _LINUX_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index 5c27134ce7ba5..02b449e1e98ba 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -133,7 +133,7 @@ static int luo_flb_file_preserve_one(struct liveupdate_flb *flb)
 	return 0;
 }
 
-static void luo_flb_file_unpreserve_one(struct liveupdate_flb *flb)
+void liveupdate_flb_put_outgoing(struct liveupdate_flb *flb)
 {
 	struct luo_flb_private *private = luo_flb_get_private(flb);
 
@@ -264,7 +264,7 @@ int luo_flb_file_preserve(struct liveupdate_file_handler *fh)
 
 exit_err:
 	list_for_each_entry_continue_reverse(iter, flb_list, list)
-		luo_flb_file_unpreserve_one(iter->flb);
+		liveupdate_flb_put_outgoing(iter->flb);
 	up_read(&luo_register_rwlock);
 
 	return err;
@@ -289,7 +289,7 @@ void luo_flb_file_unpreserve(struct liveupdate_file_handler *fh)
 
 	guard(rwsem_read)(&luo_register_rwlock);
 	list_for_each_entry_reverse(iter, flb_list, list)
-		luo_flb_file_unpreserve_one(iter->flb);
+		liveupdate_flb_put_outgoing(iter->flb);
 }
 
 /**
@@ -544,6 +544,10 @@ int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb, void **objp)
 		return -EOPNOTSUPP;
 
 	guard(mutex)(&private->outgoing.lock);
+	if (!private->outgoing.obj)
+		return -ENOENT;
+
+	refcount_inc(&private->outgoing.count);
 	*objp = private->outgoing.obj;
 
 	return 0;
-- 
2.53.0



