Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B867321255B;
	Sun, 26 Oct 2025 14:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490281; cv=none; b=ip7IF5iUQiw5x1sY3bCc8uyJuuAP9u/armmtcZjh8Y4dCi2XDtuFG6rAxzbbIHOS+5jSKw/qVMeMBhjkwsA6Z3+kxgzDwikoNNwNylFgQI5w5DJJ1JjOIlZj0+avrDA4aDE2MDwN1TVM06gbyPqimenBDljLJssD0RLYZG7UnRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490281; c=relaxed/simple;
	bh=6OSW80ODX/+DPFmwrdr1NBBw2wtaMF99V8+T407di4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tjxci/ZwxIqucXLXyC/1ek5AGHhmQFk+TxL/qBfAXFGtUc5vGpLiOdOTzKsn5WBl8bxYRftvOAayU0gDSG3KDhBXKtuS1AZfhNeSghCjCEzWv7Gev1w56/wl5pVrycPbu6ZlzwebJ/3+G9PBnAaQVul6RtfqegzocsCthy09em4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gtgAL0fF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gtgAL0fF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF2DC4CEE7;
	Sun, 26 Oct 2025 14:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490281;
	bh=6OSW80ODX/+DPFmwrdr1NBBw2wtaMF99V8+T407di4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gtgAL0fFSaUhB0X9DH1E0KYo7THFR5qkYAd0V6N5vPjPXvDg9Nm7aVutRy30dDCCr
	 5mdKEMuZpJF2q2kfMNcJ9yV9m7oBDXt7gfC241mu5/mfSQX6+GcAFqqYJ3sd42ZG8c
	 bHZlMojs+AtU5E1w4M2RMnJ4zKM7XaeV/y2Od/QOpclPXyq6m2IAp6h7LGLBpBwPsC
	 AFfnm+vChNcgJofsJGm3rvIdACv07+M51Lp9C3uMRM+dWbQPO5AAC6gI+OgWe4KlQP
	 Tze2guZouTRKLdjQAI5rP+t3ckFalxbxiW5bOI62W8uvGdS0tuCtWmPm4YNMyuk8js
	 ZJNK9f+ZGUgdg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hoyoung Seo <hy50.seo@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com,
	avri.altman@wdc.com
Subject: [PATCH AUTOSEL 6.17-6.1] scsi: ufs: core: Include UTP error in INT_FATAL_ERRORS
Date: Sun, 26 Oct 2025 10:49:15 -0400
Message-ID: <20251026144958.26750-37-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Hoyoung Seo <hy50.seo@samsung.com>

[ Upstream commit 558ae4579810fa0fef011944230c65a6f3087f85 ]

When a UTP error occurs in isolation, UFS is not currently recoverable.
This is because the UTP error is not considered fatal in the error
handling code, leading to either an I/O timeout or an OCS error.

Add the UTP error flag to INT_FATAL_ERRORS so the controller will be
reset in this situation.

  sd 0:0:0:0: [sda] tag#38 UNKNOWN(0x2003) Result: hostbyte=0x07
  driverbyte=DRIVER_OK cmd_age=0s
  sd 0:0:0:0: [sda] tag#38 CDB: opcode=0x28 28 00 00 51 24 e2 00 00 08 00
  I/O error, dev sda, sector 42542864 op 0x0:(READ) flags 0x80700 phys_seg
  8 prio class 2
  OCS error from controller = 9 for tag 39
  pa_err[1] = 0x80000010 at 2667224756 us
  pa_err: total cnt=2
  dl_err[0] = 0x80000002 at 2667148060 us
  dl_err[1] = 0x80002000 at 2667282844 us
  No record of nl_err
  No record of tl_err
  No record of dme_err
  No record of auto_hibern8_err
  fatal_err[0] = 0x804 at 2667282836 us

  ---------------------------------------------------
  		REGISTER
  ---------------------------------------------------
                             NAME	      OFFSET	         VALUE
                      STD HCI SFR	  0xfffffff0	           0x0
                             AHIT	        0x18	         0x814
                 INTERRUPT STATUS	        0x20	        0x1000
                 INTERRUPT ENABLE	        0x24	       0x70ef5

[mkp: commit desc]

Signed-off-by: Hoyoung Seo <hy50.seo@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Message-Id: <20250930061428.617955-1-hy50.seo@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- `include/ufs/ufshci.h:183` introduces the missing `UTP_ERROR` status
  bit and the same file at `include/ufs/ufshci.h:199-204` folds it into
  `INT_FATAL_ERRORS`, so a controller that raises only UTP_ERROR now
  trips `UFSHCD_ERROR_MASK` instead of being silently ignored.
- Once in the mask, `ufshcd_sl_intr()` hands that interrupt to
  `ufshcd_check_errors()` (`drivers/ufs/core/ufshcd.c:7089`), which
  records the bit (`drivers/ufs/core/ufshcd.c:6948`) and flags it as
  fatal (`drivers/ufs/core/ufshcd.c:6950`), ensuring error handling runs
  instead of timing out with hostbyte 0x07/OCS errors as seen in the
  report.
- The fatal classification propagates through
  `ufshcd_is_saved_err_fatal()` (`drivers/ufs/core/ufshcd.c:6444-6447`)
  into `ufshcd_err_handler()`, forcing the controller reset that is
  currently the only recovery path; without this one-line change the
  link never recovers from isolated UTP errors, leaving users with
  permanent I/O failures.
- The patch is header-only, touches no normal data-path logic, and
  merely aligns the interrupt mask with the hardware-defined fatal
  condition, making the regression risk minimal relative to the
  unrecoverable bug it resolves; no prerequisite commits are needed for
  stable backporting.

 include/ufs/ufshci.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 612500a7088f0..e64b701321010 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -180,6 +180,7 @@ static inline u32 ufshci_version(u32 major, u32 minor)
 #define UTP_TASK_REQ_COMPL			0x200
 #define UIC_COMMAND_COMPL			0x400
 #define DEVICE_FATAL_ERROR			0x800
+#define UTP_ERROR				0x1000
 #define CONTROLLER_FATAL_ERROR			0x10000
 #define SYSTEM_BUS_FATAL_ERROR			0x20000
 #define CRYPTO_ENGINE_FATAL_ERROR		0x40000
@@ -199,7 +200,8 @@ static inline u32 ufshci_version(u32 major, u32 minor)
 				CONTROLLER_FATAL_ERROR |\
 				SYSTEM_BUS_FATAL_ERROR |\
 				CRYPTO_ENGINE_FATAL_ERROR |\
-				UIC_LINK_LOST)
+				UIC_LINK_LOST |\
+				UTP_ERROR)
 
 /* HCS - Host Controller Status 30h */
 #define DEVICE_PRESENT				0x1
-- 
2.51.0

