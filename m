Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E749460;
	Sat, 17 Oct 2026 17:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258852; cv=none; b=LrzbcFQXUAZEQcd/1PM1dQ4GseXZazpf8/5MpaKVtM2NvN+Gnz1iG/pK34VibVd8Qq5wXuydVYT9eIL1uN1NnjU2jHvTylcpcgQRQxyaK3A0/fkVBL6NAP+/d5NVkhkvVGlnGrWlbBu+NNa2VKAsyJKWrejQ5ldm7T5l4BP2ulE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258852; c=relaxed/simple;
	bh=VdpoZ5eyQ7/e2TCURPjhZiM92a35mNROWjQU2XJluSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMu0R4tmarwZ2H/j8bfrmDqFEUDMS/Y2tzBta1n83CC+Vo8vtFrZLx3Z+Y4USRyX0A8b+ZS56Z9fgZZ5AesD5+pKIiMGJ6hrqthQNzcWY1SAPnJlMQ6WYeLjdoKNaAM/IC032bRvU/YrDT6Gx86ivyvhlKwfvYR+YdnRuk268Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QpOmZQfe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QpOmZQfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE4A1F000C4;
	Sat, 17 Oct 2026 17:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258851;
	bh=i+wgrccMdMeyOUMpPXLw6fOIbxRd7dytqMfvDXMhVU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QpOmZQfetSLqXywgpz44/Azt/0TaEzoam1tpqPr3Hnui93qVL0s2secCYt99BRq2M
	 NULkTf6mib89E5RgIyTSjIP8v2KL6GCMPpCwrusZwuCB3rDCcD+pLW3F0wx5TQbf0R
	 g7LonnDbHSBJg3U9Q9xAfYPip5f2Mn167AXEjz5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0980/1674] tap: fix stack info leak in tap_ioctl() SIOCGIFHWADDR
Date: Sat, 17 Oct 2026 17:54:12 +0200
Message-ID: <20261017160456.279805552@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 5f01c875e49ee..40aea069c3ad3 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1015,7 +1015,7 @@ static long tap_ioctl(struct file *file, unsigned int cmd,
 	unsigned int __user *up = argp;
 	unsigned short u;
 	int __user *sp = argp;
-	struct sockaddr sa;
+	struct sockaddr sa = {};
 	int s;
 	int ret;
 
-- 
2.53.0



