Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0768D351C2E;
	Wed,  8 Apr 2026 18:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673024; cv=none; b=u+85QNtb03VpSYHFvlNgXcVtdiGBGFHZYqLxL3jCUP+23y7bTvKxJ0hoYcAtBHFkjCKuWZ6bKDHczJ4D8TL15m8vmVJmGbRNl8yPUxwyaqdYwp5DZY5YzI42r89+TpCXPqrRKxAOsetgup2lK679nNKLzIckb91TJwpn4bBxNAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673024; c=relaxed/simple;
	bh=iCBQzHrAO9Emb01UicYn05/2GsrtpCd1YTONS5CON5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXvEBXpmc3GI+NDEaerrGsDjWkAiqZ7gESjZDU3X64v26FvsEe9odxp0kvH12FXw8KMVLywx16qP2qR/K9McqBCgvtGJ6I14m0mA2BqmPtBQEzoY8XmTNwVrG5ZtyPccvscxPQh6bctid7ilNjvl6YvEV93C7k7pJ0Ty7SFDsuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L094HtHY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L094HtHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925E9C19421;
	Wed,  8 Apr 2026 18:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673023;
	bh=iCBQzHrAO9Emb01UicYn05/2GsrtpCd1YTONS5CON5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L094HtHYgfodE4N65EjbqismheWLF+t7vpxaHnqVEzS2TAmCBHHOtZuP5R7YCx5Na
	 LA5VxFcVI5sncUMuDp1VjzBPsn2+gPsmaPVeopkRmhaQwWk5pxcaik6h7Xb3yvGKAH
	 YTRNRaxwnhR5naJebnkurfi550VveQSfrstefY8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Tang <tpluszz77@gmail.com>,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 070/277] netfilter: nf_conntrack_helper: pass helper to expect cleanup
Date: Wed,  8 Apr 2026 20:00:55 +0200
Message-ID: <20260408175936.474558733@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qi Tang <tpluszz77@gmail.com>

[ Upstream commit a242a9ae58aa46ff7dae51ce64150a93957abe65 ]

nf_conntrack_helper_unregister() calls nf_ct_expect_iterate_destroy()
to remove expectations belonging to the helper being unregistered.
However, it passes NULL instead of the helper pointer as the data
argument, so expect_iter_me() never matches any expectation and all
of them survive the cleanup.

After unregister returns, nfnl_cthelper_del() frees the helper
object immediately.  Subsequent expectation dumps or packet-driven
init_conntrack() calls then dereference the freed exp->helper,
causing a use-after-free.

Pass the actual helper pointer so expectations referencing it are
properly destroyed before the helper object is freed.

  BUG: KASAN: slab-use-after-free in string+0x38f/0x430
  Read of size 1 at addr ffff888003b14d20 by task poc/103
  Call Trace:
   string+0x38f/0x430
   vsnprintf+0x3cc/0x1170
   seq_printf+0x17a/0x240
   exp_seq_show+0x2e5/0x560
   seq_read_iter+0x419/0x1280
   proc_reg_read+0x1ac/0x270
   vfs_read+0x179/0x930
   ksys_read+0xef/0x1c0
  Freed by task 103:
  The buggy address is located 32 bytes inside of
   freed 192-byte region [ffff888003b14d00, ffff888003b14dc0)

Fixes: ac7b84839003 ("netfilter: expect: add and use nf_ct_expect_iterate helpers")
Signed-off-by: Qi Tang <tpluszz77@gmail.com>
Reviewed-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index ceb48c3ca0a43..9d7d36ac83083 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -419,7 +419,7 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	 */
 	synchronize_rcu();
 
-	nf_ct_expect_iterate_destroy(expect_iter_me, NULL);
+	nf_ct_expect_iterate_destroy(expect_iter_me, me);
 	nf_ct_iterate_destroy(unhelp, me);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
-- 
2.53.0



