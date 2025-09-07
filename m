Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFCE14BFA2;
	Sun,  7 Sep 2025 20:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276316; cv=none; b=iDqU3aq6u1+ybKCDG6zYUoNXXRHbNYJu59HkkSrzfjzqD6bHSCFZvRDaqZnQsgNBhfD5/tnGwrLwcwqhgRDc1tleFOBTI8msifNuzVphmvLRlXTQk0rM2HIJlrWXGREZkTtu0jKxkPvxDS7/5wakUNLMlpGnu4BBeRZDHA6VaAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276316; c=relaxed/simple;
	bh=2JkCv590iNQphYE+dJSExbgMSYmB4EcmUWlzpvvMm1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xm/qMYAjfsW+d9lwWvtRlcQYJn502YgLa0pe+3KJd1NDAWKLpzoLUOd2elOEd6EU6nqtaGXZQR1R6X1AFbnvEMVyuqCpWGaKRDLWMihTEuaGt6kSHKMd5kM4FG74HmpAjMHvYmIPoYZG5jcILuh8oRCLwloLDZtTiXMPcthqtf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kwbc+wW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kwbc+wW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F4DC4CEF0;
	Sun,  7 Sep 2025 20:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276316;
	bh=2JkCv590iNQphYE+dJSExbgMSYmB4EcmUWlzpvvMm1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kwbc+wW+NyYOXj8B+tELZnZenIGvxo+d0FwOm+zplZbZC7XGeMyXQ8y8qx6LOAxKL
	 3ayDjv9mBD2fFKHoEqmXKnByC6Y56uBK5M13xv1MSKoY3GVTbPFp/TVXfiUIBdzfri
	 J/PhIWkQ+ccZAND7gZwZyaumOU/XTHTUE3KiX7fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/104] netfilter: conntrack: helper: Replace -EEXIST by -EBUSY
Date: Sun,  7 Sep 2025 21:57:35 +0200
Message-ID: <20250907195608.157765781@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bf09a1e062481..5545016c107db 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -371,7 +371,7 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 			    (cur->tuple.src.l3num == NFPROTO_UNSPEC ||
 			     cur->tuple.src.l3num == me->tuple.src.l3num) &&
 			    cur->tuple.dst.protonum == me->tuple.dst.protonum) {
-				ret = -EEXIST;
+				ret = -EBUSY;
 				goto out;
 			}
 		}
@@ -382,7 +382,7 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
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



