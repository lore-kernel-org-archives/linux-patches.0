Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9723151CE9;
	Tue, 20 Feb 2024 21:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464264; cv=none; b=C9rhSbBuC4B1uXxrvMvPhbG1gL3y/LjzTUZhk+KQvAn/7n13zD1upmCCtgHwN797QXeczAWpVqBnRX5a0K86gwD6xlqcTEAxzIRM/BvrZBBdnwP3JTyp8RIKLzB9eKOFqkgPPoxyh/1lwAfdAL5NrV3HJWIT1AbiwReJ60aWzw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464264; c=relaxed/simple;
	bh=MM+7WmqMzWiWDZIbtNU+jsNi6ytYn+CMWJkkqqWVGa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXi9tTQGxMcphZnEgMrykmEnS+ROpMHC6PGnH6IHkAmqfuXt2tAN0OKsH9TwmnRAIYn4NH75Jaul00fBp0xItuLpb1LWAGXiZvPAw4BznM+KBG8XEjKSoWgIekToIDDxjsphr1iUfSzs7e1WoJAEJBmjM6zX7RKenWqTSxy+SRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=totcupWE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="totcupWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A8EC433F1;
	Tue, 20 Feb 2024 21:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464263;
	bh=MM+7WmqMzWiWDZIbtNU+jsNi6ytYn+CMWJkkqqWVGa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=totcupWEMeyVcgB/njtvkbR8RHFFE9seohgCc2+W32JyGnl8XQJask9o4gzeIK+b0
	 1DeXWUkj2eL4kchv0xwh1sbPGyFawCERYyF+uIfrM6uOh1jo/vcNgSwOKUMIZLiygF
	 1ugmBhJjg16hNY3sJFiw1/z4DJwgB7Ju4ROiCkhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Erick Archer <erick.archer@gmx.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 301/331] eventfs: Use kcalloc() instead of kzalloc()
Date: Tue, 20 Feb 2024 21:56:57 +0100
Message-ID: <20240220205647.555928502@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erick Archer <erick.archer@gmx.com>

commit 1057066009c4325bb1d8430c9274894d0860e7c3 upstream.

As noted in the "Deprecated Interfaces, Language Features, Attributes,
and Conventions" documentation [1], size calculations (especially
multiplication) should not be performed in memory allocator (or similar)
function arguments due to the risk of them overflowing. This could lead
to values wrapping around and a smaller allocation being made than the
caller was expecting. Using those allocations could lead to linear
overflows of heap memory and other misbehaviors.

So, use the purpose specific kcalloc() function instead of the argument
size * count in the kzalloc() function.

[1] https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments

Link: https://lore.kernel.org/linux-trace-kernel/20240115181658.4562-1-erick.archer@gmx.com

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Link: https://github.com/KSPP/linux/issues/162
Signed-off-by: Erick Archer <erick.archer@gmx.com>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -97,7 +97,7 @@ static int eventfs_set_attr(struct mnt_i
 	/* Preallocate the children mode array if necessary */
 	if (!(dentry->d_inode->i_mode & S_IFDIR)) {
 		if (!ei->entry_attrs) {
-			ei->entry_attrs = kzalloc(sizeof(*ei->entry_attrs) * ei->nr_entries,
+			ei->entry_attrs = kcalloc(ei->nr_entries, sizeof(*ei->entry_attrs),
 						  GFP_NOFS);
 			if (!ei->entry_attrs) {
 				ret = -ENOMEM;
@@ -874,7 +874,7 @@ struct eventfs_inode *eventfs_create_dir
 	}
 
 	if (size) {
-		ei->d_children = kzalloc(sizeof(*ei->d_children) * size, GFP_KERNEL);
+		ei->d_children = kcalloc(size, sizeof(*ei->d_children), GFP_KERNEL);
 		if (!ei->d_children) {
 			kfree_const(ei->name);
 			kfree(ei);
@@ -941,7 +941,7 @@ struct eventfs_inode *eventfs_create_eve
 		goto fail;
 
 	if (size) {
-		ei->d_children = kzalloc(sizeof(*ei->d_children) * size, GFP_KERNEL);
+		ei->d_children = kcalloc(size, sizeof(*ei->d_children), GFP_KERNEL);
 		if (!ei->d_children)
 			goto fail;
 	}


