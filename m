Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8871C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87AEC433EF;
	Wed, 28 Dec 2022 16:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244537;
	bh=OInMmMcuCUNttjm/EKLUlCe0JUD25NUiDPaUqAQDqcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZ3TSLyhdpjS8Baq2rkZeztH60810j+Hmju5B/XK+gsfgMkGx54QtekoFxkIkwD8n
	 dzXFbwzQ8oLrMOtLiF0USJNW1+FADxIYfdyMSbe+PWd/zFeoMqJeds8DC6H23vZG+/
	 6KG1uHqS++UpEot4pingXzYOuXsKR/PXyWsf1H5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0690/1146] drivers: staging: r8188eu: Fix sleep-in-atomic-context bug in rtw_join_timeout_handler
Date: Wed, 28 Dec 2022 15:37:09 +0100
Message-Id: <20221228144348.882955490@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit ce8cc75c7419ad54cb99437543a54c97c7446db5 ]

The rtw_join_timeout_handler() is a timer handler that
runs in atomic context, but it could call msleep().
As a result, the sleep-in-atomic-context bug will happen.
The process is shown below:

     (atomic context)
rtw_join_timeout_handler
 _rtw_join_timeout_handler
  rtw_do_join
   rtw_select_and_join_from_scanned_queue
    rtw_indicate_disconnect
     rtw_lps_ctrl_wk_cmd
      lps_ctrl_wk_hdl
       LPS_Leave
        LPS_RF_ON_check
         msleep //sleep in atomic context

Fix by removing msleep() and replacing with mdelay().

Fixes: 15865124feed ("staging: r8188eu: introduce new core dir for RTL8188eu driver")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20221018083424.79741-1-duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/r8188eu/core/rtw_pwrctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/r8188eu/core/rtw_pwrctrl.c b/drivers/staging/r8188eu/core/rtw_pwrctrl.c
index 870d81735b8d..5290ac36f08c 100644
--- a/drivers/staging/r8188eu/core/rtw_pwrctrl.c
+++ b/drivers/staging/r8188eu/core/rtw_pwrctrl.c
@@ -273,7 +273,7 @@ static s32 LPS_RF_ON_check(struct adapter *padapter, u32 delay_ms)
 			err = -1;
 			break;
 		}
-		msleep(1);
+		mdelay(1);
 	}
 
 	return err;
-- 
2.35.1



