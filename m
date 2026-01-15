Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7333BFE34;
	Thu, 15 Jan 2026 17:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499308; cv=none; b=cRBuzLPIKuTN9E/6IunIDh5KQQHaHeyyRNpo5JRoB2KTelYpKi75buugY1Ve0hW5PmjrnCP7AIicJLemrRWalHu4j5F8c3jkKmD0m0DCv4f6BeqszC23QJSJjsPFRgSlFsLSzDZIFL1RfS//Wty+91P/psHuqxtI/uwgLQaRlZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499308; c=relaxed/simple;
	bh=sQyW5anxP8xXW2yEIRCvrJ43G7ZjlGpASNdZ4+f10Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uda/oWxlUCFF+zGdq4Pa3GIR92UkG1eNiQ00m2FtxOg5NEIOLy6NCP5XiuTNELRk9+OLozRWsPU2CxxCXM7s+gwzLpGw9BtLzWd3hqgHuKofY59oActOqDl8O2hqEHjnrt+gOJwQC6N/ULEaoOcxwmlEhdfwLVXaTmmBfdXa5bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKyZKLS1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKyZKLS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280DDC116D0;
	Thu, 15 Jan 2026 17:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499308;
	bh=sQyW5anxP8xXW2yEIRCvrJ43G7ZjlGpASNdZ4+f10Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QKyZKLS1imEIID5xKRdQXB4+lUrebub1xzaTliQxHWss3B/5XAZ8y9pTMKYguuEOb
	 VO6LNlTwdlTS2RfNzG2ytwtLxlSwcI+s26pOoApbVu8koyCS3RIIFv9b9YbT/qGUUy
	 qag+2/1V43GYtxNrDm5NwUevw8k5t4koDPbOXHjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 181/451] net/ethtool/ioctl: remove if n_stats checks from ethtool_get_phy_stats
Date: Thu, 15 Jan 2026 17:46:22 +0100
Message-ID: <20260115164237.451935025@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniil Tatianin <d-tatianin@yandex-team.ru>

[ Upstream commit fd4778581d61d8848b532f8cdc9b325138748437 ]

Now that we always early return if we don't have any stats we can remove
these checks as they're no longer necessary.

Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 7b07be1ff1cb ("ethtool: Avoid overflowing userspace buffer on stats query")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index ede11854f493f..8f7efe152a7bb 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2063,28 +2063,24 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 
 	stats.n_stats = n_stats;
 
-	if (n_stats) {
-		data = vzalloc(array_size(n_stats, sizeof(u64)));
-		if (!data)
-			return -ENOMEM;
+	data = vzalloc(array_size(n_stats, sizeof(u64)));
+	if (!data)
+		return -ENOMEM;
 
-		if (phydev && !ops->get_ethtool_phy_stats &&
-		    phy_ops && phy_ops->get_stats) {
-			ret = phy_ops->get_stats(phydev, &stats, data);
-			if (ret < 0)
-				goto out;
-		} else {
-			ops->get_ethtool_phy_stats(dev, &stats, data);
-		}
+	if (phydev && !ops->get_ethtool_phy_stats &&
+		phy_ops && phy_ops->get_stats) {
+		ret = phy_ops->get_stats(phydev, &stats, data);
+		if (ret < 0)
+			goto out;
 	} else {
-		data = NULL;
+		ops->get_ethtool_phy_stats(dev, &stats, data);
 	}
 
 	ret = -EFAULT;
 	if (copy_to_user(useraddr, &stats, sizeof(stats)))
 		goto out;
 	useraddr += sizeof(stats);
-	if (n_stats && copy_to_user(useraddr, data, array_size(n_stats, sizeof(u64))))
+	if (copy_to_user(useraddr, data, array_size(n_stats, sizeof(u64))))
 		goto out;
 	ret = 0;
 
-- 
2.51.0



