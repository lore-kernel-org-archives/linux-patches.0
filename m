Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031922;
	b=lqGoKDge5qgY66iSfCIrUNBLvPg2vRKTtB06VQ7vC3QypiwDa5SJiFjORDn3rgmlMqwF
	 o/R0SXrh9LnyVssdxjVSGJi4uezQvVO6DRrkug2qhtDXXVUCVs82ikmOETDtDmhL4wZ5+
	 OQDJkX/Cr5A8OWv6X70OxHsCWwX6ruNKSEwq44AhXzDqwGwdWcDpGVcdh76YHIZk2vISx
	 B6ryxojyIpXaB/UHHXLRaNVL64a7LDHuRmkEBxJ7u49tHDLkbPB6cwEGTXkx+SYYmqN/n
	 cU7fcHcGhCpZIsH3ce3bi0Ow3DkpYZZTwF26SrvxuleTYcYCIewkbe++uO8QpKHOwgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1caiFnUc9ZYjHRqH3XrjCK3afMdpisG5j2r9KMquOi4=;
	b=uogn5cbr6xmSq3rqKLvCRmsBYK0/oUvCzW6M6S47mUmCuWsjL/sOLsP1QIAG/Q1eYp+L
	 farWj6GGA6eOqYBHttc9ajTAGe2x+tnQPlZXp8S7UPjWlX0OS6P7iZfapxBbPUxf9OSiY
	 f5nrAO0Ojgrik1sidlO+ZO6n3YYdKsc6pvoDvv6s40LCNDNy++n05zlDYL3VlwGcgvmmC
	 Ik/e1xEVZzpTZY0nhx/gtjC6xdkrimSHbBnYiXggvXlA/Uo3wWBcT6fiUso3CUx4avZyI
	 M55noyXx7csH9oQ+QnDSfmxHKeh6tDFbHGe0vUhU9HPv+ooYlvxFxt+wtnW4GQ7Hh3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XZAN3xmj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC03606A320;
	Wed, 18 Nov 2026 19:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XZAN3xmj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03AA1F000C4;
	Wed, 18 Nov 2026 19:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031922;
	bh=1caiFnUc9ZYjHRqH3XrjCK3afMdpisG5j2r9KMquOi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XZAN3xmj9fnIcQje4E6CTQicwQeRhrb6t8n4kpQtwDvVx3UXg8FSn4Edxjhtv0swZ
	 hXi/MEGSrHYUqIDLs3nsi6IvysgA5zCZlUa3hAeD3dAZfUcK/XOgiiYWk3QB47Bw8b
	 0Eqy962QWlasZeg0LiOJZ7ETCtwwftA6S4lhwYrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1228/1756] Bluetooth: MGMT: Fix leaking instance on Add Extended Advertising Parameters
Date: Wed, 18 Nov 2026 15:55:55 +0100
Message-ID: <20261118150058.693843217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b2c06ca7c0e37..56166dd47a01e 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9305,14 +9305,15 @@ static int add_ext_adv_params(struct sock *sk, struct hci_dev *hdev,
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
@@ -9323,6 +9324,18 @@ static int add_ext_adv_params(struct sock *sk, struct hci_dev *hdev,
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



