Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A522D73BE;
	Thu, 15 Jan 2026 17:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496586; cv=none; b=uMRZWUECtYeKf3BWw4YJDbCflQxHg3JYNjOwFbVd8TtdOtsQo8REdoGS/j3Du49ioMVhOAcmlsyqYmI9HYh4PJqjJU/HkNoNsXrrNVGTj96yK9sfuSLEmAL2LO6VBCIw5fyS06t4kILpR3yFrVhLUI2jWNv1nhKeG3pAe3WWO5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496586; c=relaxed/simple;
	bh=tFlVnIQEStf/XH5ABTmZyz0BamqSFlhOyIurXDJM2/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXUG8Ar6hGrqAr9J8TtfspUg4e5ZxwezmUExvaI4WX75u3PuhgzVA30GL0PXdEodMK5wejAooHVdHF2OdGnFgP3vtZlbI1FkfwiozVOr5+t5rwIKG+gIAZ4VzRRvNL40dX+WZwWOrA/xm6d8WA2cBwp1LNY9Dy0SpPCwzQ1XyuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDkLHMzm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDkLHMzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B4CC116D0;
	Thu, 15 Jan 2026 17:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496586;
	bh=tFlVnIQEStf/XH5ABTmZyz0BamqSFlhOyIurXDJM2/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDkLHMzmcQ+SRKpX9AewvnrZFYRIriGR7zi4bxnOeAhGti+O0PKDV4ANK0PBa0mXc
	 Pjs4//ohtqlrWLrlEjn5cDNSswbxv+tIGA5pMUvU3TX3U/ZNy3YLdkziH8/P453ab1
	 awr01vwueEgdUo+3kRV19lKebr9WVzWjJ7/0QGjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/119] netfilter: nf_conncount: update last_gc only when GC has been performed
Date: Thu, 15 Jan 2026 17:47:58 +0100
Message-ID: <20260115164154.230450359@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 7811ba452402d58628e68faedf38745b3d485e3c ]

Currently last_gc is being updated everytime a new connection is
tracked, that means that it is updated even if a GC wasn't performed.
With a sufficiently high packet rate, it is possible to always bypass
the GC, causing the list to grow infinitely.

Update the last_gc value only when a GC has been actually performed.

Fixes: d265929930e2 ("netfilter: nf_conncount: reduce unnecessary GC")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conncount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 3c1b155f7a0ea..828d5c64c68a3 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -229,6 +229,7 @@ static int __nf_conncount_add(struct net *net,
 
 		nf_ct_put(found_ct);
 	}
+	list->last_gc = (u32)jiffies;
 
 add_new_node:
 	if (WARN_ON_ONCE(list->count > INT_MAX)) {
@@ -248,7 +249,6 @@ static int __nf_conncount_add(struct net *net,
 	conn->jiffies32 = (u32)jiffies;
 	list_add_tail(&conn->node, &list->head);
 	list->count++;
-	list->last_gc = (u32)jiffies;
 
 out_put:
 	if (refcounted)
-- 
2.51.0



