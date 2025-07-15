Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31CDBA42;
	Tue, 15 Jul 2025 13:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586269; cv=none; b=WKc11M0mwA1tiMrTZ0ENGyaGhJYQfWsOceqlzFKWp2cBzdOC8ptRpU2vvrDEsYy3u/hBVfSljNNN0co5ZfWle7q/sVNs2PDQtwvPVjebxauc4OKhQy7QOuTfRerPspFhFHsZLaZvJ1Q8tdZOxqy1/XUrprUd90c5o9XiZM2Kwk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586269; c=relaxed/simple;
	bh=kgKbmL+jlLm478GoqLEbkdd/kvCpSQHZcWmla6SBD4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDnep+iCC02PZSJWxgLGrjOmtspSAaEpHFlSnOLTFi1kF3INhVuS+4cPVE+RjxAessdzmOktOVVPClizlB84lhe9JMc6w2M1kzhicyPVM3VSAyN2m8SqSk02eHDGb4HOT0ecCxbQE9qnngwxxqP/9XeM1z6xXJMT/hARubl6bdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zz7BT87k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zz7BT87k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FC9C4CEE3;
	Tue, 15 Jul 2025 13:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586268;
	bh=kgKbmL+jlLm478GoqLEbkdd/kvCpSQHZcWmla6SBD4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zz7BT87k2VsQE/aV8uEoibnKQIxXMwqY9ic8a5FvuHW00nJdLYYXAfvb7HqEdANpW
	 vCsSDta5YiC+FUz6W6i7Hn9QNqH14zo1gYxuB528aleMgudrNUfyGRtNE3vsZyTQkJ
	 uRDRb4n24FAdrDjiX4MKvDn7exLRlVNr3vvXVBNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 68/77] um: vector: Reduce stack usage in vector_eth_configure()
Date: Tue, 15 Jul 2025 15:14:07 +0200
Message-ID: <20250715130754.456435557@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c63ccf1ab4a20..41fc93ce4d372 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1603,35 +1603,19 @@ static void vector_eth_configure(
 
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
 	tasklet_setup(&vp->tx_poll, vector_tx_poll);
-- 
2.39.5



