Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB45C1DF969;
	Wed,  6 Nov 2024 12:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895915; cv=none; b=CQZfOsgCKbYsCygpiLE/uh9GL8EgRwrld4AYAip3pR7VATRjujup7cWFfYjtyIJesnthrqN9BIfJenUmg57PHFA/Lbh0tWWNR7OGB8PJGr55TDN9pBsiKV32AZPtU1kPAeSNnRgg+OztlLnpv5Vc0gn7CKg1fVlCmn9OBhiqKBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895915; c=relaxed/simple;
	bh=0fY5XrAsB5Luvq/Oqqdb49ECDL5S8EpXiileedMTPsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOL6bmpoAVBoa8lNl16Kne5U5utuH5pcL+MGCiA0R7Ps6d9DuiAMmRnbovQOMG0HSIPIl9qu+FaDkkObu/K1vK0+wxnASYpAj+g4C7t3P9eQIH9UOckunVqA8uty1adFoGBSyKlhz4Wbsf7n/+wbamGiQkAdjOI3DwdTJ0Rebl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TiguOjOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TiguOjOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE4CC4CECD;
	Wed,  6 Nov 2024 12:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895915;
	bh=0fY5XrAsB5Luvq/Oqqdb49ECDL5S8EpXiileedMTPsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TiguOjOCgrBOnG1Wb+4BJCc1+TTdaq00NKwR11EUljv2hxY+dO5kfa5EZumy7VDQI
	 LSr4t5wOtiLRfV90TkCCUVlmF5/rHjUSsHzLNrL3YxTysLrA1TBsFAx1zn3pksAlkn
	 ifI+63T8nexw2+trYpTqHtHZJ3Pwn+S9KH8RBUjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruan Bonan <bonan.ruan@u.nus.edu>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Cong Wang <cong.wang@bytedance.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 027/245] sock_map: fix a NULL pointer dereference in sock_map_link_update_prog()
Date: Wed,  6 Nov 2024 13:01:20 +0100
Message-ID: <20241106120319.900178301@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit 740be3b9a6d73336f8c7d540842d0831dc7a808b ]

The following race condition could trigger a NULL pointer dereference:

sock_map_link_detach():		sock_map_link_update_prog():
   mutex_lock(&sockmap_mutex);
   ...
   sockmap_link->map = NULL;
   mutex_unlock(&sockmap_mutex);
   				   mutex_lock(&sockmap_mutex);
				   ...
				   sock_map_prog_link_lookup(sockmap_link->map);
				   mutex_unlock(&sockmap_mutex);
   <continue>

Fix it by adding a NULL pointer check. In this specific case, it makes
no sense to update a link which is being released.

Reported-by: Ruan Bonan <bonan.ruan@u.nus.edu>
Fixes: 699c23f02c65 ("bpf: Add bpf_link support for sk_msg and sk_skb progs")
Cc: Yonghong Song <yonghong.song@linux.dev>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Link: https://lore.kernel.org/r/20241026185522.338562-1-xiyou.wangcong@gmail.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 219fd8f1ca2a4..0550837775d5e 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1771,6 +1771,10 @@ static int sock_map_link_update_prog(struct bpf_link *link,
 		ret = -EINVAL;
 		goto out;
 	}
+	if (!sockmap_link->map) {
+		ret = -ENOLINK;
+		goto out;
+	}
 
 	ret = sock_map_prog_link_lookup(sockmap_link->map, &pprog, &plink,
 					sockmap_link->attach_type);
-- 
2.43.0



