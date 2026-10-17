Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8402E2248B3;
	Sat, 17 Oct 2026 16:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254139; cv=none; b=qEwcbnGFmjnBJyRuFM9ZtZtV/M8tTzRX4CuvTtdmT4lyVg/Y36PoQ7IT4EGDaAHhIb1TbqGFkYafhRTs+JujzsTRutXUdpT2lz3OnCVee7BT9umHhkltjsSfPsaeVtGPxboUytJwri3/SNW1HKq1RGH1lNKs7Jn5wmcC7WJpxHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254139; c=relaxed/simple;
	bh=BiJF76Hd1qxxHTHEbZQEsDbtwc/LSFbNbKSONMZGmuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GosQhRdOvnNOAU2CO8OYvIEpCtqIthHInpx6K6Am7rTA/zMJ1Y7sgiVTItD5PwL7w+LnNZ3sFMG6VMVDhpLxQUREuVGao/hPGG/TyxtW2ZxSze46KqdC33YVBL96MdYmPhOSWc7BUlrd2jVEeS9vIjClCBDlehsq5eaHYBg+j3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2StbcFSg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2StbcFSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8372C1F000C4;
	Sat, 17 Oct 2026 16:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254138;
	bh=FHZJMLG083+6vNkPCbHxeYE1KFV7cwMUbw3aeUnm7B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2StbcFSgV+p+XL24mhxuvTf+Kn55W1pkNtb40SbeNrMcRFLZYeCHtjpqkzbunYklM
	 CiVq8h62TmHiIP/LOoX1GsqikCjQRi8Nycnvx7O+I/9l09jkzglqV3gl4i+PFjYx8L
	 B0ePOnp2e1yak8js0LcSde7Owxza6YUasmLrgKyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 349/869] ethtool: rss: fix indir_table and hkey leak on get_rxfh failure
Date: Sat, 17 Oct 2026 17:53:10 +0200
Message-ID: <20261017160046.047842592@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 266297692f97008ca48bc311775c087c59bd7fe3 ]

rss_prepare_get() allocates the indirection table and hash key buffer
via rss_get_data_alloc(), then calls ops->get_rxfh() to populate them.
If get_rxfh() fails, the function returns an error without freeing
the allocation.

Fixes: 4f038a6a02d2 ("net: ethtool: Don't call .cleanup_data when prepare_data fails")
Link: https://patch.msgid.link/20260522230647.1705600-5-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/rss.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/rss.c b/net/ethtool/rss.c
index 3570d58c5cca6..b543827ef373e 100644
--- a/net/ethtool/rss.c
+++ b/net/ethtool/rss.c
@@ -88,8 +88,10 @@ rss_prepare_get(const struct rss_req_info *request, struct net_device *dev,
 	rxfh.key = data->hkey;
 
 	ret = ops->get_rxfh(dev, &rxfh);
-	if (ret)
+	if (ret) {
+		kfree(rss_config);
 		goto out_ops;
+	}
 
 	data->hfunc = rxfh.hfunc;
 	data->input_xfrm = rxfh.input_xfrm;
-- 
2.53.0



