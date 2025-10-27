Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C541C32A3D1;
	Mon, 27 Oct 2025 19:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593572; cv=none; b=kCBHoaGPdFmAixDYr5I6nXWkFaXgTcfVnfAtWL6Gc+Mre4FWYSKGTfBS1GmufudAGl7QjSsVqnyidC6yH90t+V6hEIYIBsSaaawlwMiOFNGSq50DGwBF0gIlvmUFgrTPwR1BMgfCfqtVdaOs5bITDtInSCJR5tzxx1FWl+MJGuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593572; c=relaxed/simple;
	bh=Z6+soiYEbzQyswKq6S8AhFc8oAFmaPULhT2aphxGOW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djS1yAO2dUGtuGN1RGbjkChgix5a1FK0JIRmzR+1R1U+/OynUyRuQdh2gz0NXRO5LyKx7W8F/aRQ9twt+8Iqrm02K88gvZquFDDt74kcs9WI3Y7k/gFT2mPNvAf/VIpFSpEWGPet1tlpGmBHRQDG11/TTxPnuc6yvUnnuFzuNYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UA2BpFYf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UA2BpFYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DE8C113D0;
	Mon, 27 Oct 2025 19:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593572;
	bh=Z6+soiYEbzQyswKq6S8AhFc8oAFmaPULhT2aphxGOW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UA2BpFYfnfLrcKFTOjTgKWKtxjQRv/g8nL0zpG8xHp9Zk+mQp8l/Aq+k+1TmtaavC
	 wBq+/hJi1aeDZwVsJejBfAqF/q5RS3q0MXP45RZ9wz60LmHY8y366QHcM02QmiJC42
	 WaIEtG8iBZC1fxKI3mDwnAUl4auvITN8eBNTYDco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.17 176/184] staging: gpib: Return -EINTR on device clear
Date: Mon, 27 Oct 2025 19:37:38 +0100
Message-ID: <20251027183519.661141540@linuxfoundation.org>
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

commit aaf2af1ed147ef49be65afb541a67255e9f60d15 upstream.

When the ATN (Attention) line is asserted during a read we get a
NIUSB_ATN_STATE_ERROR during a read. For the controller to send a
device clear it asserts ATN. Normally this is an error but in the case
of a device clear it should be regarded as an interrupt.

Return -EINTR when the Device Clear Active State (DCAS) is entered
else signal an error with dev_dbg with status instead of just dev_err.

Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/gpib/ni_usb/ni_usb_gpib.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
+++ b/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
@@ -694,8 +694,12 @@ static int ni_usb_read(struct gpib_board
 		 */
 		break;
 	case NIUSB_ATN_STATE_ERROR:
-		retval = -EIO;
-		dev_err(&usb_dev->dev, "read when ATN set\n");
+		if (status.ibsta & DCAS) {
+			retval = -EINTR;
+		} else {
+			retval = -EIO;
+			dev_dbg(&usb_dev->dev, "read when ATN set stat: 0x%06x\n", status.ibsta);
+		}
 		break;
 	case NIUSB_ADDRESSING_ERROR:
 		retval = -EIO;


