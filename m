Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056730;
	b=3TsbZN9ic49pgrb3T16F3sKmzTLsQXWxzqheVQlVfNwVDu6De+lzUUWjuJ+9rYbXIETb
	 sSVnKVbVHME9UE1s3eMw0/Qu2HefDXLNHv7qcjjsBUhhaWTPWj7Im1Fx5pjSwQF24X6tt
	 jg2SyGlMwyZzJRKFm7YaQ5qupOrfm8llZgg0+mLwCJRGfUJjc5gl8vsNeeNiuFeiKYyMh
	 tNB4wCgWYAAkNIeupIMSDtFkgW5ixtheh8rM5yIyWgF9meuOqn2xwhucuqMa1lhwTp3g+
	 zRSMn7lJ8SDVewDHKbXwN2NRSKa5p5W5us11IWxMpVTQPr9WOiZZNGuzg7HV13KYeug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wtaOB6t+maaPD4fuWqAUpKSmYXL/6o7Dq+asHwqRjbA=;
	b=GLThVxoBGQV20K6wNkyJwDbmXqTLCbANAqHQokDGBrLWO9L3Xde3tSV1aG2vGYekCdVC
	 QmerCiIp2hz6vHltV8AG5UYqoV+9JjAvw3TSQeZQ1rfF7mm1XSL7UjgYocZu2LvT1lYiB
	 rFZxFAJJpJ33OOfLLISijaTq0A3AhDk9ftREx4GTtLG/37XsINeU3CSR+/1Fn6splTe7W
	 YAm8+z5ylOWEEI9r7jOmeUUZ+8KoJHyA7DLL5Uo4aqgk0fJrXNtuzyI/errL0hIEK6m5N
	 XFXWEiOFH+tqntUk7mBNNISnlykDirCRKXZprs5d7eCkjRGj/1oYJesteuaEKU24Kpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=suFjZYxL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F8C606A31C;
	Thu, 19 Nov 2026 02:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=suFjZYxL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF561F000C4;
	Thu, 19 Nov 2026 02:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056730;
	bh=wtaOB6t+maaPD4fuWqAUpKSmYXL/6o7Dq+asHwqRjbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=suFjZYxLHeQ6tq6n14CpCMuRiLTPuzEiHuwnGltRLINSlv7ctGg+ga6mN7dS1tCik
	 GmFUUDPF9cNj9Ii+NSpkJ35Rt/0UPUrGDZaAhc8xfZyr0r77Pmbp1LaXxmazEKe1k3
	 yd29rJQl6L0/2Efebs4kv7jAm4rFusGlA+XxowKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Eric Joyner <eric.joyner@amd.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2093/2214] ionic: fix port_info use-after-free on firmware recovery
Date: Wed, 18 Nov 2026 16:02:49 +0100
Message-ID: <20261118150134.355449332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit d90d1a768b3b022c52beafb3a4701ee2ee3d2b5e ]

ionic_port_init() allocates port_info when the pointer is NULL, but its
error path frees it without checking whether this call allocated it.
Before commit ddc5911b9bd2 ("ionic: call ionic_port_init after
fw-upgrade") the function returned early when the buffer already
existed, so the two were symmetric.

Since then a failed PORT_INIT on either recovery path - fw_up or
reset_done - frees a buffer an earlier init owns, while the netdev is
registered and the ethtool ops are reading it.

Free only what this call allocated.

Fixes: ddc5911b9bd2 ("ionic: call ionic_port_init after fw-upgrade")
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Signed-off-by: Eric Joyner <eric.joyner@amd.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20261015-ionic-port-info-lifetime-v2-1-57232013fd79@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 7942a7f0f7b38..20ea9057d6d3d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -526,6 +526,7 @@ int ionic_port_init(struct ionic *ionic)
 {
 	struct ionic_identity *ident = &ionic->ident;
 	struct ionic_dev *idev = &ionic->idev;
+	bool allocated = false;
 	size_t sz;
 	int err;
 
@@ -537,6 +538,8 @@ int ionic_port_init(struct ionic *ionic)
 						     GFP_KERNEL);
 		if (!idev->port_info)
 			return -ENOMEM;
+
+		allocated = true;
 	}
 
 	sz = min(sizeof(ident->port.config), sizeof(idev->dev_cmd_regs->data));
@@ -553,10 +556,12 @@ int ionic_port_init(struct ionic *ionic)
 	mutex_unlock(&ionic->dev_cmd_lock);
 	if (err) {
 		dev_err(ionic->dev, "Failed to init port\n");
-		dma_free_coherent(ionic->dev, idev->port_info_sz,
-				  idev->port_info, idev->port_info_pa);
-		idev->port_info = NULL;
-		idev->port_info_pa = 0;
+		if (allocated) {
+			dma_free_coherent(ionic->dev, idev->port_info_sz,
+					  idev->port_info, idev->port_info_pa);
+			idev->port_info = NULL;
+			idev->port_info_pa = 0;
+		}
 	}
 
 	return err;
-- 
2.53.0



