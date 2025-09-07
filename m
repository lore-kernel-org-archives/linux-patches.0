Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAC01A9FAA;
	Sun,  7 Sep 2025 20:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276510; cv=none; b=ubPT+zL2zzCnsVfyhfPUzFqoxN7ElaSdK5jO46KPwn2Bo1Lsv1QDe2ncKFR7sQGDscnw/s9TdetierlmM27iDSAhRX4EVz7OBCFxtEkLUVw4zD8JPYuGXbsiefeu7xZk07r1Ni3QXtDaOCWgvpfnP1yQsfQhlVNmInaMVGpbFCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276510; c=relaxed/simple;
	bh=f9ZAj6sU1t9S2PZIyDI+zLcVVRRJHgpoU20UzrYchcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bE96mEqXJUo2LPPGiZNGTnfy/vWQpBPUDkrdmCrnUxtMMt4InaN/1CAqwkyFxMs/iKknMd81kmOMH5ZxXshFDSw5dCPKPm57+q+DVoU6szAtt67o6dROWG17cKtZjc4FFvJTFZcRr3ieLiIPoAmVlaqYEGVBSZdVzLVMD4n6O78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDp6VbTo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDp6VbTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2FCC4CEF0;
	Sun,  7 Sep 2025 20:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276509;
	bh=f9ZAj6sU1t9S2PZIyDI+zLcVVRRJHgpoU20UzrYchcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDp6VbTo4ZbVY3I+xkU+G+XjoG+QS3Foi/4J2ip6Lr2IbkzpTev1RnjG/mnuCkZvs
	 0KT1gSWPpzDi4n9NkEZAm6tqOK0IAKuciXl1+aS27FKbolft6JcApFEBfKrIbvoYS4
	 2ln4I+lJeeLBV6MvmJZ3pwXDVYLfNktAA4376u+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/121] netfilter: conntrack: helper: Replace -EEXIST by -EBUSY
Date: Sun,  7 Sep 2025 21:57:38 +0200
Message-ID: <20250907195610.385887831@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 54416fd76770bd04fc3c501810e8d673550bab26 ]

The helper registration return value is passed-through by module_init
callbacks which modprobe confuses with the harmless -EEXIST returned
when trying to load an already loaded module.

Make sure modprobe fails so users notice their helper has not been
registered and won't work.

Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Fixes: 12f7a505331e ("netfilter: add user-space connection tracking helper infrastructure")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_helper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index f22691f838536..10f72b5b4e1ad 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -373,7 +373,7 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 			    (cur->tuple.src.l3num == NFPROTO_UNSPEC ||
 			     cur->tuple.src.l3num == me->tuple.src.l3num) &&
 			    cur->tuple.dst.protonum == me->tuple.dst.protonum) {
-				ret = -EEXIST;
+				ret = -EBUSY;
 				goto out;
 			}
 		}
@@ -384,7 +384,7 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 		hlist_for_each_entry(cur, &nf_ct_helper_hash[h], hnode) {
 			if (nf_ct_tuple_src_mask_cmp(&cur->tuple, &me->tuple,
 						     &mask)) {
-				ret = -EEXIST;
+				ret = -EBUSY;
 				goto out;
 			}
 		}
-- 
2.50.1



