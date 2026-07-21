Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074BB470124;
	Tue, 21 Jul 2026 19:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660595; cv=none; b=MKjgf1mwzyrjdott1PDjDO/cxnkOErsu4DvUfMrOCaqjf019TVvn+L6y3XYmgXrhO4aUKaepoki/5Fqm8QFG/p+P7MEqPf6h8TrLixRoZkliIuc2g6JtD5VmicRYF9VEZfys4zMkC3982YijPV4J7LkK70PFUJ2qf6FBbkFn8tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660595; c=relaxed/simple;
	bh=30FE92119d0e8R5SG7rUZ6ucoeDpez75ExWa0Aup14o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XphCGgUaYeUpTO3fOKiHHN4YVu6BH1VJKT98m39NBnnkN8j3UVtgobpS04nBbkt0Y1dPtFiItshFYdW8170UHxwRfPe+CfyipQ+D7It5Rb+WraBgQ5/i9+OZJIB7Y1zz+z9PMtz+M9u82IT5Vz9uFhLMODV7L7jAuVVbMZl0eqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQ6SCozR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQ6SCozR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82961F00A3A;
	Tue, 21 Jul 2026 19:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660592;
	bh=EE6avNg/mEYzdQ53HJTQA7Z7bPaZIHY9VDHFmYdJhsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AQ6SCozRW8gJ36z4zep9B4rJ542yajS2Tsad8dbMJMec5KBLPYMy2Okxzo4NLwc4w
	 XQuCIO+t6xb2U8JRcVGlB3Lbs5dOMvZTFP4PV5kp7+xHA9gSOmrjamcCxf8SZ9WaMh
	 BOa78EzWazUdZdPXnoi3JSrxWS0e+8fnnToLX1Rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1038/2077] apparmor: fix refcount leak when updating the sk_ctx
Date: Tue, 21 Jul 2026 17:11:51 +0200
Message-ID: <20260721152617.295364113@linuxfoundation.org>
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

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 6d25e7b47616cb2db43351210929c8f19dc305a3 ]

Currently update_sk_ctx() transfers the plabel reference, unfortunately
it is also unconditionally put in the caller. Ideally we would make
the caller conditionally put the reference based on whether it was
transferred but for now just fix the bug by getting a reference.

Fixes: 88fec3526e841 ("apparmor: make sure unix socket labeling is correctly updated.")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/af_unix.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/af_unix.c b/security/apparmor/af_unix.c
index 23753cb2096e53..834a3b1c2f0af4 100644
--- a/security/apparmor/af_unix.c
+++ b/security/apparmor/af_unix.c
@@ -674,9 +674,11 @@ static void update_sk_ctx(struct sock *sk, struct aa_label *label,
 		old = rcu_dereference_protected(ctx->peer, lockdep_is_held(&unix_sk(sk)->lock));
 
 		if (old == plabel) {
-			rcu_assign_pointer(ctx->peer_lastupdate, plabel);
+			rcu_assign_pointer(ctx->peer_lastupdate,
+					   aa_get_label(plabel));
 		} else if (aa_label_is_subset(plabel, old)) {
-			rcu_assign_pointer(ctx->peer_lastupdate, plabel);
+			rcu_assign_pointer(ctx->peer_lastupdate,
+					   aa_get_label(plabel));
 			rcu_assign_pointer(ctx->peer, aa_get_label(plabel));
 			aa_put_label(old);
 		} /* else race or a subset - don't update */
-- 
2.53.0



