Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FD3401A29;
	Tue, 21 Jul 2026 17:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654170; cv=none; b=n7pc6KTROktBlJkBZmEG0bl4EHX2Gmn/D+wNSZjM36KrGSFrQmPgr0UMbOBNDJivRHn0sE7SKFqK4IuBhdAgUd+wqeLnNgkCEqtoPBTcoqeXehohMtcuCGdz4gTNExmW6VolUVX2UNwOda7xLUeDyoCrhGqznlY4RJIcWJdfqbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654170; c=relaxed/simple;
	bh=DZCUUAhvHcRIXDO3l5hxgYBGmTio4W5gRno4wR6UvHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buqtu2r8lb9ElZQ8SZLpcDtAhqBRDScwvuXx15todOBUSvMAkvxddBNRbKr7m64fcoLoKpJyCBCIuunL96NQhRGgfTBKtmimErn7KfMJI6Uxy2iRSnp3SDN8cxS5RNtd9qTFrNmx30fFWITZO7agU5aqh0v4mNfArbl2UxPmT8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1a9p9r5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1a9p9r5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D59E1F00A3A;
	Tue, 21 Jul 2026 17:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654168;
	bh=/l14B2iEJrYPqzCkruGPEENzXpzBA5XErqoHA6Tq5cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u1a9p9r5SxemkPYMLj2ffDgb0G5EorJoRIvXpEu8NEBT3RIW+VAHxeu/EaljZwzZz
	 FR/tqzrSHApTs1J2h1DQw6hcLZRm9CVLXum6maFOnxTpa4z0rNLDro9tTcdWNqDoF4
	 +xGVfP9XqOcuYiFjoucit1GgMjJors71+ePuER+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 7.1 1602/2077] netfilter: nfnl_cthelper: apply per-class values when updating policies
Date: Tue, 21 Jul 2026 17:21:15 +0200
Message-ID: <20260721152630.556179297@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

commit d738feccb98cb224ebabecb703e98f5008276bff upstream.

When a userspace conntrack helper with multiple expectation classes is
updated via nfnetlink, every class ends up with the first class's
max_expected and timeout values.

nfnl_cthelper_update_policy_all() validates each new policy into the
corresponding slot of the temporary new_policy array, but the second
loop that commits the values into the live helper dereferences
new_policy as a pointer instead of indexing it, so every iteration
reads new_policy[0] regardless of i.  An update that changes per-class
values is silently collapsed onto class 0's values with no error
returned to userspace.

Index the temporary array by i in the commit loop so each class gets
its own validated values.

Fixes: 2c422257550f ("netfilter: nfnl_cthelper: fix runtime expectation policy updates")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nfnetlink_cthelper.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -354,8 +354,8 @@ static int nfnl_cthelper_update_policy_a
 	for (i = 0; i < helper->expect_class_max + 1; i++) {
 		policy = (struct nf_conntrack_expect_policy *)
 				&helper->expect_policy[i];
-		policy->max_expected = new_policy->max_expected;
-		policy->timeout	= new_policy->timeout;
+		policy->max_expected = new_policy[i].max_expected;
+		policy->timeout	= new_policy[i].timeout;
 	}
 
 err:


