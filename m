Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCB94071DA;
	Sun,  7 Jun 2026 10:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827365; cv=none; b=UPsp+Hx4aMqRGn3/LoDTVCGfT9RNMvfN3tZUm9neVLlob0jUnY8GXPlhRAAAj5rf9c4JxAB1fxNIgmB4iktKRejAaiuhiVktuVHl6T3vW3Dd4lu1ImFi7sKxT+TwPkPyU7dht7W2BbLAR526JhFWFAwtgeexNelzlzZHqf/8Gtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827365; c=relaxed/simple;
	bh=wnW4g+At/f8307/l57vrEbo88QjLSRNwSlorU+HrP+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbDGF3wM9hDSdjjCBtUBoLz2QEswyyogieZDJRbWHmrbebd0wB8dkpaRwa4d9rhKsp1GbZexeWKlLImAQbC2Dz/mjGYeu7CqKlQ/RApHjV5UCnwKPdrPUo3onWZHahbh3buPnjp8GLSzC/jSexOZ5FgJoXFh6lmOJEVaFs7FPlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aczNUCq6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aczNUCq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7311F00893;
	Sun,  7 Jun 2026 10:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827364;
	bh=qfZjm2UAn8xVLvZ5LrzNvMLB86izepBTNfWvU7rI6oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aczNUCq6nnO9+Yhj+5y8eAntgtp7xjKGCzIKpcrHn9v0jBWvedHYBo5sfHnTKPIJD
	 lZApJexyCUZe1W9kPRx9LiFHPbY22mxTwTPIH4NYH3zs0ppI8B2SFdvMFFQLnJ/V4I
	 UJvm/WOYXlnt8PLJ7SfI+S5jIk/F3yjZR/yDo+k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/307] ethtool: rss: fix hkey leak when indir_size is 0
Date: Sun,  7 Jun 2026 11:57:26 +0200
Message-ID: <20260607095729.516126250@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

[ Upstream commit 78ccf1a70c6378e1f5073a8c2209b5129067b925 ]

rss_get_data_alloc() allocates a single buffer that backs both the
indirection table and the hash key, but only assigned data->indir_table
when indir_size was nonzero. The expectation was that no driver
implements RSS without supporting indirection table but apparently
enic does just that (it's the only such in-tree driver).
enic has get_rxfh_key_size but no get_rxfh_indir_size.
data->indir_table stays as NULL, hkey gets set but rss_get_data_free()
kfree(data->indir_table) is a nop and the allocation leaks.

Always store the allocation base in data->indir_table so the free path
is unambiguous. No caller treats indir_table as a sentinel; everything
keys off indir_size.

Fixes: 7112a04664bf ("ethtool: add netlink based get rss support")
Link: https://patch.msgid.link/20260522230647.1705600-6-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/rss.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ethtool/rss.c b/net/ethtool/rss.c
index 8aa45f3fdfdf08..3570d58c5cca6d 100644
--- a/net/ethtool/rss.c
+++ b/net/ethtool/rss.c
@@ -78,8 +78,7 @@ rss_prepare_get(const struct rss_req_info *request, struct net_device *dev,
 		goto out_ops;
 	}
 
-	if (data->indir_size)
-		data->indir_table = (u32 *)rss_config;
+	data->indir_table = (u32 *)rss_config;
 	if (data->hkey_size)
 		data->hkey = rss_config + indir_bytes;
 
-- 
2.53.0



