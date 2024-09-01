Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0021C68C;
	Sun,  1 Sep 2024 16:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208998; cv=none; b=Pbw/lxJ5WgLVDEvkd0rPKE/J8WZlIPbloRDEn0foza1mBJd4l01OiO1IB4fAhmS2ygN/yNis5a6O1Y0Iiq3LB72/rxq47RFjKgVjZ3jv1v1LD9LBy1T7fFgOu4BLNkKVb6EL4DYzN+AI1FeOm7aACQlmrAl9x1qC2/uvOOp/V8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208998; c=relaxed/simple;
	bh=IQdYP6Fgm4zAh/uR2t23cITvIL9yfjt/U5nk3vMGblo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQEyVjQPzTfpK3ZZo56VPY1VQNXfnWP1ld++fyXRiagsHuwM+UoeiqY0TK4LbuwwwXBsz38OhQIGPy83ML+TkQWicBm0jKxWy7vRL96moouzEl0lZXkH1QYI9e8+6+dQAoQ7OIotTu8eRt4buebhAaP4thFyw0ywTyWyWi3Gc60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iK2waynm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iK2waynm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32C4C4CEC3;
	Sun,  1 Sep 2024 16:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208998;
	bh=IQdYP6Fgm4zAh/uR2t23cITvIL9yfjt/U5nk3vMGblo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iK2waynmBKY7Ga5v0viE5V6PDMDHIJEtX7kApyOTuXaSdPdmYHtyzFRjTftSY1pRl
	 ba1MFzaLxnUjoXd5aK3cQRCZdna3HI93JFDWftFMfTKiXp453c9uMyU3vqix8GWDW5
	 iqtyo2+CMJtIGVruAwZWIPYb5rlxVonIMM8RSdm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Hao <yhao016@ucr.edu>,
	Weiteng Chen <wchen130@ucr.edu>,
	"Lee, Chun-Yi" <jlee@suse.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.4 104/134] Bluetooth: hci_ldisc: check HCI_UART_PROTO_READY flag in HCIUARTGETPROTO
Date: Sun,  1 Sep 2024 18:17:30 +0200
Message-ID: <20240901160814.002603830@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -765,7 +765,8 @@ static int hci_uart_tty_ioctl(struct tty
 		break;
 
 	case HCIUARTGETPROTO:
-		if (test_bit(HCI_UART_PROTO_SET, &hu->flags))
+		if (test_bit(HCI_UART_PROTO_SET, &hu->flags) &&
+		    test_bit(HCI_UART_PROTO_READY, &hu->flags))
 			err = hu->proto->id;
 		else
 			err = -EUNATCH;


