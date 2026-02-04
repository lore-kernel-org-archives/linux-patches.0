Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09A22D5A14;
	Wed,  4 Feb 2026 15:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217522; cv=none; b=oR8KxxZAz9+MigULdQ1CKk/8V94Zr68rN7cT+JMBb5WSjTit5cY4KwGLqfbXuaAzwpGACx7ltdzg0OMzTTbGMx4H2TVOLpA5ZyiqzilA/CrQ+PuKLQMa0IxeGBvO+8nklTj58c7+jlvk66aRMLaeQ1RHd2t7FeOOHRuyD8q+lpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217522; c=relaxed/simple;
	bh=vBVPaHbcFKY573+cF7MHtSRVLDhBcTx+q4lvUoIb+Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V11sJd5Uh2G89/mLFtvnn+8t1KFPitYWfVQ8hKnK6HnwUXq9Iw/PYYndoSV7FdXDFldR+iTgSLsqcN/ua/gYjOj3E1onwLXXLHaj7bjJGKa9pacLJhb9rH98sBzsNYOx5BpLNHJfhuP4igvgWTLFoPZcQHjkxcl7mVJvC64TNsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tydtrdhS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tydtrdhS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D036C4CEF7;
	Wed,  4 Feb 2026 15:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217522;
	bh=vBVPaHbcFKY573+cF7MHtSRVLDhBcTx+q4lvUoIb+Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tydtrdhSlgeYyH/SqvgMN0w7aj/E4wL+I7rHca60P+MdmGhRtxrLFQ7cwLyuGVMN8
	 ZBP38CEIYhmOG/tKy7yPuekN/w+rS7dd7q6wJrxUbMwv2damxM47vpGZeUgk+b68P3
	 3PiDK9Q04aX4HWyPGn/tryv9LeCDecjXhIo85CEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Ille <ondrej.ille@gmail.com>,
	Pavel Pisa <pisa@fel.cvut.cz>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 040/280] can: ctucanfd: fix SSP_SRC in cases when bit-rate is higher than 1 MBit.
Date: Wed,  4 Feb 2026 15:36:54 +0100
Message-ID: <20260204143911.080819889@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Ille <ondrej.ille@gmail.com>

commit e707c591a139d1bfa4ddc83036fc820ca006a140 upstream.

The Secondary Sample Point Source field has been
set to an incorrect value by some mistake in the
past

  0b01 - SSP_SRC_NO_SSP - SSP is not used.

for data bitrates above 1 MBit/s. The correct/default
value already used for lower bitrates is

  0b00 - SSP_SRC_MEAS_N_OFFSET - SSP position = TRV_DELAY
         (Measured Transmitter delay) + SSP_OFFSET.

The related configuration register structure is described
in section 3.1.46 SSP_CFG of the CTU CAN FD
IP CORE Datasheet.

The analysis leading to the proper configuration
is described in section 2.8.3 Secondary sampling point
of the datasheet.

The change has been tested on AMD/Xilinx Zynq
with the next CTU CN FD IP core versions:

 - 2.6 aka master in the "integration with Zynq-7000 system" test
   6.12.43-rt12+ #1 SMP PREEMPT_RT kernel with CTU CAN FD git
   driver (change already included in the driver repo)
 - older 2.5 snapshot with mainline kernels with this patch
   applied locally in the multiple CAN latency tester nightly runs
   6.18.0-rc4-rt3-dut #1 SMP PREEMPT_RT
   6.19.0-rc3-dut

The logs, the datasheet and sources are available at

 https://canbus.pages.fel.cvut.cz/

Signed-off-by: Ondrej Ille <ondrej.ille@gmail.com>
Signed-off-by: Pavel Pisa <pisa@fel.cvut.cz>
Link: https://patch.msgid.link/20260105111620.16580-1-pisa@fel.cvut.cz
Fixes: 2dcb8e8782d8 ("can: ctucanfd: add support for CTU CAN FD open-source IP core - bus independent part.")
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/ctucanfd/ctucanfd_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -310,7 +310,7 @@ static int ctucan_set_secondary_sample_p
 		}
 
 		ssp_cfg = FIELD_PREP(REG_TRV_DELAY_SSP_OFFSET, ssp_offset);
-		ssp_cfg |= FIELD_PREP(REG_TRV_DELAY_SSP_SRC, 0x1);
+		ssp_cfg |= FIELD_PREP(REG_TRV_DELAY_SSP_SRC, 0x0);
 	}
 
 	ctucan_write32(priv, CTUCANFD_TRV_DELAY, ssp_cfg);


