Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAEE2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733FAC433EF;
	Wed, 12 Apr 2023 08:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288906;
	bh=vVMujNle3lMqeU6dWkS8rSDZt+7+0BlHFempBIRKjQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7wkTr23+YdPMmPX393IiSGCgfqa8fokJWkcB7zN2oT6UadLNnvvNJSIWuO8t11sZ
	 Ms5+CqAOfApfdI411vPzW8+c2HKV5n3hVQhpmaNkrX9IfS7xwnzKs+MO/fwm3MD95x
	 RXCZD7XaJqc38Ivdll4rOA8NPAc7cXe9dkeGqcR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Stable@vger.kernel.org,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 063/164] xhci: Free the command allocated for setting LPM if we return early
Date: Wed, 12 Apr 2023 10:33:05 +0200
Message-Id: <20230412082839.493782643@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit f6caea4855553a8b99ba3ec23ecdb5ed8262f26c upstream.

The command allocated to set exit latency LPM values need to be freed in
case the command is never queued. This would be the case if there is no
change in exit latency values, or device is missing.

Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Link: https://lore.kernel.org/linux-usb/24263902-c9b3-ce29-237b-1c3d6918f4fe@alu.unizg.hr
Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Fixes: 5c2a380a5aa8 ("xhci: Allocate separate command structures for each LPM command")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230330143056.1390020-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4406,6 +4406,7 @@ static int __maybe_unused xhci_change_ma
 
 	if (!virt_dev || max_exit_latency == virt_dev->current_mel) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
+		xhci_free_command(xhci, command);
 		return 0;
 	}
 


