Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE561863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F12C433D2;
	Wed, 28 Dec 2022 15:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242533;
	bh=FfHiwTLWTof5h66dcW6N0dBhUCrzjpbyPytb4kAa7U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0kvPBhvXkksuVqdyqgrPwfCniyQ6kO7jthzCx9278LK6c1MvCIUeYrQEVWttiPDw
	 +8zIGTnugPEibEbQsxdOQHish0AIk4nrqI2NXu5Wyf++uVtV/GVpTR5/C93wipLBYz
	 wrQBiZ9t/8m0Q1YpNgzNZaZbT2RVZpcE0wSgdM1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 614/731] HID: amd_sfh: Add missing check for dma_alloc_coherent
Date: Wed, 28 Dec 2022 15:42:01 +0100
Message-Id: <20221228144314.332058916@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 53ffa6a9f83b2170c60591da1ead8791d5a42e81 ]

Add check for the return value of the dma_alloc_coherent since
it may return NULL pointer if allocation fails.

Fixes: 4b2c53d93a4b ("SFH:Transport Driver to add support of AMD Sensor Fusion Hub (SFH)")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20221220024921.21992-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_client.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_client.c b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
index ab149b80f86c..911a23a9bcd1 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_client.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
@@ -166,6 +166,10 @@ int amd_sfh_hid_client_init(struct amd_mp2_dev *privdata)
 		in_data->sensor_virt_addr[i] = dma_alloc_coherent(dev, sizeof(int) * 8,
 								  &cl_data->sensor_dma_addr[i],
 								  GFP_KERNEL);
+		if (!in_data->sensor_virt_addr[i]) {
+			rc = -ENOMEM;
+			goto cleanup;
+		}
 		cl_data->sensor_sts[i] = SENSOR_DISABLED;
 		cl_data->sensor_requested_cnt[i] = 0;
 		cl_data->cur_hid_dev = i;
-- 
2.35.1



