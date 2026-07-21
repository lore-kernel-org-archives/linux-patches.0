Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4460471265;
	Tue, 21 Jul 2026 20:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664354; cv=none; b=sspevCed3CJTGw10GVvU4PdHIckjvefeiu9oRBUVp9ykVATiuwJR2CLRgYnnwC4MTjflke3n4fBh8D9YGUrG10oOMphx8OeY+vUEKLMZi7DQwXs1F1wo892W55/mQgFUgcrQ00DIhsXiyPtLdFT2eB7hho9VoRaXUY7R+Hqwfe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664354; c=relaxed/simple;
	bh=GDUjRzfjfk5hji2uTdKx8mDvr5O8yHAChHmD1kxxJoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNdxxnomvpo11zBrgtDXzo6zjI62cMoCeRnJ1B/mIzJfoROZWMYmq0DELwzcJu0riM7VQ0X4BbBqiq0UourDt1/MhG+Sl9CaKi/MoVk08LFRZHaf0miodg3QDic/41BiIQV84DlmfwSU9giJJxEMKwtS7ZoCqV//iEzO/LamtJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nn4rQPHZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nn4rQPHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151741F000E9;
	Tue, 21 Jul 2026 20:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664352;
	bh=Qu7rqv1m8yAPUD9+f+KQZFR23AtnbiUnnnplet33p2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nn4rQPHZAfKHgoT6sTtito83mR9ScIK15RJf2LxK5LFc4aIOHvTWCDTV8S+Dp7Ie+
	 pKNAHx59ij1NMrocegCfrVde4a+nqrC9r6ozoR5vZywxZFVoxSaNP2BjdWw4iaPOrO
	 p7IY7C+5raUP6065KX3QJH+Gc4xHHtC8Fl16spRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1169/1276] netfilter: ebtables: zero chainstack array
Date: Tue, 21 Jul 2026 17:26:52 +0200
Message-ID: <20260721152512.183153539@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


