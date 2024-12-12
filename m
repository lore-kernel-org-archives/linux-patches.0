Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC37E222D62;
	Thu, 12 Dec 2024 17:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023536; cv=none; b=KjL3hJ1YTWEBU1eXUWUbqy4+s0P9Jr26Y+Pi6g4mUTZPzAgW8xh8C7VgkItA4rby2+qODeDbRgsoBVW5F4VFQxFyH4s9BE/VCM1Yr/IGAtq8oEc6RXLWdX/EIYea2o1fPcp8DRDalokruIXSPBPwx4Kb5EfJ4w2jhdrXI9nZ8zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023536; c=relaxed/simple;
	bh=YG1HSts7AT2Z+UeMBY/7KBtK7k01Hq/kgMjfYVihIJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7T2wo1y2Xe28sjq8WRk0seeAs2bDP1DOhva8PkO8zAJ8+3S2/MnSJuK3k8z8LKNAaLIdYvo2w6la4f7k9KvX8QX8Hsj+KgUYIOjajVn/qDIh3lqFOOls2LPUrlko0QeG1mX2f9jLVaJjVzIHsc2Z0WzoQt7UE3K/hX7e4RcUws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TbjnPRKU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TbjnPRKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64021C4CED0;
	Thu, 12 Dec 2024 17:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023535;
	bh=YG1HSts7AT2Z+UeMBY/7KBtK7k01Hq/kgMjfYVihIJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TbjnPRKUbUmUyUXGNrZPgIcwLNLV5MYti5qscccZA5udAXvj6tAl5Ze0eNyNJ1HqZ
	 fhbv7KCZJbSZHpt3hzqswx70rWqN6AYLe3zvgyXMb4//kT3frWKVRhvvKlnbo7KJPs
	 gCllE8GAp4cOg8J1Ntls7rlNCsl7AIid3Ucf9xDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 565/565] Bluetooth: hci_core: Fix calling mgmt_device_connected
Date: Thu, 12 Dec 2024 16:02:40 +0100
Message-ID: <20241212144334.225704824@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 7967dc8f797f454d4f4acec15c7df0cdf4801617 upstream.

Since 61a939c68ee0 ("Bluetooth: Queue incoming ACL data until
BT_CONNECTED state is reached") there is no long the need to call
mgmt_device_connected as ACL data will be queued until BT_CONNECTED
state.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219458
Link: https://github.com/bluez/bluez/issues/1014
Fixes: 333b4fd11e89 ("Bluetooth: L2CAP: Fix uaf in l2cap_connect")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4964,8 +4964,6 @@ static void hci_acldata_packet(struct hc
 
 	hci_dev_lock(hdev);
 	conn = hci_conn_hash_lookup_handle(hdev, handle);
-	if (conn && hci_dev_test_flag(hdev, HCI_MGMT))
-		mgmt_device_connected(hdev, conn, NULL, 0);
 	hci_dev_unlock(hdev);
 
 	if (conn) {


