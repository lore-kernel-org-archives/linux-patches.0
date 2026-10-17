Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88113374E60;
	Sat, 17 Oct 2026 16:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254010; cv=none; b=ZZCp5/2D3BQlk2qJkA27Iq+w8vO/omukvjt6WkcmfsiDGyAKqWAJpKIAn3sh9VJRtMHLdPCIqlT7cW5cFJBo8F0xH0SOsNOVePSrC0xAP5Ct2Nqh7cUEERDnU4j3X37tkyoYIazuTDFRI/E8YUpteQCtGb6MmxP+MRNxGVneSq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254010; c=relaxed/simple;
	bh=4LuO4Ym92bE9QvnoRmoZAPZ3b8SiqTDbPQJI4XoPX4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okzaXAQN4SoRcFmqjd+L7biiD4wW7xL82rIDFhwFlqGkVOssld/VMVktaRgYfplRCWR6P+1G6wrwKJ8zHP5veCLmKdlzTf6KbGZTEPGwPuJFA54g+x+V16lII+2quuMNw7myNmGz6wmhd4ITv+WX7RQ8/jggutbYFegnBjA5qFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lkYvAqSn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lkYvAqSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9CB1F000C4;
	Sat, 17 Oct 2026 16:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254009;
	bh=mfSaMEewt7RSxdkLYtbF0eatk44UxysfMzoFDfdX2qM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lkYvAqSngtupH51rINT85pnlsH0/nnw2N1HIaK6bwxpqN5GYwDJF7gZ4BENaHoGS6
	 lLubnGdN4wPJyFfpQyKL1rST8w8XeguSgH4H0ZLOYSghKdk41PJikFQP69nfgK8+l2
	 6YAWY9SBxEMemnjmqb7GG9qZlBLsWDDu/JRjtn5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 306/869] tap: fix stack info leak in tap_ioctl() SIOCGIFHWADDR
Date: Sat, 17 Oct 2026 17:52:27 +0200
Message-ID: <20261017160044.920519782@linuxfoundation.org>
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
index b3cb7d5a95850..018bc2941a967 100644
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



