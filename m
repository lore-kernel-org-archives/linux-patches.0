Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2FF2FC36;
	Fri, 24 Nov 2023 19:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dwf5Z8hG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D02DC433D9;
	Fri, 24 Nov 2023 19:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853498;
	bh=zMxC1133JzdG7ZrnvDY9ZZDQSEMQ0ut8KWKJGUuyRrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwf5Z8hGviUh5DhAhcQX5JG/ih2SDfduIdisnEjje41LFKOadpG6XbaH0kpXDiUpD
	 GTseErCcHy820gshE3eiSqzgI6rulBM0RlFl4LMpOlMeNf/4B1wkYLg92cI8Y0grpS
	 ahHve4tPoM7czDE6uMY0AdiIwwLfQ7+toPw3IB4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Singh <ajay.kathat@microchip.com>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.15 187/297] wifi: wilc1000: use vmm_table as array in wilc struct
Date: Fri, 24 Nov 2023 17:53:49 +0000
Message-ID: <20231124172006.774937085@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ajay Singh <ajay.kathat@microchip.com>

commit 05ac1a198a63ad66bf5ae8b7321407c102d40ef3 upstream.

Enabling KASAN and running some iperf tests raises some memory issues with
vmm_table:

BUG: KASAN: slab-out-of-bounds in wilc_wlan_handle_txq+0x6ac/0xdb4
Write of size 4 at addr c3a61540 by task wlan0-tx/95

KASAN detects that we are writing data beyond range allocated to vmm_table.
There is indeed a mismatch between the size passed to allocator in
wilc_wlan_init, and the range of possible indexes used later: allocation
size is missing a multiplication by sizeof(u32)

Fixes: 40b717bfcefa ("wifi: wilc1000: fix DMA on stack objects")
Cc: stable@vger.kernel.org
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20231017-wilc1000_tx_oops-v3-1-b2155f1f7bee@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -1458,7 +1458,7 @@ int wilc_wlan_init(struct net_device *de
 	}
 
 	if (!wilc->vmm_table)
-		wilc->vmm_table = kzalloc(WILC_VMM_TBL_SIZE, GFP_KERNEL);
+		wilc->vmm_table = kcalloc(WILC_VMM_TBL_SIZE, sizeof(u32), GFP_KERNEL);
 
 	if (!wilc->vmm_table) {
 		ret = -ENOBUFS;


