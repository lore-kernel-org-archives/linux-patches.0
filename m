Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD061FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E59DC433C8;
	Tue,  1 Aug 2023 09:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883157;
	bh=25G1o+MgxzZpy+6LSxKSgcYq4BHCLXVaf2jrvSELyg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NllTOj5FdGNMitKsHv9eBEe+5wMlwfILXGiRSNifhkVz39TNuM4PNgC8apOOy/sLm
	 jzzO3EKBKj5l2gM/h8Np3dRH53/V5+puQcKvZoItAfJPTdzcrQKs8L6HlEuBvoByAm
	 sEpUPVFNAfXpTMoIPtQr42JydyC5eSZSTyMyXl4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 136/239] ublk: return -EINTR if breaking from waiting for existed users in DEL_DEV
Date: Tue,  1 Aug 2023 11:20:00 +0200
Message-ID: <20230801091930.590494545@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 3e9dce80dbf91972aed972c743f539c396a34312 ]

If user interrupts wait_event_interruptible() in ublk_ctrl_del_dev(),
return -EINTR and let user know what happens.

Fixes: 0abe39dec065 ("block: ublk: improve handling device deletion")
Reported-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20230726144502.566785-4-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index bf0711894c0a2..e6b6e5eee4dea 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1909,8 +1909,8 @@ static int ublk_ctrl_del_dev(struct ublk_device **p_ub)
 	 * - the device number is freed already, we will not find this
 	 *   device via ublk_get_device_from_id()
 	 */
-	wait_event_interruptible(ublk_idr_wq, ublk_idr_freed(idx));
-
+	if (wait_event_interruptible(ublk_idr_wq, ublk_idr_freed(idx)))
+		return -EINTR;
 	return 0;
 }
 
-- 
2.40.1



