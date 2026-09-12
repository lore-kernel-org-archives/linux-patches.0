Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0126830DEA6;
	Sat, 12 Sep 2026 11:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212442; cv=none; b=hJgOZvaIsCRBQCcPPq1m0BZA0N2mH/CHu4BAu3Ryw5rmtnUd3A7sqUei6aOIrqIn3keNNZ2ZB/+NB1xpzslUPhfUPj+8c+mllPb8tg/tyoBQXC+eQXLw016cP0tinDnTTfjVd/8CZ/pZXTckPffPU0Gyz/JwGdGPeVXckWQGvcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212442; c=relaxed/simple;
	bh=FGSHnqeYeSf6DvVmLQTuEMe6DhpRJMZks21Z0sD8Ysw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzSw1r3dpYZeIM8yDkiUkf/ESFfrnvigd/Bk/JoexQN/An57iTTJt0aPugmZaKyun7+28zFoxdZ/uBkl6k2AU6++xMO8zowQD7bg+9jA4ATz/q0O3gHReJQtzbWwL/JIv2+22ps5NqF9DdrC+0T+h3l53zK5h2nBuB0ZFvh6CpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p3yLQPoA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p3yLQPoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05ECC1F000FF;
	Sat, 12 Sep 2026 11:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212440;
	bh=fOEOFTUZgBPgpBoVIZZO16KpRKLzsglHy3qGVGhxyx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p3yLQPoAAjqDphV0iHr3EFy7rq6y+MjGClAwVdlG59N1linuBcaiqoIkzEPaZK1M9
	 CM9tCwZ1Aqp1MKuBHe//SEXABjdgX64C5up6BKFcKoyJCcbBZbzktb2P5ordonH0wt
	 EDiR9bSNLtdDd48t02hean8qoCrvE5tCnws5Bm+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1438/1518] net: wangxun: use BIT_ULL() to prevent shift overflow on 32-bit archs
Date: Sat, 12 Sep 2026 09:00:07 +0200
Message-ID: <20260912065656.084963788@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 0788cf57e3d4a..d66ea92aceade 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -1400,7 +1400,7 @@ struct wx {
 };
 
 #define WX_INTR_ALL (~0ULL)
-#define WX_INTR_Q(i) BIT((i))
+#define WX_INTR_Q(i) BIT_ULL((i))
 
 /* register operations */
 #define wr32(a, reg, value)	writel((value), ((a)->hw_addr + (reg)))
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 4d77da720eba1..70f89a42b0b30 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -302,7 +302,7 @@ struct txgbe_fdir_filter {
 #define TXGBE_DEFAULT_RX_WORK           128
 #endif
 
-#define TXGBE_INTR_MISC(A)    BIT((A)->num_q_vectors)
+#define TXGBE_INTR_MISC(A)    BIT_ULL((A)->num_q_vectors)
 #define TXGBE_INTR_QALL(A)    (TXGBE_INTR_MISC(A) - 1)
 
 #define TXGBE_MAX_EITR        GENMASK(11, 3)
-- 
2.53.0



