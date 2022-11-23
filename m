Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E411C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776DCC433D6;
	Wed, 23 Nov 2022 09:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194691;
	bh=hllqNPHSrZmulauq4JpT9Hh4oc1tC/HsjJ1jKm/n4gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=raBsvxCTlqn/ABQYKTp8iW8tIg1/HUI4waWh2FBodhdg+FQ8eLc7H6F50lwMoQSm4
	 ALX1NHWa8ys5A6DxV6JTHgUM/LSgBjQD76i+xB5D7U1M3MG//jWu0VRxMTTo0FRmRY
	 U7C/Ydj2YL9xSW2/r+kRn9erUGdAhyCU1+bV/FzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 009/156] wifi: cfg80211: fix memory leak in query_regdb_file()
Date: Wed, 23 Nov 2022 09:49:26 +0100
Message-Id: <20221123084558.200911830@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arend van Spriel <arend.vanspriel@broadcom.com>

[ Upstream commit 57b962e627ec0ae53d4d16d7bd1033e27e67677a ]

In the function query_regdb_file() the alpha2 parameter is duplicated
using kmemdup() and subsequently freed in regdb_fw_cb(). However,
request_firmware_nowait() can fail without calling regdb_fw_cb() and
thus leak memory.

Fixes: 007f6c5e6eb4 ("cfg80211: support loading regulatory database as firmware file")
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 74caece77963..4db397db2fb4 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1060,6 +1060,8 @@ static void regdb_fw_cb(const struct firmware *fw, void *context)
 
 static int query_regdb_file(const char *alpha2)
 {
+	int err;
+
 	ASSERT_RTNL();
 
 	if (regdb)
@@ -1069,9 +1071,13 @@ static int query_regdb_file(const char *alpha2)
 	if (!alpha2)
 		return -ENOMEM;
 
-	return request_firmware_nowait(THIS_MODULE, true, "regulatory.db",
-				       &reg_pdev->dev, GFP_KERNEL,
-				       (void *)alpha2, regdb_fw_cb);
+	err = request_firmware_nowait(THIS_MODULE, true, "regulatory.db",
+				      &reg_pdev->dev, GFP_KERNEL,
+				      (void *)alpha2, regdb_fw_cb);
+	if (err)
+		kfree(alpha2);
+
+	return err;
 }
 
 int reg_reload_regdb(void)
-- 
2.35.1



