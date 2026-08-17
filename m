Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2CF40F734;
	Mon, 17 Aug 2026 14:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977261; cv=none; b=VUnCZLXtnX9+POIL7Yg+za8Q/BTT1KwlqRuv2b5hmMgrHVSSF62N5QkZvRMO++vHyy0tqILMhuUztV1H57QDML425Ij/3YaKmWMDdiI/CBgR6SJIYhlCU8/IJI6HNLGXP2eEgffxws0cvnJZyiRsFz4LL8JIXMCIm0+F9kABQRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977261; c=relaxed/simple;
	bh=QjeoQYkaB/WnC95SX2AGttQQrkmpXj4CqvdFqzU6vCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGwrjoB2FPe7hs3X45xJg3kUk+EXA6cfvRe+SBJS04tMrAj8eOlQgO8MwnSSH49qYIs5ZipGCZjJUHaZgyKcKV6epsOxAB3TEgbuM4qDaO1wnvfG1e8DkLSUEkjnwKJQuNGCPYeEb6pd4Fk/ASwXYNRvmWmYiw6s+BksFLYarXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oV4XNkHM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oV4XNkHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E831F000E9;
	Mon, 17 Aug 2026 14:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977260;
	bh=BquRDAXHRgSlCliLSAwY3NQir3BsDDjHAUckBnuJHFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oV4XNkHMmHk84G+ZugcLS2AzWNMbdqkx9oObuj5sp1Xkhbzdhu3ioZrwsJ666jjlI
	 YSrM4iwfPUK95dR9w5iJC9B0MCPTKDyM+63PmfMm7YGOdF2KlH7RtZsbQUp/fOWg9J
	 wGaBlRw4Q/yFwqBa6OKJYXEhkUkCz5jKqUN/Dx70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Corvaglia <david@corvaglia.dev>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 266/456] net: bridge: mrp: fix Option TLV length in MRP_Test frames
Date: Mon, 17 Aug 2026 15:30:56 +0200
Message-ID: <20260817132550.403392889@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Corvaglia <david@corvaglia.dev>

[ Upstream commit 5546da86894d5906f131b05890705a7abf949d84 ]

oui is a pointer, so sizeof(oui) is the pointer size. The MRA
Option TLV thus advertises a wrong length (15 vs 10 on x86_64),
causing misparsing of the frame on peers. Fix is to replace
with sizeof(*oui).

Fixes: f7458934b079 ("net: bridge: mrp: Update the Test frames for MRA")
Signed-off-by: David Corvaglia <david@corvaglia.dev>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260726062605.2746-1-david@corvaglia.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_mrp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index fd2de35ffb3cf..5fd22bb4f5b60 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -215,7 +215,7 @@ static struct sk_buff *br_mrp_alloc_test_skb(struct br_mrp *mrp,
 		struct br_mrp_oui_hdr *oui = NULL;
 		u8 length;
 
-		length = sizeof(*sub_opt) + sizeof(*sub_tlv) + sizeof(oui) +
+		length = sizeof(*sub_opt) + sizeof(*sub_tlv) + sizeof(*oui) +
 			MRP_OPT_PADDING;
 		br_mrp_skb_tlv(skb, BR_MRP_TLV_HEADER_OPTION, length);
 
-- 
2.53.0



