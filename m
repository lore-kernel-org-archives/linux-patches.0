Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049882;
	b=mzQcgv9hPvFw/U6eCOVie7tK8Awms+UOOCDiYSd+25/c5KMm5xSKEKps65f5HMMWGJYa
	 Zw9L29zndSNi6qFABzzDYO7ibDnkwpOTLzeEXeaLR/5kkSKnIrY57WEd4hcy6QjqmpW75
	 ZLnTlLgY6H1CpFcpWkBEkfKxfeC/6Wuy6f/WYYfYRGInwVCu6U8csK9vBf30kDLZTS0FO
	 h16x24pKnnVFdAGWbz15qWIIMk5FRrB7TDrRMf+kP2rtPJYVZTiCD2TJwJf2sIOkX1/7B
	 V7He/Ty7UXzaLhGc9zj3fjxbuoivxRKe0Si01W2LNzyt7uhoSfpA/mHAmwG9ek4PQBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PXUtoRfYN8UwRpeqzZw8bb+1Y2IHmKMwC62s2pwVPnM=;
	b=BTQ8COXGTDTxec+CQgsSrjsAu8O1ic1KQPyX7OeZdNY4l3nLxfwVSpFRNyWcDkn4vx8o
	 /PFKXGxrIlTIDC2puVWe2DhY0YfBNzRw/4AsuzipFH+1/BCM6/fWmL77o7HfjM3LY8duc
	 12GGuU7zQA6DUtM15bQxbMwUmz5E9HlEBmtqn2mMWs2oK2U4YHIcKtojZB+cfp3oVYFv0
	 O6BpTeZMBpq82vMesv6Tk3VTU26IBbJH+MMuDXkldOyG549C5ppu/0EyM41mxvIoTkIlz
	 lrgSzbD5fGKEdahkVcywyV+M2Qgs0RJp91MDtOfbCUhPyGhGS/CdU4z5U+2QAmIwY1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yUlYxyQ1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE43B606A31C;
	Thu, 19 Nov 2026 00:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yUlYxyQ1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190C31F000C4;
	Thu, 19 Nov 2026 00:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049882;
	bh=PXUtoRfYN8UwRpeqzZw8bb+1Y2IHmKMwC62s2pwVPnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yUlYxyQ1aW+id5wTPij7BvllQRwBxMptLj0g4OfY8+XDMUKQZ1goFfHjTbda8j4Tp
	 hYeaH61Rgpf7aGVCUvtUumQNPckzpa70eVnHR5bVQFQDYeBIVC9uk0aiDUJRSRLXqI
	 xQ4qPscfadvpWENJpRdQXOKzyJOOD5J3PakysFlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2493/2857] Bluetooth: MGMT: Fix leaking instance on Add Extended Advertising Parameters
Date: Wed, 18 Nov 2026 15:58:47 +0100
Message-ID: <20261118150331.326537048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 93728a13ce448..1e05c1bbdbd3c 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9085,14 +9085,15 @@ static int add_ext_adv_params(struct sock *sk, struct hci_dev *hdev,
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
@@ -9103,6 +9104,18 @@ static int add_ext_adv_params(struct sock *sk, struct hci_dev *hdev,
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



