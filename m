Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6536F356748;
	Wed, 20 May 2026 17:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297342; cv=none; b=FkqdoR4tPRTr3ncUWrF66UiM3ncLdEibrWBLf6dXOjzI4AeZv3dBcYdqwWHIE2+DbSZyrRYjWVjlWLJRiu4N+mo8PnhxQBzDh4A847N0iIpLmgLcwfZRjG37bvOK6L+JF6+abEsIQ8VJpL9he/ZXaY+rhNqc/+PRLU6CNQ81VDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297342; c=relaxed/simple;
	bh=Mg7/3aTOYNhZrfoaf0ym7OYsDQaqLVmeBlbvmk94WGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiKEdarjhE+9H9LUg3z7Ln2Gp7lA33HwJqomivOWDQ0ALKmUrnr9tDQSLJyHuOYQ4r+ZI/c1GYD3K/izMY2KcQyNRbyAvdARYxwbZsp0u7Vue84hH+xx1mUVZceqnI1vY7pPUUdq0aWX5yaahmoaM1vCW+F0kJZ1ZCagK3mDVJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OkCd2Yv2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OkCd2Yv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24221F000E9;
	Wed, 20 May 2026 17:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297341;
	bh=pOwTtFnfmZZRGI/TZg1bykkBq1bUxa7Ux9tQ3cd/oG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OkCd2Yv2b9mgejN7nXvkFvSPtHw9lwTu5Tja8BJP+f61Uysi3Ed1UPOgB6RujFzee
	 QguDr9+0o7GjpM+NtD8OrlB0NPUD6xctyK1YrzFVI5+au2UrdOBbDIcocDuJ1Hfj+S
	 AR4A+7rqHIOC4V4wqME35fVHJylReRrFY+GASOHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1143/1146] eventfs: Use list_add_tail_rcu() for SRCU-protected children list
Date: Wed, 20 May 2026 18:23:13 +0200
Message-ID: <20260520162214.122340362@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

[ Upstream commit f67950b2887fa10df50c4317a1fe98a65bc6875b ]

Commit d2603279c7d6 ("eventfs: Use list_del_rcu() for SRCU protected
list variable") converted the removal side to pair with the
list_for_each_entry_srcu() walker in eventfs_iterate(). The insertion
in eventfs_create_dir() was left as a plain list_add_tail(), which on
weakly-ordered architectures can expose a new entry to the SRCU reader
before its list pointers and fields are observable.

Use list_add_tail_rcu() so the publication pairs with the existing
list_del_rcu() and list_for_each_entry_srcu().

Fixes: 43aa6f97c2d0 ("eventfs: Get rid of dentry pointers without refcounts")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260418152251.199343-1-devnexen@gmail.com
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -710,7 +710,7 @@ struct eventfs_inode *eventfs_create_dir
 
 	scoped_guard(mutex, &eventfs_mutex) {
 		if (!parent->is_freed)
-			list_add_tail(&ei->list, &parent->children);
+			list_add_tail_rcu(&ei->list, &parent->children);
 	}
 	/* Was the parent freed? */
 	if (list_empty(&ei->list)) {


