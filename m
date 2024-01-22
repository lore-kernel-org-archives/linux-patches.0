Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA22140796;
	Tue, 23 Jan 2024 01:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972038; cv=none; b=s1sBjSv77iRPf3e+JVp9ybWU0o+DrPPALpjTubFdRXOKg3aph614wPzFbgl6OlBshL+ZtcWzWO6+QQk9tqjQ30Lmf+JC+bBcnHQDDWGICYFoEIqBWUi6PkvJh7fDrW5ceVCS0MdSnFBOonG3ljdLHoBLoXmqyYE+0tq8T5Idoh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972038; c=relaxed/simple;
	bh=oSzuZ0vcEhBeSiN8Xr7CIjIqij8At7XXE2VtK/iHjg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KR1gBvyBm0WgKYfujHyi9jSDfyPRKEf7fkD7WVra61KkqWcEj7HmQOV+7Bw2XDcKuj96PHifsyQfMsm4iEJsjsvSYJA+ByvJ27neebpRj0+oSZf9byjOD4BRv8KcjJ3gdJ0dm6AI6XqadQKhAbYS2dmIjjUbucDSWnwTc0iiTr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VcGSmB9z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VcGSmB9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B192CC433C7;
	Tue, 23 Jan 2024 01:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972037;
	bh=oSzuZ0vcEhBeSiN8Xr7CIjIqij8At7XXE2VtK/iHjg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VcGSmB9zHd8v3rSNJ/YGYT6XyAXWdgy2qhVqlHJEFhnDkRsElobyuVPWlNrItg5t6
	 AcidRcuXVq5CGxcNyO3kj0S9BIwLQVVt9273n3n2tCPRLR4D0ci4FkAmU8SR1BUgIa
	 zoUqqI4a9HubKMzXWWSRW2ImnIM3EzI+8DtFNjrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 406/417] netfilter: nf_tables: reject NFT_SET_CONCAT with not field length description
Date: Mon, 22 Jan 2024 15:59:34 -0800
Message-ID: <20240122235805.776994559@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 113661e07460a6604aacc8ae1b23695a89e7d4b3 ]

It is still possible to set on the NFT_SET_CONCAT flag by specifying a
set size and no field description, report EINVAL in such case.

Fixes: 1b6345d4160e ("netfilter: nf_tables: check NFT_SET_CONCAT flag if field_count is specified")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a4e5d877956f..2702294ac46c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4773,8 +4773,12 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		if (err < 0)
 			return err;
 
-		if (desc.field_count > 1 && !(flags & NFT_SET_CONCAT))
+		if (desc.field_count > 1) {
+			if (!(flags & NFT_SET_CONCAT))
+				return -EINVAL;
+		} else if (flags & NFT_SET_CONCAT) {
 			return -EINVAL;
+		}
 	} else if (flags & NFT_SET_CONCAT) {
 		return -EINVAL;
 	}
-- 
2.43.0



