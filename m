Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CB2346A1C;
	Wed,  3 Dec 2025 16:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780033; cv=none; b=dDvwZPjjtHntKFP4LjzpaJ+CnWb5Aq0SIcARwDCIPMPkt55xdNHzTirhnBbKWf0TMmM1dP7XGFvIuzIW9t+WrR27BRxwSfxIXRnSUlfRaL80Ej291muafflZJs66yZk7HU9OacRRs/9a5M9pqCGjT5oJG4CjUi+v0v3T4ZBKgHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780033; c=relaxed/simple;
	bh=CnH8X+3GeTjS6p9I5n8GWFFy4Nk+uYgCZA8Kc3tMtzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxDlboBr1YR4OEu05pBC3LndHjoUuIZYGWMqsI4+9bAtnT60nkCcGVrPTxmUI9QKfVYSewJEKcYSm/ozV2DDxbVngvDIx35p5MnOTSVUplmt05xdq5TFfnC63Y2Gv97EP4tLceKAYwyHEWgID+4XAQEJz3aXg2f+VYaCMsMxIog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d++XoC4m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d++XoC4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC18C4CEF5;
	Wed,  3 Dec 2025 16:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780033;
	bh=CnH8X+3GeTjS6p9I5n8GWFFy4Nk+uYgCZA8Kc3tMtzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d++XoC4msk9qrL3hOFFIUHldb+bg+oD/PzPKi2r0sa15JGGG8p74ZNdGGmkCDd21y
	 Qi2P4vDS5bqhGEZytag3Ijn1wrMIx6yt76JmcSxeja6wiYn6/lDaeT2K80eI65q0Bc
	 Y5Gc60TOpMTBDKUg9XUh67awfv6Uu8bqY6d9LQCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 436/568] Input: cros_ec_keyb - fix an invalid memory access
Date: Wed,  3 Dec 2025 16:27:18 +0100
Message-ID: <20251203152456.665475117@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -248,6 +248,12 @@ static int cros_ec_keyb_work(struct noti
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


