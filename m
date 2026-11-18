Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041632;
	b=Gq35hzTZWEIS2hNPHn9KZiTg4wwDOVTacrl6mfR6YTti/WV1FWIaSrNRxIDFpbhgbvF0
	 d9lZHXd49l2n6QvEmgBHBZxQ/TdC3LXlIOmyRgWg80AWSivhinYjylIL2llMfD40QUfJH
	 j7K5dkIBhijXnw+ccPoJ2fVo5AY4B72drNUBA8xOUYa97+dyltmca/8FmuqWGClroIwg/
	 lOUIRed6NWSSqVbqOqpshkF3atmQXbbtYqeluy3OK9p1Fxj95NeygHoH6ILH2yo4Oo2f5
	 OOMxZsRnSKJiC9T9Umk1JK7lon+0UAmlCez7pDF2B9+gUIivSM3XFotToPbKuKy1zQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pr2treTvVpAxrtVrFpwteg0CXog0V9DvTDiOWr11V/Q=;
	b=tCPIdTV7uJ5J00zMDsqfxJhZjLhzHePwFTZO785x3eM3bBWnL2iN+zReq/hRGhlfNtsz
	 GKTAPg/P/iWcoKcEFn3LeALGA8oRk/xcOQaVMo0ExQ1ISce1EFfc4zPBiW7/w1aoUhLy8
	 uF+l4fRHUuKOLfX1BE3ccDVgG6+y1zR5EOa3hUWuSRAtJdY2xtl+tYloiFJbfjjeEP1ou
	 ChQVWS3NQRFk1Q37Jnfax417BWcLjW34Gz248ocmicmu1lGLuSIt2Lvd5w+nCV88HCaUL
	 39j3k85GM2TbwqTZUS17/jsPzaDl49k5aldtfBS3LUtf4Z5RzETrQFh62j7DaswVzzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H2r0f1At;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4D7606A330;
	Wed, 18 Nov 2026 22:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H2r0f1At
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD231F000C4;
	Wed, 18 Nov 2026 22:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041632;
	bh=pr2treTvVpAxrtVrFpwteg0CXog0V9DvTDiOWr11V/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H2r0f1AtmYwmFlvOvcqeqjXuUYNxskTBck+sqndzeM0ieVnyt0VGTpVL9NAylbfkn
	 TgkPHzSr6zTgoplio7y68wH6+HUZK9AdfXutdJctGa+Dz5CDzQ4UeD93petmoBgBDC
	 k6DXIFYzOAxDzapyBIKReS522JJAzqJEKnS1vNAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2882/3318] Bluetooth: MGMT: Fix leaking instance on Add Extended Advertising Parameters
Date: Wed, 18 Nov 2026 15:58:24 +0100
Message-ID: <20261118150446.990878947@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit f7f0d0a9eb6e4616c0b3a2a95498b5204c5543c9 ]

If queueing the command fails the instance is never removed, despite it
having already been added or modified by hci_add_adv_instance, so remove
it as it is done by add_ext_adv_params_complete on failure, signaling
it has been removed if it was previously added.

Fixes: cba6b758711c ("Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 2")
Assisted-by: OpenCode:claude-opus-5.5
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index ff5e6d25d753d..23dd8a68c372f 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9174,14 +9174,15 @@ static int add_ext_adv_params(struct sock *sk, struct hci_dev *hdev,
 				       data, data_len);
 		if (!cmd) {
 			err = -ENOMEM;
-			hci_remove_adv_instance(hdev, cp->instance);
-			goto unlock;
+			goto remove;
 		}
 
 		err = hci_cmd_sync_queue(hdev, add_ext_adv_params_sync, cmd,
 					 add_ext_adv_params_complete);
-		if (err < 0)
+		if (err < 0) {
 			mgmt_pending_free(cmd);
+			goto remove;
+		}
 	} else {
 		rp.instance = cp->instance;
 		rp.tx_power = HCI_ADV_TX_POWER_NO_PREFERENCE;
@@ -9192,6 +9193,18 @@ static int add_ext_adv_params(struct sock *sk, struct hci_dev *hdev,
 					MGMT_STATUS_SUCCESS, &rp, sizeof(rp));
 	}
 
+	goto unlock;
+
+remove:
+	/* The instance may have been modified already so remove it, like it
+	 * is done in add_ext_adv_params_complete, signaling it has been
+	 * removed if it was previously added.
+	 */
+	if (!adv->pending)
+		mgmt_advertising_removed(sk, hdev, cp->instance);
+
+	hci_remove_adv_instance(hdev, cp->instance);
+
 unlock:
 	hci_dev_unlock(hdev);
 
-- 
2.53.0



