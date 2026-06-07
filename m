Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9372E2DDD;
	Sun,  7 Jun 2026 10:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827118; cv=none; b=U+90pyQXZTmwfhRQd7n6TnpXz7Nm3xustRa+wk9sj71k0pgT9RAXvaaPHdB178yTxGr1oFnKCcfIHtG2xWQ0B/DwpkJMw49eDGbF0/nUiwVM7c/273uGUNolPpgnX4I3gOd0AUl++c0tXP3nU/63ahXTFjZJJbAbIZbd/A3PcAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827118; c=relaxed/simple;
	bh=LWRdmDogP7gRaAYhsjomeeznepuxl95H9EgzkV6cQVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLfY2Ko9hPoaNNVC5u7xf+PCgYOzgJPdBilKCqTExuMXdKqpqV6Wi+EZo1ogbeaRhzJ5OpEx2aKmSC8Rv1qbF0lUFKbD5jG6jQSa5WO58JPP4A8vd9XMuEMGxYnzKc5zUD3e9NsIBnz+506tCrMCIXKiYmUcB/Etq7ULufwE9v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZ88i/U6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZ88i/U6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9481F00893;
	Sun,  7 Jun 2026 10:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827116;
	bh=TaEF/ojAn5k5XLuWzEeulNxG4DufuQzN1cHTwDlUobM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lZ88i/U6yrGev7S4Zz0WVLtt5RYfVSj9wHeDbN5KeLmN1F1BvFwgsCM096A467Usg
	 bgMmZT3ekqPfVe1VCTySUI5VivFXy6yWUVLxKuUp2LKlMvy83ypAPkMYZ/IwD2GW3c
	 3UY2o8hnvsVFhSW0pWTMY27GpPsMo1u/AHXPCHZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 041/315] ethtool: rss: fix indir_table and hkey leak on get_rxfh failure
Date: Sun,  7 Jun 2026 11:57:08 +0200
Message-ID: <20260607095729.069563070@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4877655f724419..5416aec13b7fe7 100644
--- a/net/ethtool/rss.c
+++ b/net/ethtool/rss.c
@@ -168,8 +168,10 @@ rss_prepare_get(const struct rss_req_info *request, struct net_device *dev,
 	rxfh.key = data->hkey;
 
 	ret = ops->get_rxfh(dev, &rxfh);
-	if (ret)
+	if (ret) {
+		rss_get_data_free(data);
 		goto out_unlock;
+	}
 
 	data->hfunc = rxfh.hfunc;
 	data->input_xfrm = rxfh.input_xfrm;
-- 
2.53.0



