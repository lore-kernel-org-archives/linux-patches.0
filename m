Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB172E2F0F;
	Tue, 15 Jul 2025 13:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587984; cv=none; b=QYwSPgGC2j1LAbufjlXHVSXmxeJ5mt1Xvq9EfHrPhvcU5D1DW6US1+oYPy1e1WoqXWjIt5x2fO1jlcrJ7fSRIxmy1wT3512j/CkLmf9nNxtrKtEc/v5FMkdFvAvYkDCpSip7mmGQfHWWnugaSC5j/JW1KYYgr+z0cPxLph8jvVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587984; c=relaxed/simple;
	bh=tX/B96UdSNi1UGPEYvGCntCI8wtlOSUb9UG+DYo7Wd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u77Wcr2Hmx05vJEuJPC0QeZaDzO8C5T+4SQLx/ZZUeS7UHD14cAguXxQMqLrn4DY1RmKVzZTqRKRRz6Ky81exjdMSLb22jTNOkgtMU5ysDcBV/WG80BZ+dnF3HrRwu4x9d4N5MtkJUE+LV1SGo6C+cg/d6OCIsb8K/F0aJzSx7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmDK3YV1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmDK3YV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6660C4CEE3;
	Tue, 15 Jul 2025 13:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587984;
	bh=tX/B96UdSNi1UGPEYvGCntCI8wtlOSUb9UG+DYo7Wd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmDK3YV1KRV4RrXyOZqPZzAWsleS8OGxT5Cf7s1nVWCXYDiClhEA0IhUDk0Vc/TX5
	 EKdI+bQ4G2JW0kVebTEDbEa2pWt+ROUhuFFmidwydU7rD2QI5sbcFIXLrTKqI+a+8H
	 +u+ONWApkzytizzf/Xl9lcSBF9ImR+fmCmtE7vgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 196/208] um: vector: Reduce stack usage in vector_eth_configure()
Date: Tue, 15 Jul 2025 15:15:05 +0200
Message-ID: <20250715130818.795467798@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit 2d65fc13be85c336c56af7077f08ccd3a3a15a4a ]

When compiling with clang (19.1.7), initializing *vp using a compound
literal may result in excessive stack usage. Fix it by initializing the
required fields of *vp individually.

Without this patch:

$ objdump -d arch/um/drivers/vector_kern.o | ./scripts/checkstack.pl x86_64 0
...
0x0000000000000540 vector_eth_configure [vector_kern.o]:1472
...

With this patch:

$ objdump -d arch/um/drivers/vector_kern.o | ./scripts/checkstack.pl x86_64 0
...
0x0000000000000540 vector_eth_configure [vector_kern.o]:208
...

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506221017.WtB7Usua-lkp@intel.com/
Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Link: https://patch.msgid.link/20250623110829.314864-1-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/vector_kern.c | 42 +++++++++++------------------------
 1 file changed, 13 insertions(+), 29 deletions(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index da05bfdaeb1db..a37007e42265a 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1600,35 +1600,19 @@ static void vector_eth_configure(
 
 	device->dev = dev;
 
-	*vp = ((struct vector_private)
-		{
-		.list			= LIST_HEAD_INIT(vp->list),
-		.dev			= dev,
-		.unit			= n,
-		.options		= get_transport_options(def),
-		.rx_irq			= 0,
-		.tx_irq			= 0,
-		.parsed			= def,
-		.max_packet		= get_mtu(def) + ETH_HEADER_OTHER,
-		/* TODO - we need to calculate headroom so that ip header
-		 * is 16 byte aligned all the time
-		 */
-		.headroom		= get_headroom(def),
-		.form_header		= NULL,
-		.verify_header		= NULL,
-		.header_rxbuffer	= NULL,
-		.header_txbuffer	= NULL,
-		.header_size		= 0,
-		.rx_header_size		= 0,
-		.rexmit_scheduled	= false,
-		.opened			= false,
-		.transport_data		= NULL,
-		.in_write_poll		= false,
-		.coalesce		= 2,
-		.req_size		= get_req_size(def),
-		.in_error		= false,
-		.bpf			= NULL
-	});
+	INIT_LIST_HEAD(&vp->list);
+	vp->dev		= dev;
+	vp->unit	= n;
+	vp->options	= get_transport_options(def);
+	vp->parsed	= def;
+	vp->max_packet	= get_mtu(def) + ETH_HEADER_OTHER;
+	/*
+	 * TODO - we need to calculate headroom so that ip header
+	 * is 16 byte aligned all the time
+	 */
+	vp->headroom	= get_headroom(def);
+	vp->coalesce	= 2;
+	vp->req_size	= get_req_size(def);
 
 	dev->features = dev->hw_features = (NETIF_F_SG | NETIF_F_FRAGLIST);
 	tasklet_init(&vp->tx_poll, vector_tx_poll, (unsigned long)vp);
-- 
2.39.5



