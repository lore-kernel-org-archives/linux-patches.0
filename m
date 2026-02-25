Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5B318B0A;
	Wed, 25 Feb 2026 01:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983370; cv=none; b=oPIzz1ZhII6zbySc0T5e7lxi1UQyZkdGHETlXQkTTX/LVf4tv4yXFzN634EuCV/Fyqv6uZeeDmAJaD3uqTLO0S+jA91G5T86Sn1f9XSjNAxUyz0TOvPgvmUQIdkZaxClEmFbBvFML2ScHEADiWDt2bshj1dqpWTI/FGH7XdVLwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983370; c=relaxed/simple;
	bh=/irB2zTh8Fyoh4pKux0EzKBISt1T7HbH9Mk7zmJ+qg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NadA+v92oHjlfhTDQ9YnKZqFl/MWYcQUsFeoA/daQxPrv/SthvMg1XR9O+XRkENI0roh5yl+cUQXUbAwHCq8G2/rQDWqqeO5OyDV1NQlJUREVNYp6zWrPsKn8t/nBtSKs/GnwgB+dqrgn1Gv+khNNhDtBYBTNnhsAQTk5eIMj/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYemiOaF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYemiOaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C966C116D0;
	Wed, 25 Feb 2026 01:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983370;
	bh=/irB2zTh8Fyoh4pKux0EzKBISt1T7HbH9Mk7zmJ+qg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYemiOaF0mgnjEs/IdNphy89cxZ57EQ6Ofl/8VlRUjb8GK/aHcDfdIXm36dG0slLU
	 oP/CxAavOvL8UyeeSOtZXpmBDUZooudHGlqC1gFafPBMN6QOjGgUQu+FgShI+i/U+G
	 T2NyQUaX5Dd8j7cEz9p3X54Y0AW+Lr+Xz2k0/+Pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Liu <liuy22@mails.tsinghua.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 496/781] RDMA/uverbs: Add __GFP_NOWARN to ib_uverbs_unmarshall_recv() kmalloc
Date: Tue, 24 Feb 2026 17:20:05 -0800
Message-ID: <20260225012411.972164830@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Liu <liuy22@mails.tsinghua.edu.cn>

[ Upstream commit 58b604dfc7bb753f91bc0ccd3fa705e14e6edfb4 ]

Since wqe_size in ib_uverbs_unmarshall_recv() is user-provided and already
validated, but can still be large, add __GFP_NOWARN to suppress memory
allocation warnings for large sizes, consistent with the similar fix in
ib_uverbs_post_send().

Fixes: 67cdb40ca444 ("[IB] uverbs: Implement more commands")
Signed-off-by: Yi Liu <liuy22@mails.tsinghua.edu.cn>
Link: https://patch.msgid.link/20260129094900.3517706-1-liuy22@mails.tsinghua.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 3259e9848cc79..f4616deeca545 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2242,7 +2242,7 @@ ib_uverbs_unmarshall_recv(struct uverbs_req_iter *iter, u32 wr_count,
 	if (ret)
 		return ERR_PTR(ret);
 
-	user_wr = kmalloc(wqe_size, GFP_KERNEL);
+	user_wr = kmalloc(wqe_size, GFP_KERNEL | __GFP_NOWARN);
 	if (!user_wr)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.51.0



