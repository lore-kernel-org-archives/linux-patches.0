Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582761CDFAC;
	Sun,  7 Sep 2025 20:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275934; cv=none; b=chWDD/Wi5VS8yVnbSpvNEZr2uuWW2NizLNpTH4ThjZKRC0aBXIsY5qg6kNFzkVM/9FkzHdnf0OQkK+71Qt5QQNqSPvPsxMFOn4mRLnJHlbKHn1UxwqCispPMEE9VHuOhPeXWO6vKCd2NOAZF7kxmBAxMl5h8kCwm9h7GHzp72JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275934; c=relaxed/simple;
	bh=PM+ENQZLkulpFeLxq4rK9e5+wwOFtxxA//qxHHYRrOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A42fMXkHGP+7+PrFPF227qFXIbSS6DCpmP3w97oPe95s0mrM1wa7CoeHBgJtMiCtchOXkMKRvFm2wRcVEH64hwV3brlta9xxFmUF4lwyrTUG80VCwZvA762huGt5oGl88UZRK42/JULpjnsDzuX7ekwlnggs/0z3wczmlsRuZ1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KARu9hmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KARu9hmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B77C4CEF0;
	Sun,  7 Sep 2025 20:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275933;
	bh=PM+ENQZLkulpFeLxq4rK9e5+wwOFtxxA//qxHHYRrOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KARu9hmGpMF3G6jQlfpCW7W1/nNzelqpupTdc92dByTxXE6VR7SWIslSbsvgjXzu9
	 1ytC+4SVDZNPndI12bAntloRVK2bCevBiyhqirvN/0x9cZ/HxtWfN3L1O7c9eqUuOV
	 vr9GhtLlme9ye1+7jJyyDhyEv9atQmM+5XaQeQvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 11/64] netfilter: conntrack: helper: Replace -EEXIST by -EBUSY
Date: Sun,  7 Sep 2025 21:57:53 +0200
Message-ID: <20250907195603.717309185@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 41c9708b50575..de5ac9f431031 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -418,7 +418,7 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 			    (cur->tuple.src.l3num == NFPROTO_UNSPEC ||
 			     cur->tuple.src.l3num == me->tuple.src.l3num) &&
 			    cur->tuple.dst.protonum == me->tuple.dst.protonum) {
-				ret = -EEXIST;
+				ret = -EBUSY;
 				goto out;
 			}
 		}
@@ -429,7 +429,7 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
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



