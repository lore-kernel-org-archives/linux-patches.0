Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A3D377A89;
	Thu, 20 Aug 2026 15:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239326; cv=none; b=D6hT+zt+pDWrEWrfr5rm70svGCJqfczCtujauEpgwfA9mb5mP8UTTziq4CCRyC/sA2iMvhml4RABCzlJAry9MSCQghZR9qZMzq7O/luHjCyDRiwXnhvSRBjqlah7vZ174dx1JaBk1Rb0i2h3AL/aYj2RJnBtyzQvasFBSW+Hy0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239326; c=relaxed/simple;
	bh=nz48mxCLJBIqQHPdbfnCUaUYkkVLdAqODBR4HbFmwEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6EtkmlJeqvQFIyYi5QBmT05DHFI1LyW8DpyP/4lEKgG+EefCT/DGbS818xXrs7x6bVMVSo8QlQchbeeWx3eCEZfoNXS2Ql4e9JMWFrSoHC4XTMpQrkPcJRyEtPlikO8mewiy44uzI7Qsqk9gg/qBL8/m1kg4ngW2kXTSdHkNn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yU/+y5O1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yU/+y5O1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F194A1F000E9;
	Thu, 20 Aug 2026 15:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239325;
	bh=VrHjS+ehztAtUme/VeocXMfGUJecszZ8sSO6FFT/I7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yU/+y5O1U83z5EapS19m7kEjQnJx2ZffIJ3/xf8mfujROnFlzCcjZdmaCp4LM5CMU
	 WCTpEQi7MlDobk1qlyfl1gXNy2u5Ix/YUa/OZ8GkFeFb7Coz28zw6qcy5TBGXFQavK
	 TF1vEiUjXnMbDicLHA9mDqqZpvWbWMPv4HGJMrSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp David <pd-lkml@3b.pm>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Dima Ruinskiy <dima.ruinskiy@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/220] igc: fix netdev not re-attached after resume if interface is down
Date: Thu, 20 Aug 2026 16:53:21 +0200
Message-ID: <20260820145223.831267044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp David <pd-lkml@3b.pm>

[ Upstream commit b0ce5fd9fabe7c79463cf4602217d4dfeff5b1fd ]

__igc_resume() calls netif_device_attach() only inside the
netif_running() branch, so an interface that was down during suspend
is never re-attached on resume. It then stays in the not-present state
that __igc_shutdown() set via netif_device_detach(): ethtool reports
ENODEV and every attempt to bring the interface up fails the
netif_device_present() check in __dev_open() with -ENODEV, silently,
since __igc_resume() returns 0. Only reloading the driver recovers the
device.

This is easy to hit in practice because NetworkManager brings managed
interfaces down before sleep unless Wake-on-LAN is configured, making
the adapter unusable after every suspend/resume cycle with WoL
disabled.

Re-attach the netdev on every successful resume, as igb and e1000e do.

Fixes: 6f31d6b643a3 ("igc: Refactor runtime power management flow")
Cc: stable@vger.kernel.org
Signed-off-by: Philipp David <pd-lkml@3b.pm>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260804222205.1580328-11-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 6fcf4fd7ee19..ecc33f797e37 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -7405,11 +7405,13 @@ static int igc_resume(struct device *dev)
 
 	if (netif_running(netdev)) {
 		err = __igc_open(netdev, true);
-		if (!err)
-			netif_device_attach(netdev);
+		if (err)
+			return err;
 	}
 
-	return err;
+	netif_device_attach(netdev);
+
+	return 0;
 }
 
 static int igc_runtime_resume(struct device *dev)
-- 
2.53.0



