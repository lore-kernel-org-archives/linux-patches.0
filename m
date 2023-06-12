Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C243D512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A1EC433A0;
	Mon, 12 Jun 2023 10:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566283;
	bh=41XFfg4sL9tKFaniXL7XJIZIre4vXqjU//NfS7vzDn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hkrzKI55eZhsQM7MuhYAW2E4YpChSA7TwlnsF4Ult72cmdVznrKKzSByFjDDgFXs6
	 LoNXHnPIbWDd+DkDzdaH+jdTF4ylpZNYPaujYoqrnZjKplZCqnZzmwTRHpvBP9ll4u
	 2oIA00Bf/UWC2ocAAAdbgjlltMDyPwAkWdZESzAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 64/91] Bluetooth: hci_qca: fix debugfs registration
Date: Mon, 12 Jun 2023 12:26:53 +0200
Message-ID: <20230612101704.738269524@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>
References: <20230612101702.085813286@linuxfoundation.org>
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


