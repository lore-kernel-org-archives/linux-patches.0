Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E44A33E373;
	Mon, 20 Apr 2026 16:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701090; cv=none; b=Cy4pYtJ6LrfENTuHnR2KfNEGVPWlNqJmDWLtKXTBtmYWqkxtaU8PyZI5fnThaltPSavXS8shVHcrozDmew5ZYxEu/1hi3x3VZzU9jmurtHjnqSUZ0AG3ooE6QU2LET5TfBwLDu/7bH6SK6WqLwV07MQUqhyZrcJkQoKahWiaIRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701090; c=relaxed/simple;
	bh=HsxjKbojB2dyscvySW+aqJT91rOoFelFKc/x8J2zJAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQjz3C2Di+8NYkn1TwoaIovSubeZFfDW0XEvEI2Kp9uMlSlnC52o7C/qjQXkGLStiuiXDGDITfQ3m/iSEjs5F0REj0KLyAkqxFv5gUVqtCvZ5obVGumt9nHG8OKpj88kjEXOO0/WYj7RzL49JK6WpvUByEUKuuyPYnnkajJcvsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ao3lTP5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ao3lTP5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C905CC19425;
	Mon, 20 Apr 2026 16:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701090;
	bh=HsxjKbojB2dyscvySW+aqJT91rOoFelFKc/x8J2zJAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ao3lTP5OlfbXdsA/tSQw/AbCCi2PzuNy3fgtxlkvMRzXWVTUP8IfZ4vqCjBkUYfS1
	 I+ZvVSmVGjKcqLVzeX97TitoRSJjAI9W3VYXfqq4bUZfs7SC43Uwp91+a0sR/u1xg8
	 kYWWatlUPiU0srhDp8NL9DijYlgXNxKQNXSgj6Do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alexey Charkov <alchark@flipper.net>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogrerus@linux.intel.com>
Subject: [PATCH 6.18 145/198] usb: typec: fusb302: Switch to threaded IRQ handler
Date: Mon, 20 Apr 2026 17:42:04 +0200
Message-ID: <20260420153940.829277350@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Charkov <alchark@flipper.net>

commit 6b9db53197094f38a18797495df2e3c758ec51dc upstream.

FUSB302 fails to probe with -EINVAL if its interrupt line is connected via
an I2C GPIO expander, such as TI TCA6416.

Switch the interrupt handler to a threaded one, which also works behind
such GPIO expanders.

Cc: stable <stable@kernel.org>
Fixes: 309b6341d557 ("usb: typec: fusb302: Revert incorrect threaded irq fix")
Signed-off-by: Alexey Charkov <alchark@flipper.net>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Reviewed-by: Heikki Krogerus <heikki.krogrerus@linux.intel.com>
Link: https://patch.msgid.link/20260317-fusb302-irq-v2-1-dbabd5c5c961@flipper.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/fusb302.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/tcpm/fusb302.c
+++ b/drivers/usb/typec/tcpm/fusb302.c
@@ -1755,8 +1755,9 @@ static int fusb302_probe(struct i2c_clie
 		goto destroy_workqueue;
 	}
 
-	ret = request_irq(chip->gpio_int_n_irq, fusb302_irq_intn,
-			  IRQF_TRIGGER_LOW, "fsc_interrupt_int_n", chip);
+	ret = request_threaded_irq(chip->gpio_int_n_irq, NULL, fusb302_irq_intn,
+				   IRQF_ONESHOT | IRQF_TRIGGER_LOW,
+				   "fsc_interrupt_int_n", chip);
 	if (ret < 0) {
 		dev_err(dev, "cannot request IRQ for GPIO Int_N, ret=%d", ret);
 		goto tcpm_unregister_port;


