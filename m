Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C0F284681;
	Wed, 23 Apr 2025 15:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420485; cv=none; b=YN9Xjrw+ucZgnyiwkGfOFf9M+KLhgwkTfBLD+/44f5i2n3jGszMdSEnuOmfi5Z2cqUncxlpLEC3kjwaPJTWMgRY12YAiXGoYFxIcs9y8ty+5S7CNyvc/s9YJHYMShv6X7n9jTBPINhj7dv8Tjks6pblF0E5X2SwQVjKqksrz7ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420485; c=relaxed/simple;
	bh=g5FY809qNbb99edIMBewA5+RvjYshpPNBsJGzGLrtAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cn5uyaC8/ABVPl2fiwm/tPtGO/v8AKqAs6RUw/2ogxC2o1s/c49uJtpFHfXlrBIdkma7FrmxSjvV4Dl0D9udRVVrehO4l1qKBtUhJBc3NaSlgurqLucwP01ux2xbhuVrFIjh31pDPo07vdoKOFOTh5isxqCKUscnh/rPOh9WPeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X5Q55rfU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X5Q55rfU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D529C4CEE2;
	Wed, 23 Apr 2025 15:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420485;
	bh=g5FY809qNbb99edIMBewA5+RvjYshpPNBsJGzGLrtAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X5Q55rfUWFiVK8NSlmNEV1O6BTByEMDD+aUaqzVv9nqHLSNhgS39fGQspZm4qvn+2
	 oI3GXvQD3Wl2FP+xnPLbIE06wnPbZLgjmoUjyrOuUHx2zgFhOysASdDnLSLENZbrn8
	 FT2LHyWIf0g8C/m943I/W2FkQJuY/HF+/i5+3RLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/291] Bluetooth: hci_uart: fix race during initialization
Date: Wed, 23 Apr 2025 16:40:40 +0200
Message-ID: <20250423142626.473366603@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Arseniy Krasnov <avkrasnov@salutedevices.com>

[ Upstream commit 366ceff495f902182d42b6f41525c2474caf3f9a ]

'hci_register_dev()' calls power up function, which is executed by
kworker - 'hci_power_on()'. This function does access to bluetooth chip
using callbacks from 'hci_ldisc.c', for example 'hci_uart_send_frame()'.
Now 'hci_uart_send_frame()' checks 'HCI_UART_PROTO_READY' bit set, and
if not - it fails. Problem is that 'HCI_UART_PROTO_READY' is set after
'hci_register_dev()', and there is tiny chance that 'hci_power_on()' will
be executed before setting this bit. In that case HCI init logic fails.

Patch moves setting of 'HCI_UART_PROTO_READY' before calling function
'hci_uart_register_dev()'.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_ldisc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index c1feebd9e3a03..5dc2f38c7b9a7 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -709,12 +709,13 @@ static int hci_uart_set_proto(struct hci_uart *hu, int id)
 
 	hu->proto = p;
 
+	set_bit(HCI_UART_PROTO_READY, &hu->flags);
+
 	err = hci_uart_register_dev(hu);
 	if (err) {
 		return err;
 	}
 
-	set_bit(HCI_UART_PROTO_READY, &hu->flags);
 	return 0;
 }
 
-- 
2.39.5



