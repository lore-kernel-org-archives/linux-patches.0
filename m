Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB31128816;
	Tue, 30 Apr 2024 10:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474690; cv=none; b=OiO3LIQ/WCuD1FUjBgeONjkQqbyhUyUjTLZuggUquLd2Nml64E7PPB47qAozWyL3aOjkv5cqjNWZoG5R+mtjM8SfBB4YeryTIpflcEZ6dmxXzDcO7v3QUHyNbGDT1wepgsaxgApIHX5XULulOpqJ0ACpLiAyM93+UEHCT8HQ+Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474690; c=relaxed/simple;
	bh=4bYrz8/XJSAtLuXhMeAiIVEuLtMBD5gPukMdw7cUC58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgtmRJ9wUuK3hcWURTPe4y4+B/4Lxerm2Zfs4KY40OpPrjePMfBQH1VB+QOcIiN4ycP4GokMj0EAYPLvu2pf48Au8z0rmLnn8kqeabUUpCLFXRk3wMpvj4Be50MZYzh5WnErQ7Tptf7bneFD6BcMx4+HOG2F3679aK05H80+Udk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YE9yuyaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YE9yuyaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A2CC2BBFC;
	Tue, 30 Apr 2024 10:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474690;
	bh=4bYrz8/XJSAtLuXhMeAiIVEuLtMBD5gPukMdw7cUC58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YE9yuyaIES6fQDoqTh+Q38Aucm1B8TGoEf/TeM5L+R2tV9zK1Pc8ktbTDhKR7UrS4
	 k2dyJpcZrwSwTSunvhHdOKh2oG6ADohxIsOGG56RBDvTcjuhO1clStjalGzQWTVe+6
	 nxRHkpM98M7yIGvnbSVkxK6XW6LLh9cM9rCbEstA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.8 227/228] Bluetooth: hci_sync: Fix UAF on create_le_conn_complete
Date: Tue, 30 Apr 2024 12:40:05 +0200
Message-ID: <20240430103110.353455546@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit f7cbce60a38a6589f0dade720d4c2544959ecc0e upstream.

While waiting for hci_dev_lock the hci_conn object may be cleanup
causing the following trace:

BUG: KASAN: slab-use-after-free in hci_connect_le_scan_cleanup+0x29/0x350
Read of size 8 at addr ffff888001a50a30 by task kworker/u3:1/111

CPU: 0 PID: 111 Comm: kworker/u3:1 Not tainted
6.8.0-rc2-00701-g8179b15ab3fd-dirty #6418
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-1.fc38
04/01/2014
Workqueue: hci0 hci_cmd_sync_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x21/0x70
 print_report+0xce/0x620
 ? preempt_count_sub+0x13/0xc0
 ? __virt_addr_valid+0x15f/0x310
 ? hci_connect_le_scan_cleanup+0x29/0x350
 kasan_report+0xdf/0x110
 ? hci_connect_le_scan_cleanup+0x29/0x350
 hci_connect_le_scan_cleanup+0x29/0x350
 create_le_conn_complete+0x25c/0x2c0

Fixes: 881559af5f5c ("Bluetooth: hci_sync: Attempt to dequeue connection attempt")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6763,6 +6763,9 @@ static void create_le_conn_complete(stru
 
 	hci_dev_lock(hdev);
 
+	if (!hci_conn_valid(hdev, conn))
+		goto done;
+
 	if (!err) {
 		hci_connect_le_scan_cleanup(conn, 0x00);
 		goto done;


