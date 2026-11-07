Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063285;
	b=zDpqobzg+R9cnMYlTohcoiPCGvi6bHeGdfKBOaTm28OryJ+Tqa8J/NCud6jO78KRT+Gi
	 xfbiTplh2vm1bOKuY6CtbBSsrPD0F5KIsOI+aLYx5znmiqHf+gJ4xtR3Uf9AX2XGXOtIF
	 2L5VvDG1oTEPIsoyedsH0vWgp3L1Vbf2ZT3s057+OrAEcMpj4QHzOqZgwWgMMoQzuLX9S
	 mXnQ4j4Jeu2/AXcNnvFDu4q7gkUVOlMPTDjQWcbLAIyhyfObbPlr8eCntPGsKvJyWCH9o
	 CJd0GKkFraUu1XJKMXLLwDpQD9W2C5sfuGWUEaOEKKNgPmlOj86sXvGoRKzkaqiygCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063285;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0Lj524IKhI3F6pz2kXdrvgT59drpL+6DOrrVgnKN+b8=;
	b=b71akF9OE9hi/rI332YtwSN6siE1uoZ2+VXusbEKBWCPajfpvJ3OgW7wIwuA3jsJG9YT
	 wPdJPozcO7eAMnRJpEcrJuHHVsxsbvdrsSf0ftPBTAKtL8PljRZyHHDuoGbSdYJSyOJ65
	 DvckxsdPzjoIY7FX1Euhxu06EcVhgsV95L3xt6ZkxbFT/ff66nlYzulkqcB+4qp6NIqWS
	 ricQiYh9fvT60UZlID4oxrA1LSwNga6oHixkA07MM/XY70clY5o0K+mwH2B40BlyYXdIE
	 p7RGwB4Lw/cMnMXFoPPUdI1mpEB9xP5EA5iXYDFvV2xAGOeeACA/bHnxiloIMfr664Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GpGJc09j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2A9606A32E;
	Sat,  7 Nov 2026 14:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GpGJc09j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BA81F0089F;
	Sat,  7 Nov 2026 14:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063284;
	bh=0Lj524IKhI3F6pz2kXdrvgT59drpL+6DOrrVgnKN+b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GpGJc09jQTkTrf2Dhq3oihA1HJTIfGbkwubnLQ3KfZPdSghKSPmiK3cZZKVLcDWqg
	 W7d/XdaPtfvGN9I+eE/cWxGeiLQam8jcAepaQ4RMdAuq5grubf5AG4qcytCAviRlx2
	 vlW0T20A4dI14PrsmAPbnzWewQKPZ89Ee/b4tJsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Juergen Gross <jgross@suse.com>,
	Jiqian Chen <Jiqian.Chen@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 440/869] xen-pciback: Fix pcistub_device ref leak in pcistub_get_gsi_from_sbdf()
Date: Sat,  7 Nov 2026 08:52:02 -0500
Message-ID: <20261107134908.688951686@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit cfaf31becde901f7a2376d36db628f8be0bc7283 ]

pcistub_get_gsi_from_sbdf() obtains the stub device with
pcistub_device_find(), which returns it with its kref incremented, and
returns psdev->gsi without dropping that reference again.  The caller
cannot release it either, so every lookup leaks one reference to the
stub device.

Release the reference after reading gsi.

Fixes: 2fae6bb7be32 ("xen/privcmd: Add new syscall to get gsi from dev")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jiqian Chen <Jiqian.Chen@amd.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260916171141.2086627-1-vulab@iscas.ac.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xen-pciback/pci_stub.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 7de2fa67743c6..b128ceeee21bc 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -234,13 +234,16 @@ static int pcistub_get_gsi_from_sbdf(unsigned int sbdf)
 	int bus = PCI_BUS_NUM(sbdf);
 	int slot = PCI_SLOT(sbdf);
 	int func = PCI_FUNC(sbdf);
+	int gsi;
 
 	psdev = pcistub_device_find(domain, bus, slot, func);
-
 	if (!psdev)
 		return -ENODEV;
 
-	return psdev->gsi;
+	gsi = psdev->gsi;
+	pcistub_device_put(psdev);
+
+	return gsi;
 }
 #endif
 
-- 
2.53.0



