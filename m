Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813F1334692;
	Tue, 13 Oct 2026 12:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895274; cv=none; b=EDWy4zKTyaTmVnVGT1b0XrX71Bs+dtlIAZSFeWgEiLbPNIDYy0qP6+7VAMpKZlKdHYS5VIAzFk+VvJNtZjO7zv1RYmEPTEa/Bwr8VehE/GCM4g+E/IYfFEwwgbAn2FD1UOs7XA8QZqAh12GMu7u95PIZFAzy1hfGVWAxnaGugPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895274; c=relaxed/simple;
	bh=b3eEm23jG2vIjZSP+HvY+waDKMzfR7lEb6zfrQtZ2zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FtvTneJzwRXqGbgcAmtzgCzBskBShZiGZmBdWxDagYRF1aYnDZWmAqVCYkWet6RwSPHwdfO3I4TJnim8i3y65nSzcqdt2QXp1U6hpwG2Po/FP3+sQ2AsCG9hlImSOSt9S+yvROILks7CkVqD5ZD+zCYeuCvpixOX+zScXmPbuOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9OB7cZk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9OB7cZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1831F000FF;
	Tue, 13 Oct 2026 12:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895273;
	bh=JmDKM1nScDdOeRV5qLU1VzSOuu7LQzYSXZmiUXnWeQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G9OB7cZktQGasoILZHzp1DOCr4Gmiu2cll/j1t4hhIWcCSeZ0348l5R4SRs+VAWfZ
	 7tDKVFV/g615uSatjvFlZO1t68Ts+TH9cNemfU0/wf4r2x89lLqRx94sG4KA9YKVss
	 LPvSBEUQCTnEZwL9q9qsigPhzD1KeMbptacRKCXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 182/497] Bluetooth: hci_conn: Lock parent access during enhanced SCO setup
Date: Tue, 13 Oct 2026 13:35:49 +0200
Message-ID: <20261013112912.209280295@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit 024e05f73a4c1263d031614bc36700ec135eecb4 upstream.

Bluetooth: hci_conn: Lock parent access during enhanced SCO setup

hci_enhanced_setup_sync() runs on the request workqueue without the
hci_dev_lock held by its caller when setup was queued. Its CVSD
capability check and find_next_esco_param() dereference conn->parent
while the receive workqueue can unlink and release that parent.

The following interleaving can cause a use-after-free:

  hci_enhanced_setup_sync()       hci_disconn_complete_evt()
  load conn->parent
                                 hci_dev_lock()
                                 hci_conn_del(ACL parent)
                                   unlink SCO child
                                   drop link's parent reference
                                   clear child->parent
                                   release ACL parent
                                     bt_link_release()
                                       kfree(parent)
                                 hci_dev_unlock()
  read parent->features[0][3]

The reference held for the queued SCO child does not keep its ACL parent
alive after unlinking. Commit 42de40abe25d ("Bluetooth: hci_conn: fix the
SCO setup context lifetime") protects the child stored in the queued
context, but leaves these parent accesses unprotected.

With a 40 ms diagnostic delay after loading conn->parent, an instrumented
kernel based on fd179f8a05be, which already contains 42de40abe25d,
reported:

  BUG: KASAN: slab-use-after-free in hci_enhanced_setup_sync+0xda5/0xdf0
  Read of size 1 at addr ffff888102204047 by task kworker/u17:0/93
  Call Trace:
   hci_enhanced_setup_sync+0xda5/0xdf0
   hci_cmd_sync_work+0x13c/0x290
   process_one_work+0x6b4/0x10e0

  Allocated by task 92:
   __hci_conn_add+0x304/0x1df0
   hci_connect_acl+0x349/0x3e0
   hci_connect_sco+0x3b/0x9a0
   sco_sock_connect+0x475/0xca0

  Freed by task 94:
   kfree+0x121/0x3c0
   bt_link_release+0x79/0xa0
   device_release+0xc8/0x240
   kobject_put+0x14d/0x280
   hci_conn_del+0x524/0xe30
   hci_disconn_complete_evt+0x403/0x8c0
   hci_event_packet+0x71b/0xb20
   hci_rx_work+0x293/0x730

The accessed address is 71 bytes into the freed ACL parent, at its
features[0][3] byte; the queued SCO child is a different object. The
diagnostic preserves the loaded parent across the delay, matching the
unmodified compiled capability check, and does not change the parent
references or teardown path.

Hold hci_dev_lock() across the codec switch, including every call to
find_next_esco_param(), and release it on all selection errors. Keep
configure_datapath_sync() outside the critical section because it waits
for HCI events. Preserve parameter selection and existing return values.

Fixes: e07a06b4eb41 ("Bluetooth: Convert SCO configure_datapath to hci_sync")
Cc: stable@vger.kernel.org
Assisted-by: GPT-6-Astra
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_conn.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -306,11 +306,13 @@ static int hci_enhanced_setup_sync(struc
 	cp.tx_bandwidth   = cpu_to_le32(0x00001f40);
 	cp.rx_bandwidth   = cpu_to_le32(0x00001f40);
 
+	hci_dev_lock(hdev);
+
 	switch (conn->codec.id) {
 	case BT_CODEC_MSBC:
 		if (!find_next_esco_param(conn, esco_param_msbc,
 					  ARRAY_SIZE(esco_param_msbc)))
-			return -EINVAL;
+			goto unlock;
 
 		param = &esco_param_msbc[conn->attempt - 1];
 		cp.tx_coding_format.id = 0x05;
@@ -336,7 +338,7 @@ static int hci_enhanced_setup_sync(struc
 	case BT_CODEC_TRANSPARENT:
 		if (!find_next_esco_param(conn, esco_param_msbc,
 					  ARRAY_SIZE(esco_param_msbc)))
-			return -EINVAL;
+			goto unlock;
 
 		param = &esco_param_msbc[conn->attempt - 1];
 		cp.tx_coding_format.id = 0x03;
@@ -363,11 +365,11 @@ static int hci_enhanced_setup_sync(struc
 		if (conn->parent && lmp_esco_capable(conn->parent)) {
 			if (!find_next_esco_param(conn, esco_param_cvsd,
 						  ARRAY_SIZE(esco_param_cvsd)))
-				return -EINVAL;
+				goto unlock;
 			param = &esco_param_cvsd[conn->attempt - 1];
 		} else {
 			if (conn->attempt > ARRAY_SIZE(sco_param_cvsd))
-				return -EINVAL;
+				goto unlock;
 			param = &sco_param_cvsd[conn->attempt - 1];
 		}
 		cp.tx_coding_format.id = 2;
@@ -390,9 +392,11 @@ static int hci_enhanced_setup_sync(struc
 		cp.out_transport_unit_size = 16;
 		break;
 	default:
-		return -EINVAL;
+		goto unlock;
 	}
 
+	hci_dev_unlock(hdev);
+
 	cp.retrans_effort = param->retrans_effort;
 	cp.pkt_type = __cpu_to_le16(param->pkt_type);
 	cp.max_latency = __cpu_to_le16(param->max_latency);
@@ -401,6 +405,10 @@ static int hci_enhanced_setup_sync(struc
 		return -EIO;
 
 	return 0;
+
+unlock:
+	hci_dev_unlock(hdev);
+	return -EINVAL;
 }
 
 static bool hci_setup_sync_conn(struct hci_conn *conn, __u16 handle)


