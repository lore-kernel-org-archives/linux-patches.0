Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6DA46AF3C;
	Tue, 16 Jun 2026 16:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628139; cv=none; b=lQVZ9JvA6gC06qG2kbJUYI/6wpvwRvWzPxuSWHn2KNCpfn71UNG+DvL9F3/oVqBDXld6O7WREkYM1g/iStFO6vYTwiPuw337WZp/feuS+eDpxWI345BtVw4Ib3t1fg7pVe1ZiR003nER6Ti9bocxzyOXDKHFPo/X45DYzw75qsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628139; c=relaxed/simple;
	bh=uc/+AQ4Wl0PeusN9lWTL8Ken1OIwq5G/8AxYkbKXqnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9RcIv1huPZ6JEJOXSXuKrQQKYLk4NiLdidGkfhmHeO7vsbjvv0iEMNHXUhPACBoNMvf5E/0VIqaN5q/RGPz61cdb+OXbSCYIZps4L5LFVy1wr5tmoCaWsABB+5d4sV5TlONak2BMnlG9+95tQa+vuyY65xuu0dWe68MXTFxDvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nOjNvY79; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nOjNvY79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E45D1F000E9;
	Tue, 16 Jun 2026 16:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628138;
	bh=Xsbu8m5n+OnRlrK7xbVLN1A3+XDppVDVHCWEN0CHJaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nOjNvY79WtQr8+WXIqRllEXxdftcCR4vdwvJng9lWNn0IpCiXUIaOPSVnfeXI3qxR
	 5stgZTcp7vWGzp1z9Q3sxxrtULh6Q30WUH7UvnJPsvr+M9r2Jo+5uC54KeY4rz+PFb
	 JC2xVoNrbXl6ELeJyz2gnfRhegurB9nL2jMYsXpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/452] ethtool: eeprom: add missing ethnl_ops_begin() / _complete() during fallback
Date: Tue, 16 Jun 2026 20:24:24 +0530
Message-ID: <20260616145119.889034276@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 2376586f85f972fefe701f095bb37dcfe7405d21 ]

All ethtool driver op calls should be sandwiched between
ethnl_ops_begin() / ethnl_ops_complete(). In Netlink eeprom code,
if the paged access failed we fall back to old API, but we
first call _complete() and the fallback never does its own
ethnl_ops_begin(). Move the fallback into the _begin() / _complete()
section.

Fixes: 96d971e307cc ("ethtool: Add fallback to get_module_eeprom from netlink command")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260526153533.2779187-10-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/eeprom.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index 6209c3a9c8f723..15546f2a5e4583 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -134,12 +134,11 @@ static int eeprom_prepare_data(const struct ethnl_req_info *req_base,
 	return 0;
 
 err_ops:
+	if (ret == -EOPNOTSUPP)
+		ret = eeprom_fallback(request, reply);
 	ethnl_ops_complete(dev);
 err_free:
 	kfree(page_data.data);
-
-	if (ret == -EOPNOTSUPP)
-		return eeprom_fallback(request, reply);
 	return ret;
 }
 
-- 
2.53.0



