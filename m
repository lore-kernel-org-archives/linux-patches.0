Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52957129E89;
	Tue, 30 Apr 2024 10:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474523; cv=none; b=t6MzfNojckgRl3RpjZQmNVU1FJvEmrpDdjT4ffbwcbfp3XK8mWeN2XYqRv5iWLvrYCnxK13fGSBXPVjWtt+C2Yw2vzvaba/adxessXRoBqXzPRQO/DjlCfoxQN5BqiM+nCZd8NlQdB4igyBbU9A7h4UXA4LgR0bdeOFO1wuPV34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474523; c=relaxed/simple;
	bh=ZywwiTaoMOkYTu/C2aVNRoC3bir4vskKEC0tWAqh4JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pugk9CSx83Za0c/ECrT9LQ8aWewAOVMnGbvcQOepFObIbtjTq5O4OUZ7oWHj2dLQwS3jdeGDLftPSSSCLVQgttmAjKPNA8NnEZudaxShfHlxRbOZTYo17gk9QM5CLl2JoDrp0LehKZht+AIj2ZqwzH5EMXvx62uegbM2jP/4ptw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A97IbHB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A97IbHB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF97FC2BBFC;
	Tue, 30 Apr 2024 10:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474523;
	bh=ZywwiTaoMOkYTu/C2aVNRoC3bir4vskKEC0tWAqh4JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A97IbHB0X03J7JClR5ucFf1JaTSIUP2BfVmi0JaJTY9JwbNx/X1vevwQncETFElQ/
	 FkUZSPYmjXOoOsitt+OXtc2Xkei4q2dI1A6w5yNDQfiA3s4O+nkZFmAebgp9GepHlF
	 FCURBMmWwwWwh8lAHi6CvDJij46hcx3f3R24GgoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengping Jiang <jiangzp@google.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.8 145/228] Bluetooth: qca: fix NULL-deref on non-serdev setup
Date: Tue, 30 Apr 2024 12:38:43 +0200
Message-ID: <20240430103107.992572462@linuxfoundation.org>
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
@@ -1960,8 +1960,10 @@ retry:
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


