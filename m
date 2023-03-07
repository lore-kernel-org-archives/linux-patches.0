Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2240DBA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88187C433EF;
	Tue,  7 Mar 2023 18:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212375;
	bh=RrgCGftI/acaQ9WPr/6iB+li70yBZBi46xBicHDRSg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bk2WdyORCfwXCnWYFAe2arQatB2a+Q7IjhOE9coO/eFJJeKHhjmF26OCJxRIbS+4n
	 Pzy8dY2M963F3dgSE/dnfQ9/StDxhhd+xsT0nMB5njRdDqTHeX779ip1HS81lqeZfP
	 LW6z0hiXZymX6kXPTyrmHxSNPfwpfpCdauuCgOyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kodanev <aleksei.kodanev@bell-sw.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 165/885] wifi: orinoco: check return value of hermes_write_wordrec()
Date: Tue,  7 Mar 2023 17:51:39 +0100
Message-Id: <20230307170009.098006568@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexey Kodanev <aleksei.kodanev@bell-sw.com>

[ Upstream commit 1e346cbb096a5351a637ec1992beffbf330547f0 ]

There is currently no return check for writing an authentication
type (HERMES_AUTH_SHARED_KEY or HERMES_AUTH_OPEN). It looks like
it was accidentally skipped.

This patch adds a return check similar to the other checks in
__orinoco_hw_setup_enc() for hermes_write_wordrec().

Detected using the static analysis tool - Svace.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221227133306.201356-1-aleksei.kodanev@bell-sw.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intersil/orinoco/hw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intersil/orinoco/hw.c b/drivers/net/wireless/intersil/orinoco/hw.c
index 0aea35c9c11c7..4fcca08e50de2 100644
--- a/drivers/net/wireless/intersil/orinoco/hw.c
+++ b/drivers/net/wireless/intersil/orinoco/hw.c
@@ -931,6 +931,8 @@ int __orinoco_hw_setup_enc(struct orinoco_private *priv)
 			err = hermes_write_wordrec(hw, USER_BAP,
 					HERMES_RID_CNFAUTHENTICATION_AGERE,
 					auth_flag);
+			if (err)
+				return err;
 		}
 		err = hermes_write_wordrec(hw, USER_BAP,
 					   HERMES_RID_CNFWEPENABLED_AGERE,
-- 
2.39.2



