Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D086C5D72E;
	Mon, 18 Dec 2023 14:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qLJTEUx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E706DC433C8;
	Mon, 18 Dec 2023 14:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908043;
	bh=p5nT8riswv396fP98IB2TlKX+S+Ie56eGAAPVfqKHo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qLJTEUx29KWDWtUOTdUA4XiEtZetPVVir2hYRzX5nUl0FmuGCsuKcS8++aQXEDHmP
	 sC+kds4WFbLsya7etEnJ8HPPE+bvnpipotnaZRD4bdwduZT1qHqGzhUXjBgoDXkXJm
	 Vo0N9ny5mGWMQrXDo2hN7WO5dqT/2ldZsF+JsuR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinas Rasheed <srasheed@marvell.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/166] octeon_ep: explicitly test for firmware ready value
Date: Mon, 18 Dec 2023 14:49:59 +0100
Message-ID: <20231218135106.452361420@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shinas Rasheed <srasheed@marvell.com>

[ Upstream commit 284f717622417cb267e344a9174f8e5698d1e3c1 ]

The firmware ready value is 1, and get firmware ready status
function should explicitly test for that value. The firmware
ready value read will be 2 after driver load, and on unbind
till firmware rewrites the firmware ready back to 0, the value
seen by driver will be 2, which should be regarded as not ready.

Fixes: 10c073e40469 ("octeon_ep: defer probe if firmware not ready")
Signed-off-by: Shinas Rasheed <srasheed@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 5b46ca47c8e59..2ee1374db4c06 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -1076,7 +1076,8 @@ static bool get_fw_ready_status(struct pci_dev *pdev)
 
 		pci_read_config_byte(pdev, (pos + 8), &status);
 		dev_info(&pdev->dev, "Firmware ready status = %u\n", status);
-		return status;
+#define FW_STATUS_READY 1ULL
+		return status == FW_STATUS_READY;
 	}
 	return false;
 }
-- 
2.43.0



