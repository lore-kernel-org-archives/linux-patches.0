Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A0815B972;
	Mon, 29 Jan 2024 17:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548300; cv=none; b=gDnPwdBJLbcNRlNj2M/x8lv89fjpatZcJSV62hHroxOHbpMkokjfNKf8jStfySZV9KadyzOxrgL7jcJaCFdbnmG2Wvqd5c1COugE320qZ0b8GDu71sMOzIra162fBRUhl/aixlufyyLAgxnxOiu/7DQ6r0OijNRdnsAaXomdB5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548300; c=relaxed/simple;
	bh=6AFnBTd4+ZE0EiydpQHYiEq1QzwTinJhforlaBahY6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gc0dclgoYk0zBHCCRNoVhMGf++YUu92vOlNuG+w8kShu+3VYzWlM2Oigcu0qUFCEguboQzrTgsvUzVEU60+gCZzNe5OMdQiRy6an5IAg2GmKpfqpkI2PZR5Uo9CzKLDbqEGY5AAUaCHmTakahm6PAEHdgZg4/gmJRSVlJZD05EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NPv06/GA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPv06/GA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB3AC433F1;
	Mon, 29 Jan 2024 17:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548300;
	bh=6AFnBTd4+ZE0EiydpQHYiEq1QzwTinJhforlaBahY6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NPv06/GAxCx/epfuMYQkocIDsZAIWlYCg+82pzbzyf5E0a03o1U6/B9d5WlxK1vtg
	 iAuC2BnAvwq3VHjwW6eTAts7gzELZFf+ds95GPb8H/AseeoJyIOz+r9+Cot1kfoD0h
	 31Z9djZE0EJcN/ZM3oXGPnojV7/h7jMmrjxhL9Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/185] bnxt_en: Wait for FLR to complete during probe
Date: Mon, 29 Jan 2024 09:04:39 -0800
Message-ID: <20240129170001.140299094@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 3c1069fa42872f95cf3c6fedf80723d391e12d57 ]

The first message to firmware may fail if the device is undergoing FLR.
The driver has some recovery logic for this failure scenario but we must
wait 100 msec for FLR to complete before proceeding.  Otherwise the
recovery will always fail.

Fixes: ba02629ff6cb ("bnxt_en: log firmware status on firmware init failure")
Reviewed-by: Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/20240117234515.226944-2-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index df4d88d35701..f810b5dc25f0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12269,6 +12269,11 @@ static int bnxt_fw_init_one_p1(struct bnxt *bp)
 
 	bp->fw_cap = 0;
 	rc = bnxt_hwrm_ver_get(bp);
+	/* FW may be unresponsive after FLR. FLR must complete within 100 msec
+	 * so wait before continuing with recovery.
+	 */
+	if (rc)
+		msleep(100);
 	bnxt_try_map_fw_health_reg(bp);
 	if (rc) {
 		rc = bnxt_try_recover_fw(bp);
-- 
2.43.0



