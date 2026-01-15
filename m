Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8378C2D5C9B;
	Thu, 15 Jan 2026 17:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496881; cv=none; b=sFKimF1jO/IuSIX3H3nYmOY3+JzkMDY86jY1HdOOqmJVhlVjW7b+0TXfCm5Px3GWgwwLCoSYu/i9J6reJdiyds4a9/tw0aV+nJrPoywzVRHAAfntiwND1SnYd4tgOvy0I4meFMAT3nfIwxpYzZP6ugdph/M3j/J9kN2KJn9w86Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496881; c=relaxed/simple;
	bh=Ei6Cuadi/SzNMiJ0UzxDP9Rpsv5U9m3a6vAcnz8V8Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qjs76jKPmIuQ6BN4u3UickSF6vS3YXT/k8rmgmuDWhRDWshbfoftgGT0kIEU8GnAaiwOv8WC3dVtnmgW2zlPlEioz27f94FLSx3fdu1A1dsFkPteTH+qvo10cFol1u8Q2sCcmSpFVLekE4uJ/myjnOsZhDwjPOdSvHySj7KrLw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4JmxHp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4JmxHp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05205C116D0;
	Thu, 15 Jan 2026 17:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496881;
	bh=Ei6Cuadi/SzNMiJ0UzxDP9Rpsv5U9m3a6vAcnz8V8Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j4JmxHp6xhsQ++SV2tiZhcsk41Y+flDmDVA3NaZog9gw3hhkBL4q1q35FyYSmdZbU
	 GhKAHdeP96G6LWeOJ2lWS0w3wTt5WUCjzBpKglB3TOaQ+/vxCH7olvTbywUW9cDENE
	 VUpGZ2srrSAfXtsHyLQa0csnzJchFJ9qJB+wMOa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 49/88] netfilter: nf_conncount: update last_gc only when GC has been performed
Date: Thu, 15 Jan 2026 17:48:32 +0100
Message-ID: <20260115164148.085142148@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c00b8e522c5a7..a2c5a7ba0c6fc 100644
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



