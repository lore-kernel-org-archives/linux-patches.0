Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71332E858;
	Fri, 24 Nov 2023 18:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RVtNLK/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D0BC433C8;
	Fri, 24 Nov 2023 18:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852359;
	bh=RbxTz4hzJM6NH4fOmJDXPfrdFMEaXA+L0rzL55OYmTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVtNLK/nXxpEKeUjyCOUu4ca+gOg7yGZlJgMZkq17MA0pJBLRpI5fKNnR6rNflpF0
	 V+q9RsyKA86D6LWEjnBlNZ5xH6b0ym45FUjVDgFRIbMJXBbcKfxgYZWUtp7KIe4Bmd
	 SnJ9jPqLKmToHI5Z/pR/s0SXIt5e+wzCeTKALMjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clark Wang <xiaoning.wang@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 299/372] i3c: master: svc: add NACK check after start byte sent
Date: Fri, 24 Nov 2023 17:51:26 +0000
Message-ID: <20231124172020.396636919@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clark Wang <xiaoning.wang@nxp.com>

[ Upstream commit 49b472ebc61de3d4aa7cc57539246bb39f6c5128 ]

Add NACK check after start byte is sent.
It is possible to detect early that a device is not on the bus
and avoid invalid transmissions thereafter.

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20230517033030.3068085-3-xiaoning.wang@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 9aaeef113c55 ("i3c: master: svc: fix random hot join failure since timeout error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index 0454f16ac9aae..0263f30bae82e 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -92,6 +92,7 @@
 #define SVC_I3C_MINTCLR      0x094
 #define SVC_I3C_MINTMASKED   0x098
 #define SVC_I3C_MERRWARN     0x09C
+#define   SVC_I3C_MERRWARN_NACK BIT(2)
 #define SVC_I3C_MDMACTRL     0x0A0
 #define SVC_I3C_MDATACTRL    0x0AC
 #define   SVC_I3C_MDATACTRL_FLUSHTB BIT(0)
@@ -1028,6 +1029,11 @@ static int svc_i3c_master_xfer(struct svc_i3c_master *master,
 	if (ret)
 		goto emit_stop;
 
+	if (readl(master->regs + SVC_I3C_MERRWARN) & SVC_I3C_MERRWARN_NACK) {
+		ret = -ENXIO;
+		goto emit_stop;
+	}
+
 	if (rnw)
 		ret = svc_i3c_master_read(master, in, xfer_len);
 	else
-- 
2.42.0



