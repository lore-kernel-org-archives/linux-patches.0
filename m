Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E73B12D1E8;
	Tue, 30 Apr 2024 11:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475646; cv=none; b=aH90SLvJ0M2KJI5+FDG39PX+s2zL1TyBWUfsqF6p59qi2lgrcXo4wY/tTqnuBOlvLtccZc/VlUpYqpUBUCQWqunA+C2mbGcsQT7vUj0z5jqgiOKcJ/3PCSYpp2iT2aFkEK5YSAS77fCY9W+XbHdyTtJuQlS/ahZkKTwuV0QyyqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475646; c=relaxed/simple;
	bh=/jg5mwwjla+0f2jfBWO+FyoJscoUmrKBz1vtcaqdC6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmPdnhpVDOpURfsciyn/VU/YSnXEkDojwzh+TbQg0bNuwu7HmAT1dWiWvfjJCwK1+B3TsMHnesZVwIgmRL3wo/pii8tV+xhwk5dtCHp1ow7V92RULzmcm+92d5WO75dQru1Mu3JQI8Yz/jzFPDFl3pznuksLxuI33KsZaYDSXMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6NjK+st; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6NjK+st"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45468C4AF1A;
	Tue, 30 Apr 2024 11:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475646;
	bh=/jg5mwwjla+0f2jfBWO+FyoJscoUmrKBz1vtcaqdC6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y6NjK+stlU05EcCPKLIr3b8tuTovwOJmzP2n2/nqZ5sWWahBgK2HhStxTq9uxo7gl
	 ksTP3Ho1FSM707nt/Oo5faOnyc7EBqdN1Bb/+q2UnmritkQIFMC+b9vIDZM1Uw31hQ
	 J+Pxf765ixbo7Hbk7VNB3Pn+3eUJCt9Sb6PzqtHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengping Jiang <jiangzp@google.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 121/186] Bluetooth: qca: fix NULL-deref on non-serdev setup
Date: Tue, 30 Apr 2024 12:39:33 +0200
Message-ID: <20240430103101.545459012@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 7ddb9de6af0f1c71147785b12fd7c8ec3f06cc86 upstream.

Qualcomm ROME controllers can be registered from the Bluetooth line
discipline and in this case the HCI UART serdev pointer is NULL.

Add the missing sanity check to prevent a NULL-pointer dereference when
setup() is called for a non-serdev controller.

Fixes: e9b3e5b8c657 ("Bluetooth: hci_qca: only assign wakeup with serial port support")
Cc: stable@vger.kernel.org      # 6.2
Cc: Zhengping Jiang <jiangzp@google.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_qca.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1938,8 +1938,10 @@ retry:
 		qca_debugfs_init(hdev);
 		hu->hdev->hw_error = qca_hw_error;
 		hu->hdev->cmd_timeout = qca_cmd_timeout;
-		if (device_can_wakeup(hu->serdev->ctrl->dev.parent))
-			hu->hdev->wakeup = qca_wakeup;
+		if (hu->serdev) {
+			if (device_can_wakeup(hu->serdev->ctrl->dev.parent))
+				hu->hdev->wakeup = qca_wakeup;
+		}
 	} else if (ret == -ENOENT) {
 		/* No patch/nvm-config found, run with original fw/config */
 		set_bit(QCA_ROM_FW, &qca->flags);


