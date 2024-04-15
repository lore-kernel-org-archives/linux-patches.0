Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EBF381B9;
	Mon, 15 Apr 2024 14:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191788; cv=none; b=NTqCpM78BXnQhmoNTtGg4fOHDLwso5ZbQzGsW+p8svXfPXpwABdaPdIawtgpMD9jSH6QN9Xr+Z8o5B5SC/IDAyXxKMAMfSv70YhW5VybW6dnS6u+gZsVbH/my9zJwL67gR+dw3HgsAlnvOse/82GJ7wPWeLjucnxNYSQbOT2zNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191788; c=relaxed/simple;
	bh=hntgf/5BO5Y0uzXqUb8aDXota+EdHLHCJnwna20P2+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbsCmTgsD7V8plDxqzRD3swm/arbWaqBZAOZIxuGf9nyFBgpi0ONHdMkeI0szTx9ek7yFN52hdakkzAGYhiMf66Y0JRH7MX2dH4MGReRYOLGJe7PoaBnXtvr5ZXNbInKVyL563H56chzgpLpRUkF3/DPR67hLLmbk7Yz6t5CY74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNLKHKbd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNLKHKbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB98C2BD11;
	Mon, 15 Apr 2024 14:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191788;
	bh=hntgf/5BO5Y0uzXqUb8aDXota+EdHLHCJnwna20P2+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNLKHKbdRRTW7E1RWwm3mCySXFDui3TiQN2POgd8AEEvFw3V/bC+NYaDbOrSqJPyK
	 o55mTAvJjblqUF3bASC/XAfKrMfdj0Ass8BhON6PCnlPc2ChaBttqoqyz39OIkeBUs
	 lHasj0wfRKbBMmE3fSUWbOBIsVzifLZGSZrZdRsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/122] Bluetooth: ISO: Align broadcast sync_timeout with connection timeout
Date: Mon, 15 Apr 2024 16:20:13 +0200
Message-ID: <20240415141954.816068653@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 42ed95de82c01184a88945d3ca274be6a7ea607d ]

This aligns broadcast sync_timeout with existing connection timeouts
which are 20 seconds long.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: b37cab587aa3 ("Bluetooth: ISO: Don't reject BT_ISO_QOS if parameters are unset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/bluetooth.h | 2 ++
 net/bluetooth/iso.c               | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index aa90adc3b2a4d..28e32c9a6cc99 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -164,6 +164,8 @@ struct bt_voice {
 #define BT_ISO_QOS_BIG_UNSET	0xff
 #define BT_ISO_QOS_BIS_UNSET	0xff
 
+#define BT_ISO_SYNC_TIMEOUT	0x07d0 /* 20 secs */
+
 struct bt_iso_io_qos {
 	__u32 interval;
 	__u16 latency;
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 0eeec64801390..698d0b67c7ed4 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -764,10 +764,10 @@ static struct bt_iso_qos default_qos = {
 		.bcode			= {0x00},
 		.options		= 0x00,
 		.skip			= 0x0000,
-		.sync_timeout		= 0x4000,
+		.sync_timeout		= BT_ISO_SYNC_TIMEOUT,
 		.sync_cte_type		= 0x00,
 		.mse			= 0x00,
-		.timeout		= 0x4000,
+		.timeout		= BT_ISO_SYNC_TIMEOUT,
 	},
 };
 
-- 
2.43.0



