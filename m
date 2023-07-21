Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6746C200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCF2C433C7;
	Fri, 21 Jul 2023 19:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966106;
	bh=TdnathEHzYuJ/mB+GnMI6yOuURVNBpL3DhWx3eStutY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gN75yJnIoCgusm8LilvBErZyjBuKX76S2E7Vf40ywzsj+isBzGBWckUQMVZEwboW0
	 9+bVJUOQRsnCbywPEjSncby0QRQy/OUYW3Dlj6fM3cYoQRC5+1rGeWhx2xYFKKwubU
	 8ApdWlWIQ4gIfmR0/td/cSz1wC9fDanZYOYh1eRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuchen Yang <u202114568@hust.edu.cn>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 198/532] scsi: 3w-xxxx: Add error handling for initialization failure in tw_probe()
Date: Fri, 21 Jul 2023 18:01:42 +0200
Message-ID: <20230721160625.150077805@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuchen Yang <u202114568@hust.edu.cn>

[ Upstream commit 2e2fe5ac695a00ab03cab4db1f4d6be07168ed9d ]

Smatch complains that:

tw_probe() warn: missing error code 'retval'

This patch adds error checking to tw_probe() to handle initialization
failure. If tw_reset_sequence() function returns a non-zero value, the
function will return -EINVAL to indicate initialization failure.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yuchen Yang <u202114568@hust.edu.cn>
Link: https://lore.kernel.org/r/20230505141259.7730-1-u202114568@hust.edu.cn
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/3w-xxxx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 4ee485ab27148..678c8ca4f699c 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2305,8 +2305,10 @@ static int tw_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	TW_DISABLE_INTERRUPTS(tw_dev);
 
 	/* Initialize the card */
-	if (tw_reset_sequence(tw_dev))
+	if (tw_reset_sequence(tw_dev)) {
+		retval = -EINVAL;
 		goto out_release_mem_region;
+	}
 
 	/* Set host specific parameters */
 	host->max_id = TW_MAX_UNITS;
-- 
2.39.2



