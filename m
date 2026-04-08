Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39BB361DB5;
	Wed,  8 Apr 2026 18:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674076; cv=none; b=fHsTHW/X6jAetwtz9+uPoH8Tipxei0Sx7eDOAQ3aKikXrCSR+TJn052xyxAiO/YRYKAK1FrKCvX9cJMzXzcyWzuWdOC4VKdqS3dF27xluN0uv3jbxKk0bcHHQzD+f5HYZ5jl/GXMgxn0PMjvJLcYVPasGIv+FigUclJyH0W6CGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674076; c=relaxed/simple;
	bh=8+J7sDCVNAJSWAHhv8VM7Oe3lQD9fgZLapOjpRJtvJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ft/mLY2h3jUx6EJt+y9fGe9a2YdEBEtal1xmb0H40Pcu28IVptRLUTrAJvsBdc+mNNBkfbeAHNJoCjXI2olT/ZdThm8ixUQshIVzWUcecHSARNRwuV2xq/hd5K3DV7RWiks8KlruG6L/Xhr4fcnogEscawWk1uVEaDuYAnkdyk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPtUTTxT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPtUTTxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F008C19421;
	Wed,  8 Apr 2026 18:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674076;
	bh=8+J7sDCVNAJSWAHhv8VM7Oe3lQD9fgZLapOjpRJtvJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JPtUTTxTYA0a0HxVsNjJpTwgouoYu1P9Yj9YRToSKDNzbEnZP+zpUfU5K0COstofP
	 oC6H+Qrv5P8uoDRKYdA1ZQPDzNsWeQbmX3rkc8JEKxBNjmAg7fIGV+7OCY6lD2ZFr8
	 sZwPU2VTMNW7b2/hTaPfPP4boDR1o9E8amIanB2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+72f94b474d6e50b71ffc@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Ian Abbott <abbotti@mev.co.uk>,
	Deepanshu Kartikey <kartikey406@gmail.com>
Subject: [PATCH 6.12 173/242] comedi: dt2815: add hardware detection to prevent crash
Date: Wed,  8 Apr 2026 20:03:33 +0200
Message-ID: <20260408175933.563204280@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 93853512f565e625df2397f0d8050d6aafd7c3ad upstream.

The dt2815 driver crashes when attached to I/O ports without actual
hardware present. This occurs because syzkaller or users can attach
the driver to arbitrary I/O addresses via COMEDI_DEVCONFIG ioctl.

When no hardware exists at the specified port, inb() operations return
0xff (floating bus), but outb() operations can trigger page faults due
to undefined behavior, especially under race conditions:

  BUG: unable to handle page fault for address: 000000007fffff90
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  RIP: 0010:dt2815_attach+0x6e0/0x1110

Add hardware detection by reading the status register before attempting
any write operations. If the read returns 0xff, assume no hardware is
present and fail the attach with -ENODEV. This prevents crashes from
outb() operations on non-existent hardware.

Reported-by: syzbot+72f94b474d6e50b71ffc@syzkaller.appspotmail.com
Cc: stable <stable@kernel.org>
Closes: https://syzkaller.appspot.com/bug?extid=72f94b474d6e50b71ffc
Tested-by: syzbot+72f94b474d6e50b71ffc@syzkaller.appspotmail.com
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Link: [https://lore.kernel.org/all/20260126070458.10974-1-kartikey406@gmail.com/T/]
Link: [https://lore.kernel.org/all/20260126070458.10974-1-kartikey406@gmail.com/T/
Link: https://patch.msgid.link/20260309104859.503529-1-kartikey406@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/dt2815.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/comedi/drivers/dt2815.c
+++ b/drivers/comedi/drivers/dt2815.c
@@ -175,6 +175,18 @@ static int dt2815_attach(struct comedi_d
 		    ? current_range_type : voltage_range_type;
 	}
 
+	/*
+	 * Check if hardware is present before attempting any I/O operations.
+	 * Reading 0xff from status register typically indicates no hardware
+	 * on the bus (floating bus reads as all 1s).
+	 */
+	if (inb(dev->iobase + DT2815_STATUS) == 0xff) {
+		dev_err(dev->class_dev,
+			"No hardware detected at I/O base 0x%lx\n",
+			dev->iobase);
+		return -ENODEV;
+	}
+
 	/* Init the 2815 */
 	outb(0x00, dev->iobase + DT2815_STATUS);
 	for (i = 0; i < 100; i++) {


