Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733393D90
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JmmeqEgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28109C4E778;
	Wed, 15 Nov 2023 20:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081827;
	bh=NCSt9+3Gc51TCLajc5BIF3bkZrdcuSjPODN2oWCIqE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JmmeqEgipRD3Q7J37F9zAMTUbZZ6Lp3VkwnlLB+mGxWXrthM88CZTAMV0H4CPHeBp
	 6hwmQpgYQkgNQHmKTMEGZ1L+MJxOISN/DNMwrR98sVCsIEUz4W5v6oo2aQVEuTeTR7
	 l37ccaWHHaMIMaLoTpglCjv/qSR3s1F9m39pIDeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 150/191] pcmcia: cs: fix possible hung task and memory leak pccardd()
Date: Wed, 15 Nov 2023 15:47:05 -0500
Message-ID: <20231115204653.504983214@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit e3ea1b4847e49234e691c0d66bf030bd65bb7f2b ]

If device_register() returns error in pccardd(), it leads two issues:

1. The socket_released has never been completed, it will block
   pcmcia_unregister_socket(), because of waiting for completion
   of socket_released.
2. The device name allocated by dev_set_name() is leaked.

Fix this two issues by calling put_device() when device_register() fails.
socket_released can be completed in pcmcia_release_socket(), the name can
be freed in kobject_cleanup().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pcmcia/cs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index f70197154a362..820cce7c8b400 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -605,6 +605,7 @@ static int pccardd(void *__skt)
 		dev_warn(&skt->dev, "PCMCIA: unable to register socket\n");
 		skt->thread = NULL;
 		complete(&skt->thread_done);
+		put_device(&skt->dev);
 		return 0;
 	}
 	ret = pccard_sysfs_add_socket(&skt->dev);
-- 
2.42.0



