Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4878C367F36;
	Wed, 28 Jan 2026 15:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614144; cv=none; b=R//eH86r3KSTgStzdPqirl7dC+Fjphs8w+9VoeX6ua2G86N+zrVo8aNE9A/MHRs+da+oi95L/2gZ1UcFdNgpEfnmVz8BUrj7hOql7HrFzPpI7QARxOYP27FC+uJ5V0Q6fnkHdWB9b334tj3/3y5a991CzT9/PEQakzbPB531xns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614144; c=relaxed/simple;
	bh=VDTfjHjU451nc1nohycCan5aMKt4/qmnYhP5vgJ6zaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAGV2iYh1jrGYav+Qfpa0PN2LxD8o67vnxOoVfQXiUbS3IjnGl5VHpVWlP/08gU1zECPdQUZRXjFXEffEE+vfSqtD4TyCZrpt5lRSDuJyqLAaV7G0nADCev2lxhQTB4SmBVkgMyQrTwuoaigvQ87SbYCHe+DzKaJzckv32oJJvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZ/QDXX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZ/QDXX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6094AC4CEF7;
	Wed, 28 Jan 2026 15:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614143;
	bh=VDTfjHjU451nc1nohycCan5aMKt4/qmnYhP5vgJ6zaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZ/QDXX2uSm9XzGw7myp5obs2HfPRC1lzCVKTko6VfBUNVV8q10fjbyu0f6xbLNXp
	 3YhkT5hGKQ7As+/+BFEkwEaJkAiGQ+Tgy+XqZEIDX+vyOzqMM4uHp1tUWmmohwdMwr
	 rQ6oM4ag/UUyLz7pi2UoyKa4ClGji7z6DVBK6d1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Ille <ondrej.ille@gmail.com>,
	Pavel Pisa <pisa@fel.cvut.cz>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 049/254] can: ctucanfd: fix SSP_SRC in cases when bit-rate is higher than 1 MBit.
Date: Wed, 28 Jan 2026 16:20:25 +0100
Message-ID: <20260128145346.466404436@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


