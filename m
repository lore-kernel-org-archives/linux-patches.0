Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C330E3D890F;
	Wed,  8 Apr 2026 18:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674412; cv=none; b=Cg8NWEYWhAL9REN2ywBtujl0gB7D6GsoocoHIX953k3AzPeWJTf4BHUUAvWth5pvEK1oHmMm2EKDkxqCxttXUuwGI4sOzp87WFFmFZ7XhSvbE9hdGp1RJg2D8wAFt/4Y5quWfFzVelcNaxieaxr8BN6Qf9TJoo74q9QIUhqVIXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674412; c=relaxed/simple;
	bh=8Azpn56RMyePSjV6O3ZJZrLu3yXs2yaaHCBOTIzxBpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDzRTMLCzb++a+W/CfDXjwDSn51P+AHkdUeVLyXJh65Q5rzJppEIgSRUcdq2eSXa1RxpAG+uN5LH0v6+UU9dngq+VPIvs2/MsNyzYv0yGFA9yQlE0siW8tidPyUjUNav43egxJovXxdi4PtkKePb5yTXl4r/yeAL6pk57Yz1ecY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T4zaZhT2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T4zaZhT2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597A7C19421;
	Wed,  8 Apr 2026 18:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674412;
	bh=8Azpn56RMyePSjV6O3ZJZrLu3yXs2yaaHCBOTIzxBpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T4zaZhT25PW+5CZyDNSaD5j/oNBdOzaaNFccAGf/rIsSXbCSEeALZXTVl9R8r2C41
	 7CGq6EcJHbO7QAmCWbsQHYT1XCiBw1CSeul6UmVu8BXWyvb/+KCOYbo/LwJwccGHSN
	 xB+uERaZOw4Y2sxAt8dCk/72nnRfK9j36lgrR8f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Tang <tpluszz77@gmail.com>,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 087/311] netfilter: nf_conntrack_helper: pass helper to expect cleanup
Date: Wed,  8 Apr 2026 20:01:27 +0200
Message-ID: <20260408175942.662451334@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



