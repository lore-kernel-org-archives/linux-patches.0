Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476B8264A76;
	Mon,  1 Dec 2025 11:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588851; cv=none; b=ihlYWrKE5nCmqhcV0Vw8AVtHkbf8OoK8XEH5zdSOXugXGVXPCw0IuSPamkll05OHmz/rN/7nVPxG3O+6g66N+i8aUd8DLprhuXFbKX/z2InfJr5m2M3ohDfDMlzXgG6i6zKMaicGP7wIENaTZJorP5zuWZdbrCF7hbRKo0TCboM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588851; c=relaxed/simple;
	bh=mvjS9HA5wiqhBrbpRlkoClUwlt7079SCKRx8y2BggBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFM9dHgWdKUFyNcS1HlNA52m2WFQjU411YT5ohvLdaigWYdmCMzRtlerYwt8P8t2klB0D2Vk0SP05dWrHtKQqtkQdbIOplXmuN3ZxaCmdv1klnrI579Aj09zEqijozyzyozL07yGUZEAL/WgiddXuWNYzoz2dVqtpHmjMdyDZBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lF+lv+0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lF+lv+0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56F2C4CEF1;
	Mon,  1 Dec 2025 11:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588851;
	bh=mvjS9HA5wiqhBrbpRlkoClUwlt7079SCKRx8y2BggBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lF+lv+0q5UTKBP4nKEjX8eUoRfN/+tUs6TX8vUmwd2MReAmsxIeLjb41fFXrAidf3
	 V1HD5aFVyWM3jIdil3Wjq6epq006ka47fXGd7kY3i08stOdtxC+PaHzX4/BOi/9Vph
	 0VBRMP2/LoCm+CX0HOCiWPlg8kYRsz/terhaCqMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 161/187] Input: cros_ec_keyb - fix an invalid memory access
Date: Mon,  1 Dec 2025 12:24:29 +0100
Message-ID: <20251201112247.030610666@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

commit e08969c4d65ac31297fcb4d31d4808c789152f68 upstream.

If cros_ec_keyb_register_matrix() isn't called (due to
`buttons_switches_only`) in cros_ec_keyb_probe(), `ckdev->idev` remains
NULL.  An invalid memory access is observed in cros_ec_keyb_process()
when receiving an EC_MKBP_EVENT_KEY_MATRIX event in cros_ec_keyb_work()
in such case.

  Unable to handle kernel read from unreadable memory at virtual address 0000000000000028
  ...
  x3 : 0000000000000000 x2 : 0000000000000000
  x1 : 0000000000000000 x0 : 0000000000000000
  Call trace:
  input_event
  cros_ec_keyb_work
  blocking_notifier_call_chain
  ec_irq_thread

It's still unknown about why the kernel receives such malformed event,
in any cases, the kernel shouldn't access `ckdev->idev` and friends if
the driver doesn't intend to initialize them.

Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20251104070310.3212712-1-tzungbi@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/cros_ec_keyb.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/input/keyboard/cros_ec_keyb.c
+++ b/drivers/input/keyboard/cros_ec_keyb.c
@@ -244,6 +244,12 @@ static int cros_ec_keyb_work(struct noti
 	case EC_MKBP_EVENT_KEY_MATRIX:
 		pm_wakeup_event(ckdev->dev, 0);
 
+		if (!ckdev->idev) {
+			dev_warn_once(ckdev->dev,
+				      "Unexpected key matrix event\n");
+			return NOTIFY_OK;
+		}
+
 		if (ckdev->ec->event_size != ckdev->cols) {
 			dev_err(ckdev->dev,
 				"Discarded incomplete key matrix event.\n");


