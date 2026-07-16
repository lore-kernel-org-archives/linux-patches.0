Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E13A28725B;
	Thu, 16 Jul 2026 13:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209477; cv=none; b=RX+GlSFhaZQnd3QXAjb3ka0DnySb873eXPtk4QlkO5rmbrhPD9ZcboR6oFVlX5CvWtgjNiT4SmJqL52TlFfOAgvHFFUi7veYdNWWcGXdvH3ZjAtVJbL3wA/p5WurXh/dgx0hNn9/fbvWAK6S0jxmMaWK42uXjc+ErX+hFkoo2WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209477; c=relaxed/simple;
	bh=VT3PPPpFXE1udk05OYiKo1XYsqBjDNSCDhBwiCHJWJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfoSq27UGJfVF/ijo1FraiL/+glD60R0W3wZizLdXPojVjm+PDD150O+WDb5kDxGJRlCkJku33LynLys2Xyf5DpgyzjYxonq15lZ0galIDdB5qLgZFlXqwTwlyirhBbJZFtWvC2eJhPY3GGX3iLumKkJLARyBCjhTwBM14cil4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eKJcaOYE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eKJcaOYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2AC81F000E9;
	Thu, 16 Jul 2026 13:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209476;
	bh=wUzFHC1vDDZjcmCv7BzcwXc+Yt1Ba7ys3YKOnas0gew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eKJcaOYEdz2VsQpO6AAVRjyIVhvfNFcmh6vL21NUgjoNPScc8bKBd0ZdDJGVVbCmE
	 +emdQoCVe2+AwZ5vOQhMRNJTwBVg5blX3QUPHPNZ+XRv6FOVu6t8DyxFF5NF/vkv07
	 gIu4O4k8mAtGMMo5lgVPT2hoYlN+dYpla7UV2CK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 7.1 199/518] netfilter: ebtables: zero chainstack array
Date: Thu, 16 Jul 2026 15:27:47 +0200
Message-ID: <20260716133052.178718593@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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


