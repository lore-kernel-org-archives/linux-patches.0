Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76132D023;
	Mon, 10 Mar 2025 17:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629395; cv=none; b=h5rdCAXwn73SxfEsKlGoHvQVetuTeHzg0M23/y6jnMyif2eCewI6UpOBPH2PBQebQDcLzIOAqO+VGKogIMUSDatGvM7P+epMTYUL5F5DbogcySk/QHS6RzHj4svqDejBpHTAATSxI5UEPUeDRC6w0VeuqlvlMrkA6jDb+XN+emU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629395; c=relaxed/simple;
	bh=Q4SqQ0CJea3zxR0OnPBuWLR/UoiNpPqU4/swG4OTgIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtInhz7tB7IrzGnFYSZVB0t3ltmm3VM0JeBYC7txyaJTZOpR97nJzydWXekErRWjMAbS5LbhsFyab/As5eUruMD+1qvFIzAu14LJfEPrkS1mLHCbrtIlDaMHuMRkuZnLPzZ752QKtChfyzWpVtY1xrrtN93/k2nk9pxCXbteRIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H13tKzMW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H13tKzMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A77C4CEE5;
	Mon, 10 Mar 2025 17:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629394;
	bh=Q4SqQ0CJea3zxR0OnPBuWLR/UoiNpPqU4/swG4OTgIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H13tKzMWO5yL75oFqSJBF7KIAN3YM7dRYzc5UUEjwOJwyB14mWpPWs4xqsR8rbc64
	 BCZ0lcK8oeYONqeLJX8zfCBgnhQqH/eQVe1eJCCoquf5kCWZvn6E6a2SWqcKS9y6v9
	 WgXUOaPodjuBVD9t7ybGsf4f1IhhfwqnvFp5B2H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 5.15 278/620] wifi: rtlwifi: rtl8821ae: Fix media status report
Date: Mon, 10 Mar 2025 18:02:04 +0100
Message-ID: <20250310170556.590817300@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

commit 66ef0289ac99e155d206ddaa0fdfad09ae3cd007 upstream.

RTL8821AE is stuck transmitting at the lowest rate allowed by the rate
mask. This is because the firmware doesn't know the device is connected
to a network.

Fix the macros SET_H2CCMD_MSRRPT_PARM_OPMODE and
SET_H2CCMD_MSRRPT_PARM_MACID_IND to work on the first byte of __cmd,
not the second. Now the firmware is correctly notified when the device
is connected to a network and it activates the rate control.

Before (MCS3):

[  5]   0.00-1.00   sec  12.5 MBytes   105 Mbits/sec    0    339 KBytes
[  5]   1.00-2.00   sec  10.6 MBytes  89.1 Mbits/sec    0    339 KBytes
[  5]   2.00-3.00   sec  10.6 MBytes  89.1 Mbits/sec    0    386 KBytes
[  5]   3.00-4.00   sec  10.6 MBytes  89.1 Mbits/sec    0    386 KBytes
[  5]   4.00-5.00   sec  10.2 MBytes  86.0 Mbits/sec    0    427 KBytes

After (MCS9):

[  5]   0.00-1.00   sec  33.9 MBytes   284 Mbits/sec    0    771 KBytes
[  5]   1.00-2.00   sec  31.6 MBytes   265 Mbits/sec    0    865 KBytes
[  5]   2.00-3.00   sec  29.9 MBytes   251 Mbits/sec    0    963 KBytes
[  5]   3.00-4.00   sec  28.2 MBytes   237 Mbits/sec    0    963 KBytes
[  5]   4.00-5.00   sec  26.8 MBytes   224 Mbits/sec    0    963 KBytes

Fixes: 39f40710d0b5 ("rtlwifi: rtl88821ae: Remove usage of private bit manipulation macros")
Cc: stable@vger.kernel.org
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/754785b3-8a78-4554-b80d-de5f603b410b@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.h
@@ -197,9 +197,9 @@ enum rtl8821a_h2c_cmd {
 
 /* _MEDIA_STATUS_RPT_PARM_CMD1 */
 #define SET_H2CCMD_MSRRPT_PARM_OPMODE(__cmd, __value)	\
-	u8p_replace_bits(__cmd + 1, __value, BIT(0))
+	u8p_replace_bits(__cmd, __value, BIT(0))
 #define SET_H2CCMD_MSRRPT_PARM_MACID_IND(__cmd, __value)	\
-	u8p_replace_bits(__cmd + 1, __value, BIT(1))
+	u8p_replace_bits(__cmd, __value, BIT(1))
 
 /* AP_OFFLOAD */
 #define SET_H2CCMD_AP_OFFLOAD_ON(__cmd, __value)	\


