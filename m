Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C7344AB62;
	Tue, 21 Jul 2026 21:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670686; cv=none; b=tDBQjkbGGPvQiP1DjiAQ6DnDEUrMXKsdo72UzqP8B/sAnhrvgFFWivgm4GOQfTom+9lDq2w0PtlFqvX2TWW6L8nreAwRhFAs5FXP8oVYlkM0WBqXZOtP0OS9HOjeDHTaLiKvgxbT5NpN0du547U2p3y0fPYNQQhV3ctL7cIhgnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670686; c=relaxed/simple;
	bh=9bYdV4muKUFfMdgV1Z+fv5FdxVB4y5N39qEBk93wJ6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ie8fktfg4YHU5u5Hrr5kkYCLqHqYClhWXUVoaZFwFIC24LkMHIHUcFtGqa510GaaRxvj76ckBrM7LDygSfTRlaIS5+dA30CfK5AF26tAjvRs28ohHhMfXmAOkonz6ffTf3IFSCAqleykQNwsXG5D8AsiXlYUQoynam/L7Nq3nGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jhtUIqEY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jhtUIqEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0981F00A3A;
	Tue, 21 Jul 2026 21:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670685;
	bh=DnPk2Tjjsp2+Lf0SRK6il/mT8I0cIBAK1g1i2cVfgEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jhtUIqEY1GlNOIthd5pVacjWb94zImXC8xhrUJrsgnE/ftwa1l6qV8amycTQ79Xxf
	 mDqMWae4pCuLmqg7dbg3tlIYdIzstyN8kUwd2SixenfJxiLkciDhsz6oUDsTNDdVYy
	 lsXIbkOZqPRhrevHoOotfLWFtqQ/QSAI2Tnnc7MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0983/1067] netfilter: ebtables: zero chainstack array
Date: Tue, 21 Jul 2026 17:26:24 +0200
Message-ID: <20260721152446.544536878@linuxfoundation.org>
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


