Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027711;
	b=A/Sb0DH8tuECSczG9TvVw5N5AaC+pXHA0XnkVNauyV3c/jKn+n/L7kcDkm2+aAPiEXgP
	 0l/PTc8Lxis4W1B+ZYCXnkGZ+QfvKEIoJ8+74hcD7oK6jkUb2XO8uINfWljtK1thrMdDX
	 b+7BuDwCLuvyiqpiZGUy7NJBJjJODdUyaxPzoln5FjcyARlmjPcxf6jRpks1Hewln8XhV
	 N+mvNt/07rXPrtHgg8X36hsOSkGACfQx3AwRZgLCLAX3CvE3GabC2l9gRSAc2BWjamLpF
	 aTJ15I59kTT2h+kVw7PdGPobvzRfd8s0NLpTFUZ4yfKk1LAme32pt7vRxVP+N1nIo+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZHQ3g1YfbUlrSylLifuxSVSl/YdKYOR8AoZbRywBhd4=;
	b=MGIIlfKXT2CTUW2LtzkvQtSRYVP/EFzuyR7zjboy3vDhWxLmw9hNOeCgJoICfpDpS5DH
	 SGYGE7hZndI9i1azil9amREMJwrgXcU2J5JvpybQ8pBLNzVgBVYbWywr12rUdeCG3dXFh
	 IhVSx1BV3zXSdtB4uLzCMqD3lmwnZ65nJmSDP7STgLyrkBJvymH1YGUwx0scovTtQ44A+
	 c+HO4j4LDDJFfafkcbNDLdS5Ihenb65MH1ZItuvBp5cFXDIAVa3KAS4DS9A6gACrR9ULi
	 1E5bdVlmGHL+KydD+a2uFTb1LKNe6s5MbVv8SJKwv7o7szaRpSC7FpyWczUcxfpteqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kWDNJUYk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53521606A32F;
	Wed, 18 Nov 2026 18:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kWDNJUYk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1D01F000C6;
	Wed, 18 Nov 2026 18:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027711;
	bh=ZHQ3g1YfbUlrSylLifuxSVSl/YdKYOR8AoZbRywBhd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kWDNJUYkBq5ph1rNVcmmif2VlAyhKmJqFkzMPQqbl8A/awBMV6L4aCSoU/7l6Af4I
	 +1U15QNTfXii/ICC9LrFbAq9EmxJv90iYfCF1RS8vT96fqFDIP6mMZL+WJF1mHaPct
	 KsevTad623gwa5uzo9u6PKbQmTOV06sguT6uXBIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Eric Joyner <eric.joyner@amd.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1886/2151] ionic: fix port_info use-after-free on firmware recovery
Date: Wed, 18 Nov 2026 16:00:21 +0100
Message-ID: <20261118150230.500991050@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 14dc055be3e93..e64ee39d3d69f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -718,6 +718,7 @@ int ionic_port_init(struct ionic *ionic)
 {
 	struct ionic_identity *ident = &ionic->ident;
 	struct ionic_dev *idev = &ionic->idev;
+	bool allocated = false;
 	size_t sz;
 	int err;
 
@@ -729,6 +730,8 @@ int ionic_port_init(struct ionic *ionic)
 						     GFP_KERNEL);
 		if (!idev->port_info)
 			return -ENOMEM;
+
+		allocated = true;
 	}
 
 	sz = min(sizeof(ident->port.config), sizeof(idev->dev_cmd_regs->data));
@@ -745,10 +748,12 @@ int ionic_port_init(struct ionic *ionic)
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



