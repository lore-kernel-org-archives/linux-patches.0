Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D8A3DB95
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PI2zmzx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B55C433C8;
	Wed, 15 Nov 2023 20:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078455;
	bh=GvBTPUIy8TUqSwRR1VVRQ9MHtJa2kjm53H8bzyJGTP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PI2zmzx6ADsXSsmmV9L8IZebusJwNJ1AlTCVVIJO4VOvLuQP35fJv6FUEYr/vdkLw
	 RnF5PxVAjV65i1G1sQimC4fq2P5NWUic4SuWmUDNz3uMRG0wcQjmM1Zz8eWijemNih
	 R4PBqfCbZE03ItiylF5Znx8rRqTolhjY9k+TAIMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Gonda <pgonda@google.com>,
	Dionna Glaze <dionnaglaze@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 307/379] crypto: ccp - Name -1 return value as SEV_RET_NO_FW_CALL
Date: Wed, 15 Nov 2023 14:26:22 -0500
Message-ID: <20231115192703.312614009@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Gonda <pgonda@google.com>

[ Upstream commit efb339a83368ab25de1a18c0fdff85e01c13a1ea ]

The PSP can return a "firmware error" code of -1 in circumstances where
the PSP has not actually been called. To make this protocol unambiguous,
name the value SEV_RET_NO_FW_CALL.

  [ bp: Massage a bit. ]

Signed-off-by: Peter Gonda <pgonda@google.com>
Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20221207010210.2563293-2-dionnaglaze@google.com
Stable-dep-of: db10cb9b5746 ("virt: sevguest: Fix passing a stack buffer as a scatterlist target")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/virt/coco/sev-guest.rst | 4 ++--
 drivers/crypto/ccp/sev-dev.c          | 8 +++++---
 include/uapi/linux/psp-sev.h          | 7 +++++++
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
index bf593e88cfd9d..aa3e4c6a1f90c 100644
--- a/Documentation/virt/coco/sev-guest.rst
+++ b/Documentation/virt/coco/sev-guest.rst
@@ -40,8 +40,8 @@ along with a description:
 The guest ioctl should be issued on a file descriptor of the /dev/sev-guest device.
 The ioctl accepts struct snp_user_guest_request. The input and output structure is
 specified through the req_data and resp_data field respectively. If the ioctl fails
-to execute due to a firmware error, then fw_err code will be set otherwise the
-fw_err will be set to 0x00000000000000ff.
+to execute due to a firmware error, then fw_err code will be set. Otherwise, fw_err
+will be set to 0x00000000ffffffff, i.e., the lower 32-bits are -1.
 
 The firmware checks that the message sequence counter is one greater than
 the guests message sequence counter. If guest driver fails to increment message
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 3e583f0324874..b8e02c3a19610 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -443,10 +443,10 @@ static int __sev_init_ex_locked(int *error)
 
 static int __sev_platform_init_locked(int *error)
 {
+	int rc = 0, psp_ret = SEV_RET_NO_FW_CALL;
 	struct psp_device *psp = psp_master;
-	struct sev_device *sev;
-	int rc = 0, psp_ret = -1;
 	int (*init_function)(int *error);
+	struct sev_device *sev;
 
 	if (!psp || !psp->sev_data)
 		return -ENODEV;
@@ -474,9 +474,11 @@ static int __sev_platform_init_locked(int *error)
 		 * initialization function should succeed by replacing the state
 		 * with a reset state.
 		 */
-		dev_err(sev->dev, "SEV: retrying INIT command because of SECURE_DATA_INVALID error. Retrying once to reset PSP SEV state.");
+		dev_err(sev->dev,
+"SEV: retrying INIT command because of SECURE_DATA_INVALID error. Retrying once to reset PSP SEV state.");
 		rc = init_function(&psp_ret);
 	}
+
 	if (error)
 		*error = psp_ret;
 
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 91b4c63d5cbf4..1c9da485318f9 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -36,6 +36,13 @@ enum {
  * SEV Firmware status code
  */
 typedef enum {
+	/*
+	 * This error code is not in the SEV spec. Its purpose is to convey that
+	 * there was an error that prevented the SEV firmware from being called.
+	 * The SEV API error codes are 16 bits, so the -1 value will not overlap
+	 * with possible values from the specification.
+	 */
+	SEV_RET_NO_FW_CALL = -1,
 	SEV_RET_SUCCESS = 0,
 	SEV_RET_INVALID_PLATFORM_STATE,
 	SEV_RET_INVALID_GUEST_STATE,
-- 
2.42.0



