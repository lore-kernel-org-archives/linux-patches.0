Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A861C8FCF;
	Tue, 27 Aug 2024 15:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772648; cv=none; b=DOiJWFZ8Pv7HF0Kb8iH8h46waMja3IUoGj/KBDYhWVor61dFAKDSwtXDFcNRgrRl0o3U/ljpXq98UYkZKF7V50dztRdvQ8V/7coMLwBEprhSSLWzoKKiFbfopSHSubjFPuxy8RGERafgkfo8/OjdZVew9FkA9eu5C/+Ddm0RyYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772648; c=relaxed/simple;
	bh=yTWvek5LpIowtjvLJVm09eYUa0f1EfTHya2oz8sqd5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ro/sFJ5EZJfMdU7c801S++I05rfwZ+jntC3GGItbJFv5/FXp/5whhTC5hGlQDdveSQf3VQ0U7n8rAtQxcHuF6eXJdF1nzXqHvQiTClRDqfARIJ9Ry3VkpPvXkXDVcShOVaSqqZY293elmQ6MytuTq9CgwvT+jLJCF+AtZUGD3TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYHc9zaL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYHc9zaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C6EC4DDE6;
	Tue, 27 Aug 2024 15:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772647;
	bh=yTWvek5LpIowtjvLJVm09eYUa0f1EfTHya2oz8sqd5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYHc9zaLPkwZ+c+6+MKrDhD9Dp1lgAokBIU0jtz44R+7P3LyNJiU4O9xo3MchgW0n
	 8eBOPpBzu1RBeqNVp6ZXvOx1J3RWu9GSX0uaQ+q0YY8pmzuEESwWOUnmvw+VtdMAj1
	 k+gUfBMcIA63x5Mh90/N0t+GdsfM2/iHIn4AZFzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 278/321] mptcp: pm: re-using ID of unused flushed subflows
Date: Tue, 27 Aug 2024 16:39:46 +0200
Message-ID: <20240827143848.834613342@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit ef34a6ea0cab1800f4b3c9c3c2cefd5091e03379 upstream.

If no subflows are attached to the 'subflow' endpoints that are being
flushed, the corresponding addr IDs will not be marked as available
again.

Mark all ID as being available when flushing all the 'subflow'
endpoints, and reset local_addr_used counter to cover these cases.

Note that mptcp_pm_remove_addrs_and_subflows() helper is only called for
flushing operations, not to remove a specific set of addresses and
subflows.

Fixes: 06faa2271034 ("mptcp: remove multi addresses and subflows in PM")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240819-net-mptcp-pm-reusing-id-v1-5-38035d40de5b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1666,8 +1666,15 @@ void mptcp_pm_remove_addrs_and_subflows(
 		mptcp_pm_remove_addr(msk, &alist);
 		spin_unlock_bh(&msk->pm.lock);
 	}
+
 	if (slist.nr)
 		mptcp_pm_remove_subflow(msk, &slist);
+
+	/* Reset counters: maybe some subflows have been removed before */
+	spin_lock_bh(&msk->pm.lock);
+	bitmap_fill(msk->pm.id_avail_bitmap, MPTCP_PM_MAX_ADDR_ID + 1);
+	msk->pm.local_addr_used = 0;
+	spin_unlock_bh(&msk->pm.lock);
 }
 
 static void mptcp_nl_remove_addrs_list(struct net *net,


