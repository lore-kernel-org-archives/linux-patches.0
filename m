Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260C035200C;
	Thu, 20 Aug 2026 15:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238212; cv=none; b=fqXILfZh+x6bd5uNz5hQG63l5Z0kRb46Zh2hrkwDfIttSBS4a8x7p4RntOGZ/hvhK+ANfJ3fNy+/nr+5VrsUiTKMB4C1Pnfq4n5cpt6auk4mWnQEmqeGJji2u+Nc2t6ZmfwXFB/fvBHULSBRdroZUmwT6pFk2FE1jus7A4shWKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238212; c=relaxed/simple;
	bh=tq379GoNx1BHbHCBcviI8BEP8Xpo2SfG15l/Xd18FuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXCyAMEQrFqGggOaTGs6x7LMSfHmOrw5enF2CCJv2xaDGlh42JofoNIPiEEqLArejgeG7WQVW2OOimRugjrQrQQy2yJVA/hVZdxMA5d90JM4bW95goIg5aAaUc+kUp6rhxtPZYWOi/ci9rLPLSa/+BLRaH5PTj9VhPLDlIS26GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zicTNtz1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zicTNtz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898C21F000E9;
	Thu, 20 Aug 2026 15:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238211;
	bh=Pmd6buyp4HnN/yjfYrIFnsE2C9apdMgIUxFlO3+H2Xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zicTNtz1lzp1FQnj7lg5P/TTIkKz5EIeditzitVZy75voEaept2o8xnw+UNCUUDiX
	 24fGfJsFCoVO2DYAwJ3VVvGg7QxKBxxjGtmHP4RCelZhTc3ElC1FR+gIUPeg0TMb26
	 uoEQD93Ce+YoSNwMMitasVYUvaERSeO0ylsfCnZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Leon Hwang <leon.hwang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.1 070/228] ftrace: Protect direct_functions in update_ftrace_direct_mod
Date: Thu, 20 Aug 2026 16:53:32 +0200
Message-ID: <20260820145246.588121244@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

From: Leon Hwang <leon.hwang@linux.dev>

commit 092f8ec7dbdc71f5bde9bb0f8dead384d2115a44 upstream.

Fix accessing the __rcu pointer direct_functions with RCU protection.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260730150411.88667-4-leon.hwang@linux.dev
Fixes: e93672f770d7 ("ftrace: Add update_ftrace_direct_mod function")
Acked-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6594,6 +6594,7 @@ int update_ftrace_direct_mod(struct ftra
 		.func		= ftrace_stub,
 		.flags		= FTRACE_OPS_FL_STUB,
 	};
+	struct ftrace_hash *direct_hash;
 	struct ftrace_hash *orig_hash;
 	unsigned long size, i;
 	int err = -EINVAL;
@@ -6604,8 +6605,6 @@ int update_ftrace_direct_mod(struct ftra
 		return -EINVAL;
 	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
 		return -EINVAL;
-	if (direct_functions == EMPTY_HASH)
-		return -EINVAL;
 
 	/*
 	 * We can be called from within ops_func callback with direct_mutex
@@ -6613,6 +6612,12 @@ int update_ftrace_direct_mod(struct ftra
 	 */
 	if (do_direct_lock)
 		mutex_lock(&direct_mutex);
+	else
+		lockdep_assert_held_once(&direct_mutex);
+
+	direct_hash = rcu_dereference_protected(direct_functions, lockdep_is_held(&direct_mutex));
+	if (direct_hash == EMPTY_HASH)
+		goto unlock;
 
 	orig_hash = ops->func_hash ? ops->func_hash->filter_hash : NULL;
 	if (!orig_hash)
@@ -6644,7 +6649,7 @@ int update_ftrace_direct_mod(struct ftra
 	size = 1 << hash->size_bits;
 	for (i = 0; i < size; i++) {
 		hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
-			tmp = __ftrace_lookup_ip(direct_functions, entry->ip);
+			tmp = __ftrace_lookup_ip(direct_hash, entry->ip);
 			if (!tmp)
 				continue;
 			tmp->direct = entry->direct;


