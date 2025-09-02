Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1518308F2D;
	Tue,  2 Sep 2025 13:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819653; cv=none; b=nl0yCC3rG1LVDKzSlEe1h9Y3tvX/vx+dlsQT7f7p4qc3UtL7ImwZozW+n8haLS6HDmFRGzyC3KzHKEkpKHB6ExGZuAVyJ+1kTr5xdEowG6IWqrHAmedRvFwENWWLXe6Nt623z5TcS3kYtqPW5bHQoatNtlb0vavw9spkvb5+PAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819653; c=relaxed/simple;
	bh=IiTet76nMI21yE6faxk8Jaj96VtOA8NSCu/8d0vshYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZUwZ4GGjJ8DF5jYPWR2XzsGQ+m+AKvN9W8MxR0dx0JoZAvS1ZHKaygE8ppO/xAQjPUij6ZgTnobTmNc5IY7HjCvXL0lLQJEIOKvsLqqumUvgF8UG6pFX2cNg9jLzCxPiMHgzHZVI2kaglmsDK7yyIEfPzT12T3IChw3MCudUUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVuScvaF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVuScvaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45D1C4CEED;
	Tue,  2 Sep 2025 13:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819652;
	bh=IiTet76nMI21yE6faxk8Jaj96VtOA8NSCu/8d0vshYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVuScvaFw7JWz2Dc9F+q6vntDAQDRLqQ+OsgqkM23cV/YMwqnk6DXWB/QCY7suteY
	 DBLv2PId0gvytxdIjAVQyHjlL1x+jAUM5VG2O3UNFuKj7Ht5sOligYPwC48wY24qDj
	 n4U0CcoChHA1Ve4/LjCXjrWBxPvc3YbTTxh9Tjro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeounsu Moon <yyyynoom@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 067/142] net: dlink: fix multicast stats being counted incorrectly
Date: Tue,  2 Sep 2025 15:19:29 +0200
Message-ID: <20250902131950.825870667@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yeounsu Moon <yyyynoom@gmail.com>

[ Upstream commit 007a5ffadc4fd51739527f1503b7cf048f31c413 ]

`McstFramesRcvdOk` counts the number of received multicast packets, and
it reports the value correctly.

However, reading `McstFramesRcvdOk` clears the register to zero. As a
result, the driver was reporting only the packets since the last read,
instead of the accumulated total.

Fix this by updating the multicast statistics accumulatively instaed of
instantaneously.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Tested-on: D-Link DGE-550T Rev-A3
Signed-off-by: Yeounsu Moon <yyyynoom@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250823182927.6063-3-yyyynoom@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/dlink/dl2k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink/dl2k.c
index da9b7715df050..f828f38cd7682 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -1091,7 +1091,7 @@ get_stats (struct net_device *dev)
 	dev->stats.rx_bytes += dr32(OctetRcvOk);
 	dev->stats.tx_bytes += dr32(OctetXmtOk);
 
-	dev->stats.multicast = dr32(McstFramesRcvdOk);
+	dev->stats.multicast += dr32(McstFramesRcvdOk);
 	dev->stats.collisions += dr32(SingleColFrames)
 			     +  dr32(MultiColFrames);
 
-- 
2.50.1



