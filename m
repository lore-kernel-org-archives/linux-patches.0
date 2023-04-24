Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82357C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9D7C433EF;
	Mon, 24 Apr 2023 13:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342457;
	bh=o26pS3ns2YSHR2n7Ff0hLaBloelPV//cROjUcw1OZ6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRmDL4G5D6v8sXEK9I2p8IH+rcqCazY0Q9F6BOpvoMm7yn5coGH7wYRrB1EGsZfXI
	 3v7eSNLqSRNZ5AmN++WGxw/V7H0RjLPd4vwbdeIYpsfQ/BbqIGIEwjCKgPj3bJhY5F
	 BIo7TbyOR+SrLEhKrssfzF6xqcGq1EQq4KYxcuFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 17/73] bnxt_en: Do not initialize PTP on older P3/P4 chips
Date: Mon, 24 Apr 2023 15:16:31 +0200
Message-Id: <20230424131129.650826099@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit e8b51a1a15d5a3cce231e0669f6a161dc5bb9b75 ]

The driver does not support PTP on these older chips and it is assuming
that firmware on these older chips will not return the
PORT_MAC_PTP_QCFG_RESP_FLAGS_HWRM_ACCESS flag in __bnxt_hwrm_ptp_qcfg(),
causing the function to abort quietly.

But newer firmware now sets this flag and so __bnxt_hwrm_ptp_qcfg()
will proceed further.  Eventually it will fail in bnxt_ptp_init() ->
bnxt_map_ptp_regs() because there is no code to support the older chips.
The driver will then complain:

"PTP initialization failed.\n"

Fix it so that we abort quietly earlier without going through the
unnecessary steps and alarming the user with the warning log.

Fixes: ae5c42f0b92c ("bnxt_en: Get PTP hardware capability from firmware")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4ef90e0cb8f8e..38fc2286f7cbd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7437,7 +7437,7 @@ static int __bnxt_hwrm_ptp_qcfg(struct bnxt *bp)
 	u8 flags;
 	int rc;
 
-	if (bp->hwrm_spec_code < 0x10801) {
+	if (bp->hwrm_spec_code < 0x10801 || !BNXT_CHIP_P5_THOR(bp)) {
 		rc = -ENODEV;
 		goto no_ptp;
 	}
-- 
2.39.2



