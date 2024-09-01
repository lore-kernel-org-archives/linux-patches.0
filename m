Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6AF26AC1;
	Sun,  1 Sep 2024 17:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210471; cv=none; b=UrlsJ/1DRTbmN5fLDBWwhyjoHodtvFb6w1doCoB+caX3JGDOFiQh3ADiPqxPEc+NtZDLequD0xSdAfHpXJQJEpEJdcBcZlv0ZMNxhss7ErAFd4tBDyfC0iuz6Syh7go2ub59e0xz1lwmQwn1GYLun5gh3sEWKfAtoFLBW4GbW5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210471; c=relaxed/simple;
	bh=FPYnSwdPquWAh+GWXmaBVxMUo9JxrMLeT02fWqNe90o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccCG7lfmPL7KhaJXnfBrVen1TjgxrCH6E2dnrnjeWToe3ZmYz3qZr7hgDDppJXjPu6mP6JsMxfoRdxQtABL8I3R03NO8tTegV4ivsQhFXVLC7V4KxP6gsKtbKRvuRfbLw3uJUdtON0XGoLc0coi43cmWE45+0oSWzz57NhC9cHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHb+i/5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHb+i/5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D83C4CEC3;
	Sun,  1 Sep 2024 17:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210471;
	bh=FPYnSwdPquWAh+GWXmaBVxMUo9JxrMLeT02fWqNe90o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vHb+i/5nmCV1TyQToT7sM5H9z8hHbgfIgveEOsFQ9rx8pDOBk5Q4qzdPowVqeMwTF
	 rAWKHexNF2N13gFWnOhvqPFFbLhG7BxNkU1BPItRBXtdWp+H4+RWMyWEX5m7mubxx3
	 3Imjo2RZAJJBoc2yc0mPsqS65Yc9vTf9lyekqAg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Hao <yhao016@ucr.edu>,
	Weiteng Chen <wchen130@ucr.edu>,
	"Lee, Chun-Yi" <jlee@suse.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.15 172/215] Bluetooth: hci_ldisc: check HCI_UART_PROTO_READY flag in HCIUARTGETPROTO
Date: Sun,  1 Sep 2024 18:18:04 +0200
Message-ID: <20240901160829.865553697@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -768,7 +768,8 @@ static int hci_uart_tty_ioctl(struct tty
 		break;
 
 	case HCIUARTGETPROTO:
-		if (test_bit(HCI_UART_PROTO_SET, &hu->flags))
+		if (test_bit(HCI_UART_PROTO_SET, &hu->flags) &&
+		    test_bit(HCI_UART_PROTO_READY, &hu->flags))
 			err = hu->proto->id;
 		else
 			err = -EUNATCH;


