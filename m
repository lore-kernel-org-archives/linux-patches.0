Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C642749D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED1DC433EF;
	Thu, 12 Jan 2023 14:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532935;
	bh=xIDhPjzrdbsH1EIa8aW6wNiVlsnjOwprJl3w1/448BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyvAdkSlG3hiJQNW583T5Dx4S2ndFJt4wbSrs8nnyN3LZQeQ4tHoIwCN5m/JrP8/v
	 0MmtXRZDUp4O8U8uM4mPjuWBiJrGX+XRn6AsUWjoCO62ZL+UmkUvuhIW/Sc8g/oC8x
	 gArZOzr3JdEpxft4zEQFOlRCPMKVkXjlZ5RIo1/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 318/783] scsi: hpsa: Fix possible memory leak in hpsa_add_sas_device()
Date: Thu, 12 Jan 2023 14:50:34 +0100
Message-Id: <20230112135539.069513584@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit fda34a5d304d0b98cc967e8763b52221b66dc202 ]

If hpsa_sas_port_add_rphy() returns an error, the 'rphy' allocated in
sas_end_device_alloc() needs to be freed. Address this by calling
sas_rphy_free() in the error path.

Fixes: d04e62b9d63a ("hpsa: add in sas transport class")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221111043012.1074466-1-yangyingliang@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hpsa.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 48be84b4e95c..b2d4b6c78b5c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -9801,10 +9801,12 @@ static int hpsa_add_sas_device(struct hpsa_sas_node *hpsa_sas_node,
 
 	rc = hpsa_sas_port_add_rphy(hpsa_sas_port, rphy);
 	if (rc)
-		goto free_sas_port;
+		goto free_sas_rphy;
 
 	return 0;
 
+free_sas_rphy:
+	sas_rphy_free(rphy);
 free_sas_port:
 	hpsa_free_sas_port(hpsa_sas_port);
 	device->sas_port = NULL;
-- 
2.35.1



