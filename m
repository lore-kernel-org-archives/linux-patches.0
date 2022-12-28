Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366301C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA47AC433D2;
	Wed, 28 Dec 2022 16:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244192;
	bh=XfUw6PyYJpxjAdrmcyQVFb7XdAjV8j8X6jiNVwyqxL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tp7yVFAu+VqeXBmZYKJV3er32s21pF3xLOM9Helq5kAwO5KDBCTQwC6BRikd7GXwv
	 7pBJP3MPppRI8AIITi2Z2sV+vcjeKa9u31HK8CT8Z1UUaDyW1yJJ61Pz4fMVL6N4ju
	 7hJyFZjFhRNsbxTqrHsxmtR8o4UGFaPsZOdsH1dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0666/1073] drivers: staging: r8188eu: Fix sleep-in-atomic-context bug in rtw_join_timeout_handler
Date: Wed, 28 Dec 2022 15:37:34 +0100
Message-Id: <20221228144346.132671599@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 10550bd2c16d..abfd14bfd5fb 100644
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



