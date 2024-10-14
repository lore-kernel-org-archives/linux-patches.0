Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94F51C3046;
	Mon, 14 Oct 2024 14:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917415; cv=none; b=hdl91BK/1lpRX88F2qe7z4MlwHX2NQDlGajX9DwZ1B1/3RRPi3/GyWlPYMR2MVyRt6xAGsk7U95R4MWC8SApShkHqJTy9s9IfFHhYtV173dnWd5qVLry29kMqr7NfKyPqoEMsmcLvZgZVwj/WpROp3VsIfHrisntTdKMEwLrhF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917415; c=relaxed/simple;
	bh=DG4/6F78HE6E94w92grSHp5bhlgNUSIdsqNIghGYGdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJ0ShosJVhPXdpH21W2nbFplTTj/9KrgUx/eaUAyCt5XfMmCexPPqn8JdSFtVmhGXD8dosod3PSI0sFGVLI3jq7YVHFz91SOEwBES61HfBh72P+pYw+qigVKduJV7nzPKKeUtJU8ozOTA3Z+lkE00FGjDn6424DEcWRAe8htjQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tpu5EtJh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tpu5EtJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA44C4CEC3;
	Mon, 14 Oct 2024 14:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917415;
	bh=DG4/6F78HE6E94w92grSHp5bhlgNUSIdsqNIghGYGdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tpu5EtJhduHHtcoH+/+0pCCcBQf4Xd2Fc94q7WgakoR8kWEZICI1BOEbBVSkU6Pgb
	 EGW2FuSxLiYvGW0WB7G19Lnn4Rmf3mTLOz6+e8FeTRlQg4pt1A92TqEkR4RhqJAcBa
	 rUY6OGNLUAQdZhImuXQlgYYAhRNKRLs32aaME5Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/798] netfilter: nf_tables: reject expiration higher than timeout
Date: Mon, 14 Oct 2024 16:09:43 +0200
Message-ID: <20241014141219.092412229@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index 77306f48b3994..f57418150717c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6418,6 +6418,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
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



