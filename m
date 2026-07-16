Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AE440A954;
	Thu, 16 Jul 2026 14:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210827; cv=none; b=m2Q6RtbmTdO3m1Mk0UsDCqx7wuiIe+4RTrjGuh/B4Df/3ZVREdNk7b68sI81mDsSkamnyTiG4CQclnFBm0UflngV3JW+9Nuk9nRcrHTkzGKZXb7rfUCSmq2Ou9k9we8MiEu7NAbpm7d1W1J67XQwfAjiLUzAa5GDQS1Ni11G2K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210827; c=relaxed/simple;
	bh=tNXMof+0LAt0VqJcOfYCCObaKwBpLROocr3ALU7vHMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlgH68YxEjYdzNwRJ/mOXd4EedgMwfU4wMyzztloSz/efktp53pbaEPOnuhtf4bYzLaSYZ/KMKQSqUMvLIRqCS3s6ELwuT3oPCCuRkFXeXgIhHtv6oSYYtD337KuhPksQc7Q2n1gei9yagY2BmIPvCnONBykXdUfBgsMUpvDRn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I7Xwy7oA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I7Xwy7oA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A9A1F000E9;
	Thu, 16 Jul 2026 14:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210825;
	bh=W2ux/E2JBqKTPL98NFiVoXz2Wi7BCd7igK6X8Hr9Ni8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I7Xwy7oAO7rBZRwRBqUiWe7rkDKPNY+HdnA0k4K+XxwXs60C1kx8o0HBjLbROgqDE
	 OYoSpWLsWjx3+Cg/aknFmXTenET6GcqRNPsRbjXgvd+nDDKmmhq2ZxRnRmkTly8fYx
	 xLSOOJIvUIIE5JTlXHc6QpyG66fkAe9w4WkFD+Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.18 196/480] netfilter: ebtables: zero chainstack array
Date: Thu, 16 Jul 2026 15:29:03 +0200
Message-ID: <20260716133048.968881059@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

commit cbfe53599eebffd188938ab6774cc41794f6f9d5 upstream.

sashiko reports:
 looking at ebtables table
 translation, could a sparse cpu_possible_mask lead to an uninitialized pointer
 free?

 If cpu_possible_mask is sparse (for example, CPU 0 and CPU 2 are possible,
 but CPU 1 is not), the allocation loop skips CPU 1. If vmalloc_node() fails at
 CPU 2, the cleanup loop will blindly decrement and call vfree() on
 newinfo->chainstack[1].

Not a real-world bug, such allocation isn't expected to fail
in the first place.

Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/netfilter/ebtables.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -921,8 +921,7 @@ static int translate_table(struct net *n
 		 * if an error occurs
 		 */
 		newinfo->chainstack =
-			vmalloc_array(nr_cpu_ids,
-				      sizeof(*(newinfo->chainstack)));
+			vcalloc(nr_cpu_ids, sizeof(*(newinfo->chainstack)));
 		if (!newinfo->chainstack)
 			return -ENOMEM;
 		for_each_possible_cpu(i) {


