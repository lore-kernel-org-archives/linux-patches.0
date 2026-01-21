Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9355F330679;
	Wed, 21 Jan 2026 18:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019650; cv=none; b=P4ieDzsCFjQE131HbwH11VmSv0UCfZI4EkkILRTwPlnhJPhlzBiUG7imxcurnz1uHpU5oV7p0yIqY/sEZ7Qbqayt9ymH1W7PljgHbzosR0TsPMcM7VsKEGTmZQm5bmATFERWqIN+nVagOv6tjHJoQm32+C22OJHE7lpjr5poNag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019650; c=relaxed/simple;
	bh=1cSvDhT7LVEx34DN+B4LwqFc5lDppwdLRr33pyub/aA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+mTEjRDrnyA/YUkwmGrCrpsNqUz8bxWhbl65A84r2e4tElxC06l1SKRJrJmUcHtLds9F+G/tpd7ahBjBcXSFXXJ9L0yhkRUh7OeANB2/DyiOmZG5xbCXYcarEcy8Y5OVNOYC1azt/7+MX35LhWbDJS4e6hv6AZGko4t+hkV1Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2bnKcYDD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2bnKcYDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD21C4CEF1;
	Wed, 21 Jan 2026 18:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019650;
	bh=1cSvDhT7LVEx34DN+B4LwqFc5lDppwdLRr33pyub/aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2bnKcYDDeQ/bbEU2/1vdu+91MUaiXJgZyQw8ECB3Fbq3J5B7fw+uNd4ApjzxJHTaC
	 leaWAPiqV4PpBXbLg31JuXi1Y8xHCQ7/0A5xVI7mWMsfPj/4fTRcRy0hA2+WIBNz65
	 iG37UYD3mQrUVeADOAgw2m8vqomMqD3fwk1pXwlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Ille <ondrej.ille@gmail.com>,
	Pavel Pisa <pisa@fel.cvut.cz>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 068/139] can: ctucanfd: fix SSP_SRC in cases when bit-rate is higher than 1 MBit.
Date: Wed, 21 Jan 2026 19:15:16 +0100
Message-ID: <20260121181413.901314386@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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


