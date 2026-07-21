Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA122473C70;
	Tue, 21 Jul 2026 21:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667792; cv=none; b=aS65A688ZFV6p1W5exJvgc6FXNkq1ts54HScS17NaU33YgPPoxHJ+zXG2kLQj3l2ZwXdWXDxBrpiyE452FB20V/7sQjL7cP3wcxUzE+JuFGL7apbjG4tOzzjbX/P0QVqkAeqqSO1RWTExr0pFX8TW90Taqs6enKNATvPrKA3vEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667792; c=relaxed/simple;
	bh=8ZWozXvm8XaFwE1Lpt61pMUjJqvLE5oNGcqw2glmKPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DI2AnEK+9V4pgZFA4ejZldp/FScaoLL0uZwHa6RD90boJip0PkCe1evoqp/6SwTJ9v4l1j2R7YFW0Z4kRBH01UFjP+YWHdAYa/GjvgVQi2ceU9/WGqMUK3A/JsUb9/tpHtKyPFpzWoJhRuPkXAAWiCc6W7iijNrFwRhiO9DWh5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocTQLj5j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocTQLj5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C7C1F00A3E;
	Tue, 21 Jul 2026 21:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667787;
	bh=LC2JFyknYQ0X6auamGKwZc9hnMoqOZXD5ad+aAo2t1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ocTQLj5joBKi/Kl1dxL8Civr/Y6b++uPfZQFRvsYIAXjIKRnh8frhZeXpoPsxjK1v
	 oUaMocWr/TTwhtqYQhMsD2eDXhqYrYj4yLFLabQDNC9OJnVhtz6ZuZVyPBg9T1tWYu
	 4D5i1yVHLtTngMAxOD9mB6NyHCV8NfMEJu3fi8Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1191/1266] netfilter: ebtables: zero chainstack array
Date: Tue, 21 Jul 2026 17:27:08 +0200
Message-ID: <20260721152508.447423890@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit cbfe53599eebffd188938ab6774cc41794f6f9d5 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/netfilter/ebtables.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -923,8 +923,7 @@ static int translate_table(struct net *n
 		 * if an error occurs
 		 */
 		newinfo->chainstack =
-			vmalloc_array(nr_cpu_ids,
-				      sizeof(*(newinfo->chainstack)));
+			vcalloc(nr_cpu_ids, sizeof(*(newinfo->chainstack)));
 		if (!newinfo->chainstack)
 			return -ENOMEM;
 		for_each_possible_cpu(i) {


