Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA638F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E70DC433C8;
	Sun, 16 Jul 2023 20:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540445;
	bh=Jz5Alhiv4qmFyNu5GmlaTP+nsdGPkRJoOTwi9Jf2ens=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=br8w1rAUvyiaJLzMqpgfwsZ8TDNDbfnKmFl3RRAWZcOvvmGbvUb1id38odIb06yE4
	 RWCA1pb8rMaPL5EiVwe+b9+QpCMTnz3//FU0aDES/oFndEMRfN6b/bYbUalVBq2l2N
	 FcCNtlAFi5jzhySsr3fzaomIz+wcVRSPvm613AW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	EJ Hsu <ejh@nvidia.com>,
	Haotien Hsu <haotienh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 365/591] phy: tegra: xusb: Clear the driver reference in usb-phy dev
Date: Sun, 16 Jul 2023 21:48:24 +0200
Message-ID: <20230716194933.360307043@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: EJ Hsu <ejh@nvidia.com>

commit c0c2fcb1325d0d4f3b322b5ee49385f8eca2560d upstream.

For the dual-role port, it will assign the phy dev to usb-phy dev and
use the port dev driver as the dev driver of usb-phy.

When we try to destroy the port dev, it will destroy its dev driver
as well. But we did not remove the reference from usb-phy dev. This
might cause the use-after-free issue in KASAN.

Fixes: e8f7d2f409a1 ("phy: tegra: xusb: Add usb-phy support")
Cc: stable@vger.kernel.org

Signed-off-by: EJ Hsu <ejh@nvidia.com>
Signed-off-by: Haotien Hsu <haotienh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20230609062932.3276509-1-haotienh@nvidia.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/tegra/xusb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/phy/tegra/xusb.c
+++ b/drivers/phy/tegra/xusb.c
@@ -562,6 +562,7 @@ static void tegra_xusb_port_unregister(s
 		usb_role_switch_unregister(port->usb_role_sw);
 		cancel_work_sync(&port->usb_phy_work);
 		usb_remove_phy(&port->usb_phy);
+		port->usb_phy.dev->driver = NULL;
 	}
 
 	if (port->ops->remove)


