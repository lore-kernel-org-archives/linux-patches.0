Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062288;
	b=KIyaeQnd4njNkUkJxq6yh40b0+48qWlASjkY5D7QLQWVCGGgMDRc5aow4DqosqTdWqMU
	 ddKw8rKiOXRu2hOxjOhXlvOz8u19w2988NiG74gpNWIdxziTxlCUR40vJ4V+2DEK50PnQ
	 7CONVNKmrdQWx5/dwJhVZDcHBZbfFVmc1TGVM6KzQV1252R5MKSe1WYKAeZDpQCkJ21/S
	 GH5GwXkReQx/62s29vCttqfNWhVEGjw3bNAOKVxGXbPBGu9jD7AM/D2DLdovyQ/StKi0U
	 0ukJc522XQf5Hai6K3e/0mxkXLYxo6hS7SDSWPLri/n4iR65qWTg0COYP8Ji2AxACsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062288;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6dQ3Opl0dkD7Y2QtfCnDbY9xW/EuzjWJI9CqYsCig9g=;
	b=elCa3OxA6spNMNcpyPTu8BvI1fElCe2HFGkEmAiq2V4rqkILKSNTzUCwCrzZREQUQugu
	 cskfY4b/dODunbc7fro2SE6Av1/RERVXP92vc+5ef7SPUvHz+7pibS7CWftcruf7UJ5Hi
	 3DREWUcThVXz8f0sfv2R2V/OijZHSXFC2bpoaJh2rnAJOjQdNTdyVvBqLkCIMNslKwFr0
	 naNBbfEA80oNaH+6qv1PoS/1YRxnJkzJ8/gJg5vzPFUStB1dDpJ+Pb6cO9J2ax/py1uoy
	 9iX+ifqd1/rQYQ655mdp3WaKBpZ/kPXPTAPjdokzuMgm6Zzl1gtPe0ZoTZnvMMnZDlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=agUUCC2W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC34A606D816;
	Sat,  7 Nov 2026 14:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=agUUCC2W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0A31F0089F;
	Sat,  7 Nov 2026 14:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062287;
	bh=6dQ3Opl0dkD7Y2QtfCnDbY9xW/EuzjWJI9CqYsCig9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=agUUCC2WD4Zx9kSBfo5h26oPpgPz0NnxjOzShkL6Z3eaT0bWg80YOC/PG8nmKXkOl
	 QkBf8LmFc3dVUVo1gRqZUJDOBaFAi7Y+WCvIxt+4al3b/4Lgv9Zs+hrnHWW8cL1opa
	 STtLbS8k4Vd6fBB1IwJUDqnnpcLD+uSvV2diAok4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wayne Chang <waynec@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1225/1536] usb: typec: ucsi_ccg: Add retry mechanism in ccg_read
Date: Sat,  7 Nov 2026 08:54:01 -0500
Message-ID: <20261107135032.162732962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Chang <waynec@nvidia.com>

[ Upstream commit bbf6b99a57b2479bf51c3c8ad0946f4b8c33ed69 ]

CCG4 firmware occasionally fails to respond to I2C read requests,
especially when reading cci and intr_reg from the ISR path. In these
cases, i2c_transfer() returns -EREMOTEIO.

The CCG4 is EOL, and Infineon no longer supports firmware updates, so
a software workaround is necessary.

Attempt the read up to CCG_READ_MAX_RETRIES (4) times in total when
-EREMOTEIO is returned, sleeping ~1 ms via fsleep() between attempts.
This allows recovery from transient I2C failures without affecting
other error paths.

The sleep is safe because ccg_read() is called both from process
context and from ccg_irq_handler(), which runs in threaded IRQ
context (registered via request_threaded_irq() with a NULL hard-IRQ
handler), so sleeping is allowed in both cases.

Fixes: 247c554a14aa ("usb: typec: ucsi: add support for Cypress CCGx")
Cc: stable <stable@kernel.org>
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260916061858.1471606-1-waynec@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_ccg.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/ucsi/ucsi_ccg.c b/drivers/usb/typec/ucsi/ucsi_ccg.c
index 494472bd8ea3e..3a4e1b6f22ecf 100644
--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -134,6 +134,8 @@ struct version_format {
 #define NVIDIA_FTB_DP_OFFSET	(2)
 #define NVIDIA_FTB_DBG_OFFSET	(3)
 
+#define CCG_READ_MAX_RETRIES	4
+
 struct version_info {
 	struct version_format base;
 	struct version_format app;
@@ -255,6 +257,7 @@ static int ccg_read(struct ucsi_ccg *uc, u16 rab, u8 *data, u32 len)
 	};
 	u32 rlen, rem_len = len, max_read_len = len;
 	int status;
+	int retry_count;
 
 	/* check any max_read_len limitation on i2c adapter */
 	if (quirks && quirks->max_read_len)
@@ -266,7 +269,17 @@ static int ccg_read(struct ucsi_ccg *uc, u16 rab, u8 *data, u32 len)
 		rlen = min_t(u16, rem_len, max_read_len);
 		msgs[1].len = rlen;
 		put_unaligned_le16(rab, buf);
-		status = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
+
+		for (retry_count = 0; retry_count < CCG_READ_MAX_RETRIES; retry_count++) {
+			status = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
+
+			/* Only retry on -EREMOTEIO, and not after the last attempt */
+			if (status != -EREMOTEIO || retry_count == CCG_READ_MAX_RETRIES - 1)
+				break;
+
+			fsleep(1000);
+		}
+
 		if (status < 0) {
 			dev_err(uc->dev, "i2c_transfer failed %d\n", status);
 			pm_runtime_put_sync(uc->dev);
-- 
2.53.0



