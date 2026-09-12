Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9571D37AA92;
	Sat, 12 Sep 2026 09:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205264; cv=none; b=o48CzZBjqLH9Yh3p2jYCqRJ42g52tEHsmE3GzcwdCdJjiYmg5Q8/oRGyd9DfQP4s1PBXRPUX5M6SGbGgkttF4wJ5KJuJSdXaAXts919wE/yroSzswkMZD/IEurBXCTzGiFN+x50sn15I7xOXgO2xRRZdtc8pkJV0IvtoMUcbnLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205264; c=relaxed/simple;
	bh=2hjeaGWMIgt5A1Wzf2CVBGvgZVTqhbJu4EnaNmBaVqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDWkq7prPO2DfcnvAiqmQPagtUqU8tufqlkKp7a8pbPHaKpbpDsl3WAU5hXNIlpGLe62eDCdvRXodEQ0QF9Jm9NbD2Pw3pdZANJOrEfGfXoDPXI4fYMEaesbYs2n8hySTb/W2lOMRfnYpp8gy6oqYkL2mAt4KomvKgu6YoTDa28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=II2j898c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="II2j898c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6051F000FF;
	Sat, 12 Sep 2026 09:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205262;
	bh=kLMdRxOEmyMztT5CESC9x6wrd0WVy6AcROVaRpw3eTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=II2j898cKl2gu86Ee/eUQB8lyCJA/CxHscU0avaoaMJyzXlQyIL6/FRmIQ6goYO5s
	 SWwAicRrd78TWBn0MMEoo7/rY7FumpYNGzIbmPnLbkVsJUZtePiv6fSZcv6EwGhILC
	 ZqIQBvAzhwk53EOi+l71mnrYacsJc4hon+lLHzV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1780/1815] net: wangxun: use BIT_ULL() to prevent shift overflow on 32-bit archs
Date: Sat, 12 Sep 2026 08:58:50 +0200
Message-ID: <20260912065730.809533606@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit 63c885688f38a757947d7050b1ee4171215269ce ]

The macros TXGBE_INTR_MISC() and WX_INTR_Q() rely on the standard BIT()
macro to generate interrupt masks based on the queue vector index.

On 32-bit architectures, BIT() evaluates to a 32-bit `unsigned long`.
Since the number of queue vectors can be up to 63 on txgbe devices,
performing a left shift of 32 or more results in an integer overflow
and undefined behavior. This causes incorrect interrupt masking and
unmasking logic for both the queue and miscellaneous interrupts on
32-bit systems.

Fix this by replacing BIT() with BIT_ULL() in these macros. This
ensures that the bitwise shift is always performed safely on a 64-bit
`unsigned long long` type, regardless of the underlying architecture.

Fixes: e37546ad1f9b ("net: wangxun: revert the adjustment of the IRQ vector sequence")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Link: https://patch.msgid.link/45F5565CE6AC4329+20260824072119.48399-1-jiawenwu@trustnetic.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_type.h    | 2 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 65e3e55db1cff..0520288d18ab9 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -1427,7 +1427,7 @@ struct wx {
 };
 
 #define WX_INTR_ALL (~0ULL)
-#define WX_INTR_Q(i) BIT((i))
+#define WX_INTR_Q(i) BIT_ULL((i))
 
 /* register operations */
 #define wr32(a, reg, value)	writel((value), ((a)->hw_addr + (reg)))
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 877234e3fdc2b..fddcb011fa2fd 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -303,7 +303,7 @@ struct txgbe_fdir_filter {
 #define TXGBE_DEFAULT_RX_WORK           128
 #endif
 
-#define TXGBE_INTR_MISC(A)    BIT((A)->num_q_vectors)
+#define TXGBE_INTR_MISC(A)    BIT_ULL((A)->num_q_vectors)
 #define TXGBE_INTR_QALL(A)    (TXGBE_INTR_MISC(A) - 1)
 
 #define TXGBE_MAX_EITR        GENMASK(11, 3)
-- 
2.53.0



