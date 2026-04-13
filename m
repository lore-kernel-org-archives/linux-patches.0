Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A310E27BF6C;
	Mon, 13 Apr 2026 16:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096462; cv=none; b=ffY3yCK8w0bu8Pn7BkaYlNVAYymLAH95rvJ4STbc07GkwPFyCz+9TTXi2mVWbOky4NCzMjEp8qZxI3mjJItvGgeR2AIR2ADjNE3eWKEuBxCxC17Ny3mtsL+MePSGc/DCi3OoeJLJkykZhToUOM/EySBTNmWTHf1qfw85O+bvZhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096462; c=relaxed/simple;
	bh=qeeM9TvMdxIWGmRxto4zHXXiGHVqHaf3qBr9XGVY3ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vErvRfBn+VxnXvpLO0Oa2m4uwbZczsyX5xOOhTQT1sG03+rrZGZZXENQkN8fveQB5ffV2l9SY0/OxvhVqg6/7d77KjSAO6dTwNV9vNVZVlQ2aaFSwyt6agAv+klfgBAbMtPe1XUeuwIIKc7bjHZFlrTGtddtrVpxMG8uFOTuO4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVnEw5+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVnEw5+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385FAC2BCAF;
	Mon, 13 Apr 2026 16:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096462;
	bh=qeeM9TvMdxIWGmRxto4zHXXiGHVqHaf3qBr9XGVY3ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVnEw5+D0qCfaItoEo0MEqs1yz3S0Pkpd/Y7wf6aj7KSXWhbQ8GmsKgmmfHpsqP5o
	 epcRe2pzIfLdtLVB1DRyMMCA7k193pv9pcbR4V1DGn+wcTV7NXnvOaHbjPtklVOgnM
	 uWcllX1aZFj3wDK+OfOqDNDHv8RGl/QgGx0N7GJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Michal Wilczynski <m.wilczynski@samsung.com>,
	Drew Fustini <fustini@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.18 21/83] firmware: thead: Fix buffer overflow and use standard endian macros
Date: Mon, 13 Apr 2026 17:59:49 +0200
Message-ID: <20260413155731.815286683@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wilczynski <m.wilczynski@samsung.com>

commit 88c4bd90725557796c15878b7cb70066e9e6b5ab upstream.

Addresses two issues in the TH1520 AON firmware protocol driver:

1. Fix a potential buffer overflow where the code used unsafe pointer
   arithmetic to access the 'mode' field through the 'resource' pointer
   with an offset. This was flagged by Smatch static checker as:
   "buffer overflow 'data' 2 <= 3"

2. Replace custom RPC_SET_BE* and RPC_GET_BE* macros with standard
   kernel endianness conversion macros (cpu_to_be16, etc.) for better
   portability and maintainability.

The functionality was re-tested with the GPU power-up sequence,
confirming the GPU powers up correctly and the driver probes
successfully.

[   12.702370] powervr ffef400000.gpu: [drm] loaded firmware
powervr/rogue_36.52.104.182_v1.fw
[   12.711043] powervr ffef400000.gpu: [drm] FW version v1.0 (build
6645434 OS)
[   12.719787] [drm] Initialized powervr 1.0.0 for ffef400000.gpu on
minor 0

Fixes: e4b3cbd840e5 ("firmware: thead: Add AON firmware protocol driver")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/17a0ccce-060b-4b9d-a3c4-8d5d5823b1c9@stanley.mountain/
Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Drew Fustini <fustini@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/thead,th1520-aon.c             |    7 --
 include/linux/firmware/thead/thead,th1520-aon.h |   74 ------------------------
 2 files changed, 3 insertions(+), 78 deletions(-)

