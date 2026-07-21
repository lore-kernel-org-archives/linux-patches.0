Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F5135C6A0;
	Tue, 21 Jul 2026 21:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669942; cv=none; b=osDgSJfjYuG3yfJfi9aRvOGVvlSe+0BIAj0ZRDY6LPka0xZTWTVPeyN8wM2VSXUmbWo8CQZhBrgAvo1hmmKQfKjFEQkDCLctzBwjyBz0DQ/yk35giiXhDPmjtBwGmg15lowkIvwOySO6FXeiOr5GD5BTqvfDog3n26nv+Nbf6Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669942; c=relaxed/simple;
	bh=ByooqWjqrv3Vv4tPRmHlUfAsVp63iknZy35FRjFoYqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqfEjHU1ZlJTk8yvxdU+3PlNsCkhvFIMOf+JQ+2c+eBfAdGU0jNKXTKccRipMzMjQajP95GAItEB56j5b8M82S9E+Az0aWlQGj3wS/INQ1hJxD4Wo8cNJewRvj+i78EIwjrDVVRy1BF9NCVrGNnG9ZkLGRw/Sped1Frk0wtxYZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y49YcPSn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y49YcPSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453861F00A3A;
	Tue, 21 Jul 2026 21:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669941;
	bh=jLF3HVbDYOD5AoZ4cM9XotL8j4aeejqNZHlozti0MbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y49YcPSnP12mbcu12rufjsEFfiAVdjYCgdKDfKz7XcutDTwHw7Trsoc5XSqcadt8B
	 NOh9CLYMD0IDoyCLlFF20H8T9kIukCi2XnKDX2TuzfAHJJWRwwTSCl5pczIwGGa1ox
	 xWUZXsODw9pkhxaCtn5AW3iapNHAaWtsaSMs5hZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.1 0743/1067] netfilter: nfnl_cthelper: apply per-class values when updating policies
Date: Tue, 21 Jul 2026 17:22:24 +0200
Message-ID: <20260721152441.201523064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -348,8 +348,8 @@ static int nfnl_cthelper_update_policy_a
 	for (i = 0; i < helper->expect_class_max + 1; i++) {
 		policy = (struct nf_conntrack_expect_policy *)
 				&helper->expect_policy[i];
-		policy->max_expected = new_policy->max_expected;
-		policy->timeout	= new_policy->timeout;
+		policy->max_expected = new_policy[i].max_expected;
+		policy->timeout	= new_policy[i].timeout;
 	}
 
 err:


