Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA87379960;
	Tue, 21 Jul 2026 23:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674810; cv=none; b=OjldAynNUaeYRDyNk55pyksta1tai5siEyDErQPAqsGSsS7Nq3keoO8OaYc26APw7oGDeSbROq8s5ifeCBkRaMg1/rgfiZ4h2UVHJbKr2ZqIWbSlyD1DeufosnfPMKTJtlbcE46uyo+jJWNnQHoGYVQ2RMQ7rpdgrNQZTqo1vEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674810; c=relaxed/simple;
	bh=87mbpO/NlA3jOXwv/7+VbZs0VUWE9fuZnVPBKEuafRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TibBY7oittyXk7lS3hZdjokKDEV2fAY0fE0UBrTByrpib9yzcLBP5sNGV7oEINxYauMmQl+CGEdoIdzVacXThvBUpraVrPyvj6FZYXqHfCaGsnhEWxiMNqddsjyB03h3263qFL+emWB+YGD//st4owBiW+U+OG8+u35+faYu39c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwwsVbYR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwwsVbYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CAC1F000E9;
	Tue, 21 Jul 2026 23:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674809;
	bh=2aW2XIeVrydtRy2FpHsYI3Uo1UbFfu+Dx9KrIzT/434=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CwwsVbYRWAmXjaS/S2pmtCVVz7ZipAlcr4P+k3DJMp1fwXqGFsdlyevm1rZVqr4Cs
	 KoLl4G8KxLOnslLE0zKmdTNYmhM/ss/6EheLiFjwvPo4VVONlXtAkQh7V4Udoamb2e
	 D3cK8GgzOLzCVroPzmsby4dqyw93jVPZec+Z4vjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 638/699] netfilter: ebtables: zero chainstack array
Date: Tue, 21 Jul 2026 17:26:37 +0200
Message-ID: <20260721152410.146230277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -884,8 +884,7 @@ static int translate_table(struct net *n
 		 * if an error occurs
 		 */
 		newinfo->chainstack =
-			vmalloc_array(nr_cpu_ids,
-				      sizeof(*(newinfo->chainstack)));
+			vcalloc(nr_cpu_ids, sizeof(*(newinfo->chainstack)));
 		if (!newinfo->chainstack)
 			return -ENOMEM;
 		for_each_possible_cpu(i) {


