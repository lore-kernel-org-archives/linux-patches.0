Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DE4134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51818C433EF;
	Mon, 12 Jun 2023 10:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566636;
	bh=41XFfg4sL9tKFaniXL7XJIZIre4vXqjU//NfS7vzDn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZ6ygjvIGhzYQu1o875JiFxgtOAFedpFhmtzc/bFzJWntFA1t3BE5aung3qgQ14XA
	 WL5Bha7bFYoaLk2osx0kNLhpWguH5mAVpR6XbdzPsBdNvDeJL6DmRlU5I0FmYoieLG
	 3rQrlV07+WfzXqJuX4JqJP9w/N7d4HvICrmZX0Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 090/132] Bluetooth: hci_qca: fix debugfs registration
Date: Mon, 12 Jun 2023 12:27:04 +0200
Message-ID: <20230612101714.352560159@linuxfoundation.org>
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

commit 47c5d829a3e326b7395352a10fc8a6effe7afa15 upstream.

Since commit 3e4be65eb82c ("Bluetooth: hci_qca: Add poweroff support
during hci down for wcn3990"), the setup callback which registers the
debugfs interface can be called multiple times.

This specifically leads to the following error when powering on the
controller:

	debugfs: Directory 'ibs' with parent 'hci0' already present!

Add a driver flag to avoid trying to register the debugfs interface more
than once.

Fixes: 3e4be65eb82c ("Bluetooth: hci_qca: Add poweroff support during hci down for wcn3990")
Cc: stable@vger.kernel.org	# 4.20
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_qca.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -78,7 +78,8 @@ enum qca_flags {
 	QCA_HW_ERROR_EVENT,
 	QCA_SSR_TRIGGERED,
 	QCA_BT_OFF,
-	QCA_ROM_FW
+	QCA_ROM_FW,
+	QCA_DEBUGFS_CREATED,
 };
 
 enum qca_capabilities {
@@ -635,6 +636,9 @@ static void qca_debugfs_init(struct hci_
 	if (!hdev->debugfs)
 		return;
 
+	if (test_and_set_bit(QCA_DEBUGFS_CREATED, &qca->flags))
+		return;
+
 	ibs_dir = debugfs_create_dir("ibs", hdev->debugfs);
 
 	/* read only */


