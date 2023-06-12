Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB778828
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4799EC433EF;
	Mon, 12 Jun 2023 10:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566592;
	bh=5HsKXk44TErqfeDBbRpzj/cxzcexFNH+IqdzlMw7Mwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVWrCInA1oB7bApq9xddquPG2AVsRVTIVUAxIc4WGKpyT0R8P2kyXoujInAvxSIi4
	 n4rkbzsDJ6zRhrF8mPLi3ebK6COtc98A2qUWJWV/W8KqGzDbFWMCwdgP/yaNTYDGvi
	 kPpNN8C3rBWEEwWfGoFyDCKXK7dF6VZDwgMt8Kjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 089/132] Bluetooth: fix debugfs registration
Date: Mon, 12 Jun 2023 12:27:03 +0200
Message-ID: <20230612101714.308057659@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit fe2ccc6c29d53e14d3c8b3ddf8ad965a92e074ee upstream.

Since commit ec6cef9cd98d ("Bluetooth: Fix SMP channel registration for
unconfigured controllers") the debugfs interface for unconfigured
controllers will be created when the controller is configured.

There is however currently nothing preventing a controller from being
configured multiple time (e.g. setting the device address using btmgmt)
which results in failed attempts to register the already registered
debugfs entries:

	debugfs: File 'features' in directory 'hci0' already present!
	debugfs: File 'manufacturer' in directory 'hci0' already present!
	debugfs: File 'hci_version' in directory 'hci0' already present!
	...
	debugfs: File 'quirk_simultaneous_discovery' in directory 'hci0' already present!

Add a controller flag to avoid trying to register the debugfs interface
more than once.

Fixes: ec6cef9cd98d ("Bluetooth: Fix SMP channel registration for unconfigured controllers")
Cc: stable@vger.kernel.org      # 4.0
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/hci.h |    1 +
 net/bluetooth/hci_sync.c    |    3 +++
 2 files changed, 4 insertions(+)

--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -350,6 +350,7 @@ enum {
 enum {
 	HCI_SETUP,
 	HCI_CONFIG,
+	HCI_DEBUGFS_CREATED,
 	HCI_AUTO_OFF,
 	HCI_RFKILLED,
 	HCI_MGMT,
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4492,6 +4492,9 @@ static int hci_init_sync(struct hci_dev
 	    !hci_dev_test_flag(hdev, HCI_CONFIG))
 		return 0;
 
+	if (hci_dev_test_and_set_flag(hdev, HCI_DEBUGFS_CREATED))
+		return 0;
+
 	hci_debugfs_create_common(hdev);
 
 	if (lmp_bredr_capable(hdev))


