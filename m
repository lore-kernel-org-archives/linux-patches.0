Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0832C1D040E;
	Wed,  2 Oct 2024 13:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875327; cv=none; b=LaSc3ZCxDnn77qmIyf+ruXrilv2OgVxX5R+IQfIP2TUR06M9UiOkEZCu4AswjLXKWYfeJ2n8SRFuno3NzdE+P13+mLk8ujiaFEFZ/NIZVSxbfLXLpyzWMUc8yaA2LhaWZJ7M1s6RG3fRyBSuDwzb0fDq/m5tpOTJ669KDLAPrxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875327; c=relaxed/simple;
	bh=TWP5ca3wTH33J2K1fqt2W4RWauviPgns3AWgVblxUGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFprmpzi0HyJDr6I4GCeZIBUNda27mZSjhxDnCIxq8IVHWMFWM/b6dUsmgpggww0vzdjhA5WWl2K1lQ1PE2lor8LBkrlU1jb5U6sS++C21TrO9yieXXtl0kTvOnVSz0lksEaHkUrpj1AJ+YJVw18c7ID6x2JRHYAdJIl/VoGXxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wyde3Zv0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wyde3Zv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4BFC4CED2;
	Wed,  2 Oct 2024 13:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875326;
	bh=TWP5ca3wTH33J2K1fqt2W4RWauviPgns3AWgVblxUGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wyde3Zv0BgjbAfhccqy/4Zj4LNmQFd0LiLnUuEPx9GTeF/eOzPAqU5vo1jS1Dnyyk
	 o/y/y3ebh9wxg2W4HKNTxP+9rBDdEkt+tDB51dGq2MkyD1iZ7Dh7o21T0fhNCgxhb2
	 Xgnkixg7ou75d9UMDYDA42Xj2Ej9gJg4+HUSs6eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 065/695] netfilter: nf_tables: reject expiration higher than timeout
Date: Wed,  2 Oct 2024 14:51:03 +0200
Message-ID: <20241002125825.079925259@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit c0f38a8c60174368aed1d0f9965d733195f15033 ]

Report ERANGE to userspace if user specifies an expiration larger than
the timeout.

Fixes: 8e1102d5a159 ("netfilter: nf_tables: support timeouts larger than 23 days")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 70992c6baf52e..b13a899698a8a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6929,6 +6929,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 					    &expiration);
 		if (err)
 			return err;
+
+		if (expiration > timeout)
+			return -ERANGE;
 	}
 
 	if (nla[NFTA_SET_ELEM_EXPR]) {
-- 
2.43.0



