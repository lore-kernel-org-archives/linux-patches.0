Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751108486
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE73AC433D6;
	Thu, 27 Oct 2022 17:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890043;
	bh=+t6PB4iPKOl6/xuYBMkeIJleQmFqj8jqrs6dvRL7JuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AppLD0f0mmYzzIMa72nLd8KtFG83EfO5dnh61HSfqLGntoey4e3ygeFcay2wo/dd6
	 h0ZjWRvHwrrw1LA5Z7kjHFb5d9ydbhPte2yNaz88esWyqkEa7FrZQbY0hiZXSoa3eJ
	 aIF7EhGwTZqrXUoLVRS2eRyR8a1gYvDpEZo2vAf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 65/94] bnxt_en: fix memory leak in bnxt_nvm_test()
Date: Thu, 27 Oct 2022 18:55:07 +0200
Message-Id: <20221027165059.793016468@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vikas Gupta <vikas.gupta@broadcom.com>

[ Upstream commit ba077d683d45190afc993c1ce45bcdbfda741a40 ]

Free the kzalloc'ed buffer before returning in the success path.

Fixes: 5b6ff128fdf6 ("bnxt_en: implement callbacks for devlink selftests")
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/1666020742-25834-1-git-send-email-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index a36803e79e92..8a6f788f6294 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -613,6 +613,7 @@ static int bnxt_dl_reload_up(struct devlink *dl, enum devlink_reload_action acti
 
 static bool bnxt_nvm_test(struct bnxt *bp, struct netlink_ext_ack *extack)
 {
+	bool rc = false;
 	u32 datalen;
 	u16 index;
 	u8 *buf;
@@ -632,20 +633,20 @@ static bool bnxt_nvm_test(struct bnxt *bp, struct netlink_ext_ack *extack)
 
 	if (bnxt_get_nvram_item(bp->dev, index, 0, datalen, buf)) {
 		NL_SET_ERR_MSG_MOD(extack, "nvm test vpd read error");
-		goto err;
+		goto done;
 	}
 
 	if (bnxt_flash_nvram(bp->dev, BNX_DIR_TYPE_VPD, BNX_DIR_ORDINAL_FIRST,
 			     BNX_DIR_EXT_NONE, 0, 0, buf, datalen)) {
 		NL_SET_ERR_MSG_MOD(extack, "nvm test vpd write error");
-		goto err;
+		goto done;
 	}
 
-	return true;
+	rc = true;
 
-err:
+done:
 	kfree(buf);
-	return false;
+	return rc;
 }
 
 static bool bnxt_dl_selftest_check(struct devlink *dl, unsigned int id,
-- 
2.35.1



