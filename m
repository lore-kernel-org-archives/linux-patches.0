Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C8C1DE8AE;
	Sun,  7 Jun 2026 10:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826918; cv=none; b=RQQmea/LNMQWPGsthfbCl9j8nvgxy1eEWR8Y8VVr/CsK/vVOnjpXGJkW5poh/nNiLuhX8S21MEWoaAkmhufi/ZjG6ZeznHgTmjV1v8v8f23tqXdrPR27hH+POmP3eSCZj1XQScvJmJG681DT5kVuAE+J1+eOVFZuKL7f2P7WIdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826918; c=relaxed/simple;
	bh=1LWHhh9kY9om0FEmSR25LekCNViLzpNer7KSznzSFrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipMusKjDUWYmMe2vJkgLYo2ps+fqny5AnC7WImd82/WFAZHqVWVQqej42kUl9dNZIDT3tNFJa/XiurzyJ6LtxtSWFzkVPEd4maea7cbZunDkrEaMdXa1QgK5apkgohnolbv04S0PQuKRHUP7iG/+u4Fo+tTkPq61RTDPZ6UzdKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KNhy3iLh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KNhy3iLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6871F00893;
	Sun,  7 Jun 2026 10:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826917;
	bh=aQLq8ppuiU+gmZ4i7G8nKa2cb90rEd2WEaf2Dd7wsDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KNhy3iLhVNAekt1zQZ/TjIy6iF99mC0UGUSz13fKFDkfdWV/oEyvXW8QqbnMZBWYm
	 6Xe5V8u09N9FvIw7N3OFL7Qqa+6L05w70qOBjwy4gAb02eANJ6UwTIyoZMp4HEbxMO
	 wj6tBjIFhVUqix+0rD1jbZois2F7JF0z5zPCBDqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 043/332] ethtool: rss: fix falsely ignoring indir table updates
Date: Sun,  7 Jun 2026 11:56:52 +0200
Message-ID: <20260607095729.697214699@linuxfoundation.org>
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

[ Upstream commit 8d60141a32875248ef71d49c9920fa5e2aa40b29 ]

rss_set_prep_indir() compares the new indirection table against the
current one to determine whether any update is needed. The memcmp
call passes data->indir_size as the length argument, but indir_size
is the number of u32 entries, not the byte count.

Fixes: c0ae03588bbb ("ethtool: rss: initial RSS_SET (indirection table handling)")
Link: https://patch.msgid.link/20260522230647.1705600-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/rss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/rss.c b/net/ethtool/rss.c
index 688c0e4bba69db..4877655f724419 100644
--- a/net/ethtool/rss.c
+++ b/net/ethtool/rss.c
@@ -684,7 +684,7 @@ rss_set_prep_indir(struct net_device *dev, struct genl_info *info,
 				ethtool_rxfh_indir_default(i, num_rx_rings);
 	}
 
-	*mod |= memcmp(rxfh->indir, data->indir_table, data->indir_size);
+	*mod |= memcmp(rxfh->indir, data->indir_table, alloc_size);
 
 	return 0;
 
-- 
2.53.0



