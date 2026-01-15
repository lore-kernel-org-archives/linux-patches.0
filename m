Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EA41A2389;
	Thu, 15 Jan 2026 17:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498732; cv=none; b=paLCivJDyf1P2du5j/BVMAom/Dvee00A++FVX6D5aI9x88fKmulOK1j/JEGsMaZIlzhnM4215x8BKa4z/f3JGgWTn9DnCeLnVb2RccQYpfjgB9P2WXrz/MseyTUE9HQ3edojnaacQTZYUxrJ7n6aOZJnHpEe6/kqo509jkBun/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498732; c=relaxed/simple;
	bh=vSw4vrZSegp4HbwplO10fqb7+4xGTmmcDQH4trYu30k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgvJGiHgdW5JPLhAoewQn6IByfXyV2xWMfA5v6wiKbUL8cSXlOwWdC/8JuEYgBJVxYwI5VAvohdiK2YurqRgVJvs6YBZ/zUgEY6Nl6hW23+rhfgfCgn/f/wNIjeBIfwdpihswwlwRsHJiqyOooMbMLDNRRIZRlCzWYHwr8b5wx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ybk6w8Gu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ybk6w8Gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82520C116D0;
	Thu, 15 Jan 2026 17:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498731;
	bh=vSw4vrZSegp4HbwplO10fqb7+4xGTmmcDQH4trYu30k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ybk6w8GuZ2+H3mJAHY7SHVuTlPCRw+pedpnhopDMNh2c+mv0NFjLdLjScM5eKPFi3
	 Td49nB8phZJIIEYkHnOr7CuhCfm8yJjYpeqM/K4uz1L60Pzzl7MgOzGfMpcJ10OfdF
	 tYoiXnYu/nLNLQDKCAZnnA9NsVjjjsLU+zRcEm9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 527/554] netfilter: nf_conncount: update last_gc only when GC has been performed
Date: Thu, 15 Jan 2026 17:49:53 +0100
Message-ID: <20260115164305.403032804@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



