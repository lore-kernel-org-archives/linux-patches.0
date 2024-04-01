Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C294654F;
	Mon,  1 Apr 2024 16:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989934; cv=none; b=M7F1igaLO0owjrRD/HkjzCJPglboTeddYOmalHQd8EvQ6T3zJMYAnXB0wijoW9ULUPiQLu7cDldOK8f3k4ZEYr8d7aZIp1U1yYxtOxwkRLmbhpUhu1tzydidxHY6epLfau3jlXXxEDS8gR+eV5fCONUWrizyij2nNuwmpCEJDTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989934; c=relaxed/simple;
	bh=T1Dwsfsc8FaCp6r+hopjVPC0B23iq+eQiQQnb0svXo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Js3VGYimUqS3RR2wZRtn+H0on+Wp12K1JmPkWtYfUqxEknSIingd6EVN7FY0fgECKr4zjeSn5yJgDjU5RBhc/j97wjF3W8EA17KqgAMrtG3tNyMGuXO684LL2qlu9kiyhGy7iRITvbakKZulk1yI1NR5v6ucKVU3jXtGX53C5qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqpD4aFp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqpD4aFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DD7C433F1;
	Mon,  1 Apr 2024 16:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989933;
	bh=T1Dwsfsc8FaCp6r+hopjVPC0B23iq+eQiQQnb0svXo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kqpD4aFp8lvbzOC3GRH0xhC6Q9ffe6NBmSVxGY8wl0gbVkMFAYV6UeuArciESvaB0
	 BUTxtC6LMY5rtLNx9dWRlXqmGjeGstptJqlUOZhfzcHHGTCucoogMp9Au+y5XPhhwj
	 /uX8b0jgI8rNSLZLTo3S1JiypbUOpj0h+lywh5pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingi Cho <mgcho.minic@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 197/396] netfilter: nf_tables: mark set as dead when unbinding anonymous set with timeout
Date: Mon,  1 Apr 2024 17:44:06 +0200
Message-ID: <20240401152553.808672612@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 552705a3650bbf46a22b1adedc1b04181490fc36 upstream.

While the rhashtable set gc runs asynchronously, a race allows it to
collect elements from anonymous sets with timeouts while it is being
released from the commit path.

Mingi Cho originally reported this issue in a different path in 6.1.x
with a pipapo set with low timeouts which is not possible upstream since
7395dfacfff6 ("netfilter: nf_tables: use timestamp to check for set
element timeout").

Fix this by setting on the dead flag for anonymous sets to skip async gc
in this case.

According to 08e4c8c5919f ("netfilter: nf_tables: mark newset as dead on
transaction abort"), Florian plans to accelerate abort path by releasing
objects via workqueue, therefore, this sets on the dead flag for abort
path too.

Cc: stable@vger.kernel.org
Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Reported-by: Mingi Cho <mgcho.minic@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5367,6 +5367,7 @@ static void nf_tables_unbind_set(const s
 
 	if (list_empty(&set->bindings) && nft_set_is_anonymous(set)) {
 		list_del_rcu(&set->list);
+		set->dead = 1;
 		if (event)
 			nf_tables_set_notify(ctx, set, NFT_MSG_DELSET,
 					     GFP_KERNEL);


