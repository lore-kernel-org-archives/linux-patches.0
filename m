Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532AE426D03;
	Mon, 17 Aug 2026 14:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978354; cv=none; b=JTgiES1bhH80pf21JRaNh7QV4k7mEOOhE4BXtmbzcjl/d2XEEg99u0gZbMASvT5WMPe8A0/a6jFgXw6ndKWMVIkPADj62T3sgdikjrbx2wNlCaQsMdV80clBrNk/R6HUstnX45kL9jH085ogZxnAhCcptBqNGFLa2T4l+jZyMr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978354; c=relaxed/simple;
	bh=4MAJjXBPvLXARTEhIOigEY66CeWGSnx8BWOG4jmZ4kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kku1hQFLkkqDCUmTkTMZhwqH3mdclkxp4WbfGRfSuFkkQw95IdAh+fSENc401aAMQ1m9Dsa3cwgztmxLihL5kXZZZkvSva99lC0IT5yj9JCMNoL71ehJBxYOxbYAmgHASo5A8IrWN/Ox//z9FBtWu1SXx/9c7ckQyKOa4EuJM+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eUjm4zvC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eUjm4zvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3C41F000E9;
	Mon, 17 Aug 2026 14:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978353;
	bh=pW8e19XIXEs6HAjOqzM8otaK1T3a24hcb8W1K6KdRGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eUjm4zvCAFpLRfH9IALga1Ehk9UWiE6Xc3jMsBb8kMWMzxcgSYQqz1n4DuQ7tqCSN
	 Xa4PaVvNu1QNqDtebKQf74VZCIVOOyFu7pE00zwRaVzvQI3ry03TNTUYF+CanIMj7U
	 jF4uCB0Cab/HZZzh5gb/zo7qvX8dzgA78ryjYg2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 162/181] eventfs: Fix use-after-free in eventfs_remove_rec()
Date: Mon, 17 Aug 2026 15:34:16 +0200
Message-ID: <20260817132542.060261077@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit fd73b691702170d37d66f4b0278530cea8ed419a upstream.

eventfs_remove_rec() recursively removes the child at the current loop
position. After the recursive call returns, list_for_each_entry() advances
by reading list.next from the removed child.

If free_ei() drops the final reference, release_ei() reuses the list/rcu
union to queue an SRCU callback. The child may be freed before that read.
The eventfs_mutex serializes list updates, but it does not keep the removed
child alive or prevent the SRCU callback from running.

Use list_for_each_entry_safe() to save the next sibling before recursively
removing the current child.

Cc: stable@vger.kernel.org
Fixes: 43aa6f97c2d0 ("eventfs: Get rid of dentry pointers without refcounts")
Link: https://patch.msgid.link/20260806022719.375354-1-shuangpeng.kernel@gmail.com
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -849,7 +849,7 @@ struct eventfs_inode *eventfs_create_eve
  */
 static void eventfs_remove_rec(struct eventfs_inode *ei, int level)
 {
-	struct eventfs_inode *ei_child;
+	struct eventfs_inode *ei_child, *tmp;
 
 	/*
 	 * Check recursion depth. It should never be greater than 3:
@@ -862,7 +862,7 @@ static void eventfs_remove_rec(struct ev
 		return;
 
 	/* search for nested folders or files */
-	list_for_each_entry(ei_child, &ei->children, list)
+	list_for_each_entry_safe(ei_child, tmp, &ei->children, list)
 		eventfs_remove_rec(ei_child, level + 1);
 
 	list_del_rcu(&ei->list);


