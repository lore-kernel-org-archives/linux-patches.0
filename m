Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB482E093A;
	Mon, 20 Apr 2026 15:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700418; cv=none; b=tM0saNicwPB4Ntokty2a6EcOHr9xdmJjD80+OWICBHEMknmwBM5YLbCFFAgN9zBS8TErGL2ZaPiqXpn5J54Wk/hqSO4m6bxyx/FVzLgHyqqrFOZ+eIjl5c6WZgR9l+iw40ZCw4wipDPp51kft6sO19s7wPltOOO0jWUOqYtol+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700418; c=relaxed/simple;
	bh=QpTxemgvNK9zKeZHQPbYXeunzOgVQVX2j5RKs9WdJHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2Sd7jfgbrhzvteVKW2YXOZuTJp8bXBlp6Hae97seATMe3sxd6YAEMY3Y20DOQf2W8aZ9+MzfjqicrSaDUHRQaN8LRUs68Lo6zR2zjsFDUWCF4l+4HAKdKwdmslL80GGAKPd2Rhxgd+krITjo3SCFkZ+q8Dol2Qe2KrTgxt4AIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCJsvdkw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCJsvdkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60782C2BCB6;
	Mon, 20 Apr 2026 15:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700417;
	bh=QpTxemgvNK9zKeZHQPbYXeunzOgVQVX2j5RKs9WdJHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FCJsvdkwjfgw8NnowI/FaMJLHeTCaQtVI/4toiF2/Q1VLFUasMRUE5RuCjyQKn/B+
	 3YFeuqRMp+3Okrr5xLdMH4MSdWdcYgnyOoDyPtnPtWlWUMA3n0Ktzl64h0uVSVN5ed
	 Us0E943XgHtW04f4ef+CPxFFamwxy2NnJRRgE6Ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alexey Charkov <alchark@flipper.net>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogrerus@linux.intel.com>
Subject: [PATCH 6.19 164/220] usb: typec: fusb302: Switch to threaded IRQ handler
Date: Mon, 20 Apr 2026 17:41:45 +0200
Message-ID: <20260420153939.933508589@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


