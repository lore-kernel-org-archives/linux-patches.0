Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B779C393DDB;
	Wed,  3 Dec 2025 16:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779555; cv=none; b=jctf/41AQUnwRoN5OjGi6dzIuhuKdCL4loefsjJeoN3WOLzaJzFFsmJWNnfeV/Fy1yUFmjxaQGFpMkOVDIUkjdtOnbO+j0eDeyvgdm9g7kqfHlZLcsSscmh/6rRglIwZzzw6RE4VXTxb+174jSP4Ora3baduQdTAkHWHG7y27BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779555; c=relaxed/simple;
	bh=HF1zRSGMbYarJqBwoTV+khtecDE2uEuJ9AZLqV/yMf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6LaIj8FFOe0497Ob23GkpeNNww0JgyBDhvVLdz/lZqFEsKDZzxD4KlKCBDm92vZcQbbJLFCsVhtD7DQ4lIWt0NxLf8/Nhh8G9sgh9sYR8W65alN/HNNWFF55FuZazyTUKoero7EedOoRBQHJNjlLIwc/kudi4iQw2YnqaFBVmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSZp6Pfc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSZp6Pfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD05C4CEF5;
	Wed,  3 Dec 2025 16:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779555;
	bh=HF1zRSGMbYarJqBwoTV+khtecDE2uEuJ9AZLqV/yMf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSZp6PfcpoM+9725ztb6MIR2oyC8spY5XWQk4oGbFEHjkmQayp9xjSqx5OWwYB4FS
	 mTZN8bCW4nQl3lXznYv6UV3xP344pGB/dh+dkoLv9WMOOaNetw9Hn0oUP2J8oVpSz8
	 ViPTZUSuf6Qb8NErLGyJqqL1K4R82MeVF6FT0p9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hoyoung Seo <hy50.seo@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 293/568] scsi: ufs: core: Include UTP error in INT_FATAL_ERRORS
Date: Wed,  3 Dec 2025 16:24:55 +0100
Message-ID: <20251203152451.434230500@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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
 include/ufs/ufshci.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index f525566a0864d..6e80ed46e44ae 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -123,6 +123,7 @@ static inline u32 ufshci_version(u32 major, u32 minor)
 #define UTP_TASK_REQ_COMPL			0x200
 #define UIC_COMMAND_COMPL			0x400
 #define DEVICE_FATAL_ERROR			0x800
+#define UTP_ERROR				0x1000
 #define CONTROLLER_FATAL_ERROR			0x10000
 #define SYSTEM_BUS_FATAL_ERROR			0x20000
 #define CRYPTO_ENGINE_FATAL_ERROR		0x40000
@@ -141,7 +142,8 @@ static inline u32 ufshci_version(u32 major, u32 minor)
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



