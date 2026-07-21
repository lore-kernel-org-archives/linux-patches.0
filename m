Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F85A46D565;
	Tue, 21 Jul 2026 18:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657988; cv=none; b=brCOCXF/Z6ADp+QWdDaXMI2FxN58A5V/x9br4DXE9M4GR3y12xRFK0+cwVx7mUemyGGoxtLb5Zp+LM8EsmHXVNlCh1nfz0jEsGtn3s1PIaF/9xjk7f86SYdr8WwrLDfEG0pvZrh6/FXz9l3Jn99LtARlkNrjL2fqRraEAOT+abY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657988; c=relaxed/simple;
	bh=q2c3Ml5H4JGS4KeXUx31EiLVIEXHSS3JUF2OgHzgknk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOBOPRSGAXwjeRnGMevBbTBQTfqFyy1tjMPVPuMzyz4BFZNMbPN7gQiOPvheRRzzqliCw8GBoaQibTEBnEsvPQoQVmQIR2+m0K4UPjBFf9LyGz3CYgOje70s5A9kgcPYg40Dvn1MdN1oHHvyurL//X0EveypsHMSLtn2lxAs380=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtYEvDYJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtYEvDYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1EA1F000E9;
	Tue, 21 Jul 2026 18:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657987;
	bh=DSLpAVkbaR6N7JHivS0a4GuYk8NJ+3o+0dM4cNr8M+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gtYEvDYJLGpapCyBv1j3heGEfZQtgRTd7B4ksnSC6wbPfOCHoZrXJ9i/5Oehnat8I
	 T4V4Hmsht8kR3MubheYLGxHQTmy+KuYPW56b0XJrjREO84HrDGDbeYpl6uYtRbtzQd
	 yh+VSav1efyF0+MxYUW9bano4kIy93TNoPkXArOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0971/1611] net: libwx: fix VMDQ mask for 1-queue mode
Date: Tue, 21 Jul 2026 17:18:07 +0200
Message-ID: <20260721152537.234326068@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 3adf7048320aee..678dce480f156e 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1745,6 +1745,7 @@ static bool wx_set_vmdq_queues(struct wx *wx)
 			rss_i = 4;
 		}
 	} else {
+		vmdq_m = WX_VMDQ_1Q_MASK;
 		/* double check we are limited to maximum pools */
 		vmdq_i = min_t(u16, 8, vmdq_i);
 
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index f040b014f2dd74..12bb1e19d88d40 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -471,6 +471,7 @@ enum WX_MSCA_CMD_value {
 
 #define WX_VMDQ_4Q_MASK              0x7C
 #define WX_VMDQ_2Q_MASK              0x7E
+#define WX_VMDQ_1Q_MASK              0x7F
 
 /****************** Manageablility Host Interface defines ********************/
 #define WX_HI_MAX_BLOCK_BYTE_LENGTH  256 /* Num of bytes in range */
-- 
2.53.0



