Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BCE56470;
	Tue, 23 Jan 2024 00:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970297; cv=none; b=m56PboAUTTAuUXJbFu3nWjEWpy0zGbAf2X4lzDO33ancaW0lyXS0jHIH4dGKkQAls8HBDK4O+v2R+yAxv4GlO6GpfxlK/u646l9MDLtZFF1YeC8fkZ7/HBwr/EIhLbx2PhovsGvt6KVDuc28F+8lS/1tIbqvv7jfouLgdcXWOms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970297; c=relaxed/simple;
	bh=tK/WrD0i6Ta9kiVUPq3/3b5bZ0ZtmVBjSODvdM7VFM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=da0MTYbZ2qbVT36HuSQ9LpXa2IKoS6Yw25ew8pvhjxpKb2RYpw94IUbmaf+0VDPoVJNz6Kgdu+30OXofky3HJnEJA0rrY41K2R9M4q74eBkcX/aEcw1/fLh74Kmdvj59w8jmZKx3LmCj4sliby9WG9vx6lqwzskhBn020fO4mks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VvheVa4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VvheVa4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71810C43390;
	Tue, 23 Jan 2024 00:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970296;
	bh=tK/WrD0i6Ta9kiVUPq3/3b5bZ0ZtmVBjSODvdM7VFM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VvheVa4Uh5C9PPspNkD5SI4hEyNzPmNlrv98GAbhI8S+h2M6GEaXz6TOFrhguKC2V
	 bQiOoIfoO0NLpT7RwzoZRY45rZrlnwnPG/+Pd5akbbf0j+p46vNYS/uFmLSMtTFHB2
	 SuOl2oLQoG2uNosF60gRmVP3FFSzgcV4L294ET74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 627/641] netfilter: nf_tables: reject NFT_SET_CONCAT with not field length description
Date: Mon, 22 Jan 2024 15:58:51 -0800
Message-ID: <20240122235837.879259350@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 47ffb9e4c353..f032c29f1da6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5068,8 +5068,12 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
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



