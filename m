Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9F61BDA93;
	Tue, 27 Aug 2024 15:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772707; cv=none; b=FLmR8bk4W9UKJOyV0SijRrVaewc+02tIE8pFCfMQUB8QR6LrRmdZAah8+2TnTFg3eF5BSq/4T8V2RqdRTSDlW1nc971yLFIovhXp1PqE22NWsIzv/hX+slGeeHvHtlfGdyspLzRIdt7nW0feQ3CCKHmPxGgDyB4XCZ13cKgH/2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772707; c=relaxed/simple;
	bh=LlJ2IjTFqGiBvgtoiGn7zFFsTx9xY9finpHd8r0KHfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNbiDebt1T0QYaPztEguGretiqgUxRtnfJbTixpzQEQv9+hHBFLBQJpjOGhYLna/9J0kMTGU8M5NCbZ4/n+b9AhZ/WC3W64570ZyUOwn8MQdsjmo5tgoiQLkbZJd9as9mNorxSe6o8G+R/owKJvnfkQNPdD8OnQRvGsyziP5zUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hiqdTF5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hiqdTF5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF542C4DDF1;
	Tue, 27 Aug 2024 15:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772707;
	bh=LlJ2IjTFqGiBvgtoiGn7zFFsTx9xY9finpHd8r0KHfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hiqdTF5rlug4MudeTgfgghD0xL3UfiXASJh7JKw/7i/g+jjn3I+lLCSeIfVO00bDJ
	 /K7wApO9EDRBgsIdjZHLqf9muiE2TFNy9/lYwCRe8FBlDRkgY1B+IXmzpPUuVPVR/M
	 F6nMqz5fpyiAKW8Bu+JxNzl2hXAtv9iGfV73R6XE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Hao <yhao016@ucr.edu>,
	Weiteng Chen <wchen130@ucr.edu>,
	"Lee, Chun-Yi" <jlee@suse.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.1 295/321] Bluetooth: hci_ldisc: check HCI_UART_PROTO_READY flag in HCIUARTGETPROTO
Date: Tue, 27 Aug 2024 16:40:03 +0200
Message-ID: <20240827143849.486039405@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee, Chun-Yi <joeyli.kernel@gmail.com>

commit 9c33663af9ad115f90c076a1828129a3fbadea98 upstream.

This patch adds code to check HCI_UART_PROTO_READY flag before
accessing hci_uart->proto. It fixes the race condition in
hci_uart_tty_ioctl() between HCIUARTSETPROTO and HCIUARTGETPROTO.
This issue bug found by Yu Hao and Weiteng Chen:

BUG: general protection fault in hci_uart_tty_ioctl [1]

The information of C reproducer can also reference the link [2]

Reported-by: Yu Hao <yhao016@ucr.edu>
Closes: https://lore.kernel.org/all/CA+UBctC3p49aTgzbVgkSZ2+TQcqq4fPDO7yZitFT5uBPDeCO2g@mail.gmail.com/ [1]
Reported-by: Weiteng Chen <wchen130@ucr.edu>
Closes: https://lore.kernel.org/lkml/CA+UBctDPEvHdkHMwD340=n02rh+jNRJNNQ5LBZNA+Wm4Keh2ow@mail.gmail.com/T/ [2]
Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_ldisc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -770,7 +770,8 @@ static int hci_uart_tty_ioctl(struct tty
 		break;
 
 	case HCIUARTGETPROTO:
-		if (test_bit(HCI_UART_PROTO_SET, &hu->flags))
+		if (test_bit(HCI_UART_PROTO_SET, &hu->flags) &&
+		    test_bit(HCI_UART_PROTO_READY, &hu->flags))
 			err = hu->proto->id;
 		else
 			err = -EUNATCH;


