Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7922C171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15FEC433EF;
	Mon, 22 May 2023 19:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784495;
	bh=bkD6hVU+8F90R1FdgY0SO//u+++2L4MdapcaIwB2BL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bBkcqYOjQbVJ5xP++tfxxQwfCrxR13SKr+0x4UKH6cdGR9ld6Arpu1As1Z3HZ41ko
	 ZXBi6hodYcx2f6EtMQcIyedBQkTVHUGWV+E2HtgBn3KtXhPo4mYwlXZ0tfwYcZIEwU
	 g7SBFX6JbQvTiA/TAb9vu6FrIjcMesUnNponZ8Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajat Soni <quic_rajson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 101/364] wifi: ath12k: fix memory leak in ath12k_qmi_driver_event_work()
Date: Mon, 22 May 2023 20:06:46 +0100
Message-Id: <20230522190415.278511134@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rajat Soni <quic_rajson@quicinc.com>

[ Upstream commit 960412bee0ea75f6b3c2dca4a3535795ee84c47a ]

Currently the buffer pointed by event is not freed in case
ATH12K_FLAG_UNREGISTERING bit is set, this causes memory leak.

Add a goto skip instead of return, to ensure event and all the
list entries are freed properly.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1

Signed-off-by: Rajat Soni <quic_rajson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230315090632.15065-1-quic_rajson@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/qmi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index 979a63f2e2ab8..03ba245fbee92 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -2991,7 +2991,7 @@ static void ath12k_qmi_driver_event_work(struct work_struct *work)
 		spin_unlock(&qmi->event_lock);
 
 		if (test_bit(ATH12K_FLAG_UNREGISTERING, &ab->dev_flags))
-			return;
+			goto skip;
 
 		switch (event->type) {
 		case ATH12K_QMI_EVENT_SERVER_ARRIVE:
@@ -3032,6 +3032,8 @@ static void ath12k_qmi_driver_event_work(struct work_struct *work)
 			ath12k_warn(ab, "invalid event type: %d", event->type);
 			break;
 		}
+
+skip:
 		kfree(event);
 		spin_lock(&qmi->event_lock);
 	}
-- 
2.39.2



