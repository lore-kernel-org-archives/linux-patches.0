Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4924071E3;
	Tue, 21 Jul 2026 17:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655048; cv=none; b=oRpp33OMQmPtw3rlYyUkmY7PyTy4WDLdVGQ9+LO69MFIYQbq7nVnsojLnPsls/y1RpEOwnPdcyheyrLxJT1ndLSiN8M7E8WouPkk3hjaWqr4JaHtqLW3PyUuK+RqUwuSYjuqIW3HLCQUsrJ/zDhbGk0HR7eOeJH6OLq99iW283A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655048; c=relaxed/simple;
	bh=fJyrORnnmzm5b7XQW7UrUsf9p8i480HzgJbOdovwBQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVkQMayynUifudPj96Ab4qAjS+9eQDPxx5OnWCPjNVjcQyTrclKyXFF3wl5vfhoTM4eEV7Zbgzre+v4cksL/b7leyR120kT1qou8wLnx4utXKwgZJ1gZDhntxs2vD4KZA2DaxBieX7lFRmpDzy/qtFqNBDnndeEqV6T7dt+diis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MkSWogv9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MkSWogv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2B31F00A3D;
	Tue, 21 Jul 2026 17:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655047;
	bh=gjoVezeo12dmBBjxkc8r4TZ9mGqIjwOWs94Z3Y5QrYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MkSWogv9AvVCT9eIPf9U6m2cRQQVca4P5P8ZFcQu9ez3kQzgpRgBqLbOZQRBl99FV
	 KHb9RFuDRfWf4k3ZijYcCLgmLfx9/3CpMESlMTOAYsMkQuXEZ1WjRcftWg9UieXhob
	 iWoAr3/nCXuRd+eTrxDSQ0OuW0gQkoMLjoFrlxog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 7.1 1934/2077] netfilter: nfnetlink_cthelper: cap to maximum number of expectation per master on updates
Date: Tue, 21 Jul 2026 17:26:47 +0200
Message-ID: <20260721152638.326211167@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 278296b69fae5dd951599692cd481bae4995215c upstream.

Really cap it to NF_CT_EXPECT_MAX_CNT (255) on updates.

The commit ("netfilter: nfnetlink_cthelper: cap to maximum number of
expectation per master") only covers creation of helpers, not updates.

Fixes: 397c8300972f ("netfilter: nf_conntrack_helper: cap maximum number of expectation at helper registration")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nfnetlink_cthelper.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -316,6 +316,8 @@ nfnl_cthelper_update_policy_one(const st
 
 	new_policy->max_expected =
 		ntohl(nla_get_be32(tb[NFCTH_POLICY_EXPECT_MAX]));
+	if (!new_policy->max_expected)
+		new_policy->max_expected = NF_CT_EXPECT_MAX_CNT;
 	if (new_policy->max_expected > NF_CT_EXPECT_MAX_CNT)
 		return -EINVAL;
 


