Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7931932ABC0;
	Thu, 28 May 2026 20:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999218; cv=none; b=npWiu4l9Eckd/zV6NPT6LP73X3xM2EFk7b9lgcp3Fzsrt1KMomphal7wLbM7TaUj8mJDPMPkoUGM7QhT3BiAbMnAdij9W9VltJVTAs6Jjk/QeApqw5Uuh/tuIio6l2py8J4/HsbX41k+2YBPqthk9a+nes094y6mb8RAncmzfUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999218; c=relaxed/simple;
	bh=SQLjxWddgW6PsWprr1n/lPLvkTW/NnQUI7Z5aZl4NQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9jXCoCGmx4v/DRFDBMLOyMu3cMksYMZf2pcw41pUjalThntPkKc67p9qQcCEDHlWIYZUhu5GZAXgelPmrK7Sz7rPsoEKm6ZzwsYGFilCPGH/mLLONvvs3lyT2BbeO6c+7bYWsE2u4kn3mp3XhNCGcmnY9WFZ0r1WvZlUoiTCNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DaXz/2sa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DaXz/2sa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA201F000E9;
	Thu, 28 May 2026 20:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999217;
	bh=foMvkMCtMqePSbNW044/dcqLLaQn8Ab44m+ZicyR9/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DaXz/2sagwZmFWQMH5pzh+1BqeyjTLN22OPx/WHnVMFiD6xxsou8WoMaZsJcM0xND
	 zAG9wTfIxi1etHB6jdjqXeZGL4rJuC1Q1th9mURJtv+it5FAtpVUfo3Gmd4i33vqA9
	 QI0qm7rvs2YEMfucA9wuqSoWr/GjRF2SOxTDQiGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 450/461] tap: fix stack info leak in tap_ioctl() SIOCGIFHWADDR
Date: Thu, 28 May 2026 21:49:39 +0200
Message-ID: <20260528194700.566193622@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit bddc09212c24934643bd44fc794748d2bbb3b6cd ]

In the SIOCGIFHWADDR path, tap_ioctl() copies 16 bytes of an
uninitialised on-stack struct sockaddr_storage to userspace via
ifr_hwaddr, but netif_get_mac_address() only writes sa_family and
dev->addr_len (6 for Ethernet) bytes, leaving sa_data[6..13] uninitialised.

Those 8 trailing bytes leak kernel stack contents; SIOCGIFHWADDR on a
macvtap chardev returns kernel .text and direct-map pointers, defeating
KASLR.

Initialise ss at declaration.

Fixes: 3b23a32a6321 ("net: fix dev_ifsioc_locked() race condition")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260520075736.3415676-3-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index b8240737dc519..a590e07ce0a98 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -919,11 +919,11 @@ static long tap_ioctl(struct file *file, unsigned int cmd,
 	struct tap_queue *q = file->private_data;
 	struct tap_dev *tap;
 	void __user *argp = (void __user *)arg;
+	struct sockaddr_storage ss = {};
 	struct ifreq __user *ifr = argp;
 	unsigned int __user *up = argp;
 	unsigned short u;
 	int __user *sp = argp;
-	struct sockaddr_storage ss;
 	int s;
 	int ret;
 
-- 
2.53.0



