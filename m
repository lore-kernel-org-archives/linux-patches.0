Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC02637B40C;
	Tue, 21 Jul 2026 17:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653458; cv=none; b=Sz8vFG5QPXvEcIHmwH89jLdox2AleCEWwo2CoeYCLkIc2k6dx5mjM5s1aYfGdTMkVSB4U7GoF7qpt45dpprcf8VB3FfW/gZK+CGDiNOD0aGk+kqhURuxawCWRPCwVi4MpQjUpUHGTwYaF4GAGy/AsugZDiL3VnHtpasZEwPqOKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653458; c=relaxed/simple;
	bh=txnQytQ4gulm2yoSVxJmlC55DeriXYBDVIX2eBw/WNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jwz4gKCPGipQOT5SzDL17MBcu/GQ5Y7AHCBfjBHaBo7Ke+q1NSJEC3ioQTff1DHQCRkviwCuw5ocJGSQlQ5t9hoYRloT1zqTuVCehJHsfbRby6GDHr5tkqdRdXcGnaDYL2FN5Mw7oocF0Qs6yY1XrsBZ5Ut/z+9pej5VyKIUdcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0n8pYh8e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0n8pYh8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EAFD1F00A3A;
	Tue, 21 Jul 2026 17:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653456;
	bh=GG991cleHDdbq3RZOcmLvHMX3qsoSx184uwvsSBxmaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0n8pYh8eq8NffHhNPuGifc2/p2XuBj8oOfWvi4B8i0+V/TaU3MaQTf7t2P1xxVJ2I
	 WkSxX2M+1N3waOZb6SyLaGobpIJwAFNa+hP7MmxTjfWkAz3ryONRa2XPQQt9uTEphn
	 ZIuHQRE4zQSq2ETkklhkRb49J7slxkepIl2iPrXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1332/2077] net: libwx: fix VMDQ mask for 1-queue mode
Date: Tue, 21 Jul 2026 17:16:45 +0200
Message-ID: <20260721152624.232447431@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit 6ab752e0b59b825c127d5c86438bee1e8b1641ea ]

In wx_set_vmdq_queues(), the VMDQ mask was not set for the devices not
supporting WX_FLAG_MULTI_64_FUNC, i.e., NGBE devices. A mask of 0 causes
__ALIGN_MASK(1, ~vmdq->mask) to return 0, which incorrectly sets
q_per_pool to 0 in wx_write_qde().

Fix the VMDQ 1-queue mask to 0x7F then ensures that __ALIGN_MASK(1,
~0x7F) correctly evaluates to 1.

Fixes: c52d4b898901 ("net: libwx: Redesign flow when sriov is enabled")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Link: https://patch.msgid.link/161F704D2C983E2C+20260626092530.551028-1-jiawenwu@trustnetic.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c  | 1 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 746623fa59b40d..5c2cd5756f8a97 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1802,6 +1802,7 @@ static bool wx_set_vmdq_queues(struct wx *wx)
 			rss_i = 4;
 		}
 	} else {
+		vmdq_m = WX_VMDQ_1Q_MASK;
 		/* double check we are limited to maximum pools */
 		vmdq_i = min_t(u16, 8, vmdq_i);
 
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 0da5565ee4ffa6..1b3dc2a808f904 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -486,6 +486,7 @@ enum WX_MSCA_CMD_value {
 
 #define WX_VMDQ_4Q_MASK              0x7C
 #define WX_VMDQ_2Q_MASK              0x7E
+#define WX_VMDQ_1Q_MASK              0x7F
 
 /****************** Manageablility Host Interface defines ********************/
 #define WX_HI_MAX_BLOCK_BYTE_LENGTH  256 /* Num of bytes in range */
-- 
2.53.0



