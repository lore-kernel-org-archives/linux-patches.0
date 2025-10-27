Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D06328638;
	Mon, 27 Oct 2025 19:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593569; cv=none; b=oWXI47gYNye5bf5kcAdxMsNA7NbDCvHksRLzPJEcK1HQacFMBzXkRoPGmLIqSJDtFE0DfUlH0Tx99cVVBbUszGdfeg6Pd6AsTSeKNyZJu4jW2/hD8Xl68YMMtBVRXIEvuUVmwVQxqr6bwz6aplMLKyuy6K8pacnLwOgNqIzYcEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593569; c=relaxed/simple;
	bh=JYbh0CtVPELSQ8y7VV9/QpbR6Z40OrAu3Pr290RVIV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBYmxW/idu7sEl8CsX34WM+oDHx6R8NoE/qzCSAsy4Ex1x3p/D0ldeBM/ZXvMZ1Yid4755N9GYKdv5j5RxTF4sXAMsIF9lgXpFCsere+pmo9yIj2s6Su3YZXu/fwn5LUOKnb1ARXu0Ak23YkA80JeF5ETIIwV1DM2CGEOvTVf4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zw/MB+WN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zw/MB+WN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3888EC4CEF1;
	Mon, 27 Oct 2025 19:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593569;
	bh=JYbh0CtVPELSQ8y7VV9/QpbR6Z40OrAu3Pr290RVIV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zw/MB+WNJeZx5QEeH/LJmPH7Nu57KjarFCWmhDp7qiKwg26qzlqStvFmoD1WYBz35
	 T8UTKgCRal7DgRtRWwGDkDfuHxurNTfJyWfOv70dI2xz4U6IUogUe0NZ19CaYZGXAD
	 MW7ByUXJV7WPjHtYv27ne4c/cvtJyu3iloS5vE0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dave Penkler <dpenkler@gmail.com>
Subject: [PATCH 6.17 175/184] staging: gpib: Fix no EOI on 1 and 2 byte writes
Date: Mon, 27 Oct 2025 19:37:37 +0100
Message-ID: <20251027183519.634235982@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Penkler <dpenkler@gmail.com>

commit d3c4c1f29aadccf2f43530bfa1e60a6d8030fd4a upstream.

EOI (End Or Identify) is a hardware line on the GPIB bus that can be
asserted with the last byte of a message to indicate the end of the
transfer to the receiving device.

In this driver, a write with send_eoi true is done in 3 parts:
  Send first byte directly
  Send remaining but 1 bytes using the fifo
  Send the last byte directly with EOI asserted

The first byte in a write is always sent by writing to the tms9914
chip directly to setup for the subsequent fifo transfer.  We were not
checking for a 1 byte write with send_eoi true resulting in EOI not
being asserted. Since the fifo transfer was not executed
(fifotransfersize == 0) the retval in the test after the fifo transfer
code was still 1 from the preceding direct write. This caused it to
return without executing the final direct write which would have sent
an unsollicited extra byte.

For a 2 byte message the first byte was sent directly. But since the
fifo transfer was not executed (fifotransfersize == 1) and the retval
in the test after the fifo transfer code was still 1 from the
preceding first byte write it returned before the final direct byte
write with send_eoi true. The second byte was then sent as a separate
1 byte write to complete the 2 byte write count again without EOI
being asserted as above.

Only send the first byte directly if more than 1 byte is to be
transferred with send_eoi true.

Also check for retval < 0 for the error return in case the fifo code
is not used (1 or 2 byte message with send_eoi true).

Fixes: 09a4655ee1eb ("staging: gpib: Add HP/Agilent/Keysight 8235xx PCI GPIB driver")
Cc: stable <stable@kernel.org>
Tested-by: Dave Penkler <dpenkler@gmail.com>
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/gpib/agilent_82350b/agilent_82350b.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/staging/gpib/agilent_82350b/agilent_82350b.c
+++ b/drivers/staging/gpib/agilent_82350b/agilent_82350b.c
@@ -182,10 +182,12 @@ static int agilent_82350b_accel_write(st
 		return retval;
 #endif
 
-	retval = agilent_82350b_write(board, buffer, 1, 0, &num_bytes);
-	*bytes_written += num_bytes;
-	if (retval < 0)
-		return retval;
+	if (fifotransferlength > 0) {
+		retval = agilent_82350b_write(board, buffer, 1, 0, &num_bytes);
+		*bytes_written += num_bytes;
+		if (retval < 0)
+			return retval;
+	}
 
 	write_byte(tms_priv, tms_priv->imr0_bits & ~HR_BOIE, IMR0);
 	for (i = 1; i < fifotransferlength;) {
@@ -217,7 +219,7 @@ static int agilent_82350b_accel_write(st
 			break;
 	}
 	write_byte(tms_priv, tms_priv->imr0_bits, IMR0);
-	if (retval)
+	if (retval < 0)
 		return retval;
 
 	if (send_eoi) {


