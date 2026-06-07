Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017411DE8AE;
	Sun,  7 Jun 2026 10:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826931; cv=none; b=RNiBbNSoB7KQsZqyM1vuyhB9jORfimHLZoIDa4SJWdKPwItKwYfYFF70Gb8cAuAZaI0HPRjcX+gF5DFg+zf3QZrLYkjaZNoBONBEJ/sESrOxMXMkOjMZ16BJH8WVnnB/2F1xfBEQXCfleG4f+IBnVJHI44Q2ZwJbofhGFidEF6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826931; c=relaxed/simple;
	bh=FRI21GsZ1FGmN7iB7ibMh+FO4uxCp0W4Ny5D7CWrTsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ut1Ef14x6cg3h+e41wuewUpbt94EsTHei3m4v7/dieEBYTgbPoCh0MC+qNbbIOuIrgk9Eobee7oAB3x0GTJMHH/NtgoQ15Maseb8cHmDAFCOhdqA5ZJ0w8wyLrdGiKGAbzs68yP2D1pXpgBqKdHcGvtsl4tfoy4Dj0f2CLD8yxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UcII+f5g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UcII+f5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5B71F00893;
	Sun,  7 Jun 2026 10:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826930;
	bh=NyXMC5sQIVr4OR0wNV2iM00T+VwJo2g3c90tUFhPmHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UcII+f5g4v77ajwCJQo2I8leJ/Kt9YD/BJgCsKL89CmpIA2ABAr3jIxwbV841C8rV
	 hV2ivN2XDaSjcB+UVYvUrXN/fQQJSMjUpbi/vTu8XZXaixNrKPdzT9V+5BzJo9Z4hc
	 MPdrsmhBDIjkgYL3WaEDzfRm+pPuCUafrg2HUqGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 044/332] ethtool: rss: fix indir_table and hkey leak on get_rxfh failure
Date: Sun,  7 Jun 2026 11:56:53 +0200
Message-ID: <20260607095729.733366849@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



