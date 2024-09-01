Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1697A1DFD1;
	Sun,  1 Sep 2024 16:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209703; cv=none; b=bDnnAnwEI2UjHiWB9+8ofuFRPmulVXjYyoZGZ5uZIr8E62CWfFqVqYJxhnpGtetSis8+rQMqaO2Zfg7Ss0T6xLTQUTdbfmQddDOVu5c3lOj2Tga2msf5b84sEVCNWV2/urOnUAADf4EzHgR9IE3Mrk894p6bEIzWnuZR5Z7WtJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209703; c=relaxed/simple;
	bh=yKcvk/iWGqwqTSatmweZP9az2ZbjblHiD1f+ty93W+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvStcFGSBdCGZbOZosQfCbSE4+YW8N5Nneqf4u+2M1+U/sv2gNoRo5+fSqJBxsNr6D17I5bHiMMt+E7YGqZjuAvA0RYzjtqaKu/tLF58ZkssgF5TTNfKQEq3DYwEFGYlYrPyQh1LzHyCOL9Pe1cSA/qbMzM1ryaZEv0G4ky8+dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BT3tlNkM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BT3tlNkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B9FC4CEC3;
	Sun,  1 Sep 2024 16:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209703;
	bh=yKcvk/iWGqwqTSatmweZP9az2ZbjblHiD1f+ty93W+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BT3tlNkMADp0XbrLXTjiAxdKO2ZBDNY+1t9kGExYjLxufWABoqc8d7YJWv/rWYaxt
	 mmN9IAWoGuKXxaPXab8ZReR2mjVgch4ZEY0HGkN3bUPF7RB+kYcTvuedNWfrbSv8j8
	 Yg/IkXv5hzQ/WOomzqrVCeeATowpHND5CRipk1KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Hao <yhao016@ucr.edu>,
	Weiteng Chen <wchen130@ucr.edu>,
	"Lee, Chun-Yi" <jlee@suse.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.10 118/151] Bluetooth: hci_ldisc: check HCI_UART_PROTO_READY flag in HCIUARTGETPROTO
Date: Sun,  1 Sep 2024 18:17:58 +0200
Message-ID: <20240901160818.548294963@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