--- a/drivers/firmware/thead,th1520-aon.c
+++ b/drivers/firmware/thead,th1520-aon.c
@@ -170,10 +170,9 @@ int th1520_aon_power_update(struct th152
 	hdr->func = TH1520_AON_PM_FUNC_SET_RESOURCE_POWER_MODE;
 	hdr->size = TH1520_AON_RPC_MSG_NUM;
 
-	RPC_SET_BE16(&msg.resource, 0, rsrc);
-	RPC_SET_BE16(&msg.resource, 2,
-		     (power_on ? TH1520_AON_PM_PW_MODE_ON :
-				 TH1520_AON_PM_PW_MODE_OFF));
+	msg.resource = cpu_to_be16(rsrc);
+	msg.mode = cpu_to_be16(power_on ? TH1520_AON_PM_PW_MODE_ON :
+					  TH1520_AON_PM_PW_MODE_OFF);
 
 	ret = th1520_aon_call_rpc(aon_chan, &msg);
 	if (ret)
--- a/include/linux/firmware/thead/thead,th1520-aon.h
+++ b/include/linux/firmware/thead/thead,th1520-aon.h
@@ -97,80 +97,6 @@ struct th1520_aon_rpc_ack_common {
 #define RPC_GET_SVC_FLAG_ACK_TYPE(MESG) (((MESG)->svc & 0x40) >> 6)
 #define RPC_SET_SVC_FLAG_ACK_TYPE(MESG, ACK) ((MESG)->svc |= (ACK) << 6)
 
-#define RPC_SET_BE64(MESG, OFFSET, SET_DATA)                                \
-	do {                                                                \
-		u8 *data = (u8 *)(MESG);                                    \
-		u64 _offset = (OFFSET);                                     \
-		u64 _set_data = (SET_DATA);                                 \
-		data[_offset + 7] = _set_data & 0xFF;                       \
-		data[_offset + 6] = (_set_data & 0xFF00) >> 8;              \
-		data[_offset + 5] = (_set_data & 0xFF0000) >> 16;           \
-		data[_offset + 4] = (_set_data & 0xFF000000) >> 24;         \
-		data[_offset + 3] = (_set_data & 0xFF00000000) >> 32;       \
-		data[_offset + 2] = (_set_data & 0xFF0000000000) >> 40;     \
-		data[_offset + 1] = (_set_data & 0xFF000000000000) >> 48;   \
-		data[_offset + 0] = (_set_data & 0xFF00000000000000) >> 56; \
-	} while (0)
-
-#define RPC_SET_BE32(MESG, OFFSET, SET_DATA)			    \
-	do {							    \
-		u8 *data = (u8 *)(MESG);			    \
-		u64 _offset = (OFFSET);				    \
-		u64 _set_data = (SET_DATA);			    \
-		data[_offset + 3] = (_set_data) & 0xFF;		    \
-		data[_offset + 2] = (_set_data & 0xFF00) >> 8;	    \
-		data[_offset + 1] = (_set_data & 0xFF0000) >> 16;   \
-		data[_offset + 0] = (_set_data & 0xFF000000) >> 24; \
-	} while (0)
-
-#define RPC_SET_BE16(MESG, OFFSET, SET_DATA)		       \
-	do {						       \
-		u8 *data = (u8 *)(MESG);		       \
-		u64 _offset = (OFFSET);			       \
-		u64 _set_data = (SET_DATA);		       \
-		data[_offset + 1] = (_set_data) & 0xFF;	       \
-		data[_offset + 0] = (_set_data & 0xFF00) >> 8; \
-	} while (0)
-
-#define RPC_SET_U8(MESG, OFFSET, SET_DATA)	  \
-	do {					  \
-		u8 *data = (u8 *)(MESG);	  \
-		data[OFFSET] = (SET_DATA) & 0xFF; \
-	} while (0)
-
-#define RPC_GET_BE64(MESG, OFFSET, PTR)                                      \
-	do {                                                                 \
-		u8 *data = (u8 *)(MESG);                                     \
-		u64 _offset = (OFFSET);                                      \
-		*(u32 *)(PTR) =                                              \
-			(data[_offset + 7] | data[_offset + 6] << 8 |        \
-			 data[_offset + 5] << 16 | data[_offset + 4] << 24 | \
-			 data[_offset + 3] << 32 | data[_offset + 2] << 40 | \
-			 data[_offset + 1] << 48 | data[_offset + 0] << 56); \
-	} while (0)
-
-#define RPC_GET_BE32(MESG, OFFSET, PTR)                                      \
-	do {                                                                 \
-		u8 *data = (u8 *)(MESG);                                     \
-		u64 _offset = (OFFSET);                                      \
-		*(u32 *)(PTR) =                                              \
-			(data[_offset + 3] | data[_offset + 2] << 8 |        \
-			 data[_offset + 1] << 16 | data[_offset + 0] << 24); \
-	} while (0)
-
-#define RPC_GET_BE16(MESG, OFFSET, PTR)                                       \
-	do {                                                                  \
-		u8 *data = (u8 *)(MESG);                                      \
-		u64 _offset = (OFFSET);                                       \
-		*(u16 *)(PTR) = (data[_offset + 1] | data[_offset + 0] << 8); \
-	} while (0)
-
-#define RPC_GET_U8(MESG, OFFSET, PTR)          \
-	do {                                   \
-		u8 *data = (u8 *)(MESG);       \
-		*(u8 *)(PTR) = (data[OFFSET]); \
-	} while (0)
-
 /*
  * Defines for SC PM Power Mode
  */


