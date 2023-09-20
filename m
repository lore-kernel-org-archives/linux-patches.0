Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4D111732
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3951AC433CC;
	Wed, 20 Sep 2023 12:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213586;
	bh=SDfb68nTbYdHm/8k3Q6Es1cQuhqPJ+fG4dkVA6K2CFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o3XPbVg4qFM0zyeb4BCmEkUISqhth5LN95Lr7dMbOCbiC5rnDn6eJMuoFCf6BJTGT
	 J8kcY1tCW4BBti3ozNBuiRGYPdDHlicbHeRnXKa5ucBGzk/lmV4t3koGxD3c74D78W
	 iRvHTU1OzDZOYZYXIaghi8D+prhbwCK4/9rztIA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RD Babiera <rdbabiera@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 291/367] usb: typec: bus: verify partner exists in typec_altmode_attention
Date: Wed, 20 Sep 2023 13:31:08 +0200
Message-ID: <20230920112906.089534305@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: RD Babiera <rdbabiera@google.com>

[ Upstream commit f23643306430f86e2f413ee2b986e0773e79da31 ]

Some usb hubs will negotiate DisplayPort Alt mode with the device
but will then negotiate a data role swap after entering the alt
mode. The data role swap causes the device to unregister all alt
modes, however the usb hub will still send Attention messages
even after failing to reregister the Alt Mode. type_altmode_attention
currently does not verify whether or not a device's altmode partner
exists, which results in a NULL pointer error when dereferencing
the typec_altmode and typec_altmode_ops belonging to the altmode
partner.

Verify the presence of a device's altmode partner before sending
the Attention message to the Alt Mode driver.

Fixes: 8a37d87d72f0 ("usb: typec: Bus type for alternate modes")
Cc: stable@vger.kernel.org
Signed-off-by: RD Babiera <rdbabiera@google.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20230814180559.923475-1-rdbabiera@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/bus.c           | 12 ++++++++++--
 drivers/usb/typec/tcpm/tcpm.c     |  3 ++-
 include/linux/usb/typec_altmode.h |  2 +-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/typec/bus.c b/drivers/usb/typec/bus.c
index 0369ad92a1c8e..052b8fb21344c 100644
--- a/drivers/usb/typec/bus.c
+++ b/drivers/usb/typec/bus.c
@@ -146,12 +146,20 @@ EXPORT_SYMBOL_GPL(typec_altmode_exit);
  *
  * Notifies the partner of @adev about Attention command.
  */
-void typec_altmode_attention(struct typec_altmode *adev, u32 vdo)
+int typec_altmode_attention(struct typec_altmode *adev, u32 vdo)
 {
-	struct typec_altmode *pdev = &to_altmode(adev)->partner->adev;
+	struct altmode *partner = to_altmode(adev)->partner;
+	struct typec_altmode *pdev;
+
+	if (!partner)
+		return -ENODEV;
+
+	pdev = &partner->adev;
 
 	if (pdev->ops && pdev->ops->attention)
 		pdev->ops->attention(pdev, vdo);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(typec_altmode_attention);
 
diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 9e71e0d9a09cd..07db1f1a1f72a 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1270,7 +1270,8 @@ static void tcpm_handle_vdm_request(struct tcpm_port *port,
 			}
 			break;
 		case ADEV_ATTENTION:
-			typec_altmode_attention(adev, p[1]);
+			if (typec_altmode_attention(adev, p[1]))
+				tcpm_log(port, "typec_altmode_attention no port partner altmode");
 			break;
 		}
 	}
diff --git a/include/linux/usb/typec_altmode.h b/include/linux/usb/typec_altmode.h
index 9a88c74a1d0d0..969b7c5040875 100644
--- a/include/linux/usb/typec_altmode.h
+++ b/include/linux/usb/typec_altmode.h
@@ -67,7 +67,7 @@ struct typec_altmode_ops {
 
 int typec_altmode_enter(struct typec_altmode *altmode);
 int typec_altmode_exit(struct typec_altmode *altmode);
-void typec_altmode_attention(struct typec_altmode *altmode, u32 vdo);
+int typec_altmode_attention(struct typec_altmode *altmode, u32 vdo);
 int typec_altmode_vdm(struct typec_altmode *altmode,
 		      const u32 header, const u32 *vdo, int count);
 int typec_altmode_notify(struct typec_altmode *altmode, unsigned long conf,
-- 
2.40.1



