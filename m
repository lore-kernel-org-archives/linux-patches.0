Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25A722FE19;
	Mon,  2 Jun 2025 14:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873882; cv=none; b=uzr+cjoSzN1ohdj4v9sd+wBCKi/VBFwMVQR83p5TDE8WJR8IX4PvHvKOShV9/eGSyDYt3cz5Jnv9iXidmZ6FZKTc8NLJZb7L4hBpnzf6wWzTrkm+Z82sQWWoIVC3flX2yw2Eof/Uw5vOGwzy0M0ED7jzqvumKxwb3s3XpTU74Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873882; c=relaxed/simple;
	bh=6jkq7liZ2MqXC7Is9MpDCu9+qn+DIEtnItXElnWSjow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6i2duck8SIv2x55hc98dgR79IO59CKo4kbAcg3iGxXN1AcV6vmi3JOO0ZjeFZmYutZKcWsCbMYOngt9+YWp+hfyCBVxzVS3Ds8LVlAyriwdvuh2RAv5y6eCj2V5FqcRfNBhqwxw/ZZ74zqum9LE/RVD0krzGkoUxQEwLOmd+Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7lPMpuI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7lPMpuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70052C4CEEB;
	Mon,  2 Jun 2025 14:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873881;
	bh=6jkq7liZ2MqXC7Is9MpDCu9+qn+DIEtnItXElnWSjow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7lPMpuIorRy3K2nOZzJRWTYadh5iEk2dKo4TPTp0j2mUJHJRp6lJvw9n/OsHoR/+
	 hMd6vcB/vmgnIysVzaWN0YFxTj3hnf8Sqmc15OcTkroPFt/QZCZVNSGS8ZVJ9adFNo
	 AUdvf/xnpNzvNEBiatECLMN8+BBQLbvAjZwGOeog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Shiraz Saleem <shirazsaleem@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 285/444] net/mana: fix warning in the writer of client oob
Date: Mon,  2 Jun 2025 15:45:49 +0200
Message-ID: <20250602134352.526520163@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Taranov <kotaranov@microsoft.com>

[ Upstream commit 5ec7e1c86c441c46a374577bccd9488abea30037 ]

Do not warn on missing pad_data when oob is in sgl.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Link: https://patch.msgid.link/1737394039-28772-9-git-send-email-kotaranov@linux.microsoft.com
Reviewed-by: Shiraz Saleem <shirazsaleem@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index ae014e21eb605..9ed965d61e355 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1036,7 +1036,7 @@ static u32 mana_gd_write_client_oob(const struct gdma_wqe_request *wqe_req,
 	header->inline_oob_size_div4 = client_oob_size / sizeof(u32);
 
 	if (oob_in_sgl) {
-		WARN_ON_ONCE(!pad_data || wqe_req->num_sge < 2);
+		WARN_ON_ONCE(wqe_req->num_sge < 2);
 
 		header->client_oob_in_sgl = 1;
 
-- 
2.39.5



