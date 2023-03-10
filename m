Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B862846C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA06C433EF;
	Fri, 10 Mar 2023 14:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458618;
	bh=t/PQe2PqVeQA/uidFz14Vi5or1yoZVTOCxK4FbeLzxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMuXuutyaoNTeS48Ab/zCbhqnxCd+ByIuEOnUeijeUVhfhY0xqTRm7kKIPsIBPGGg
	 5PMfv3IV3qxAStN6OfMqpGzBX/rQYCiIrXqDmR06Dhhd/U3X6hPfxx5NTZD0x+C9fw
	 oTkf1AOn/oGv8DROuS/9nLHY0c5SeVdnsMkLC8YM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kodanev <aleksei.kodanev@bell-sw.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/357] wifi: orinoco: check return value of hermes_write_wordrec()
Date: Fri, 10 Mar 2023 14:35:45 +0100
Message-Id: <20230310133736.436535423@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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
index 61af5a28f269f..af49aa421e47f 100644
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



