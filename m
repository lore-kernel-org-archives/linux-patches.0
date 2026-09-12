Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E779D370AFD;
	Sat, 12 Sep 2026 13:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219269; cv=none; b=SbOyVJU53LLSMRuDcuawdEt+okvD9AfYDVyGw1IXnAQ+S4EPTGbXAkmBf//hqfG8sFQ66X1G7qw7dNuPAP8aOJ0qyiyuJ7MPCeKzJ3QxwRSKnVMixEZcEC4bBM0Oc1xKHVd3C/yWneQRJaz+qgVIntq7KHiw6jDhW1YMJNFCjYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219269; c=relaxed/simple;
	bh=LRI0Zs3Po7btUZYnnRErAlXQ1YgnrReIWV7IGe9iaLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6pMU0vw1l/sVg1mevaa6us7EskvtrH5N9q1amF4TXgCYEF60UQzhpomBdXoCZUB80io6UUSMFldW1xeu68TRONUBxwAL1vuotKylkBog37bZn/m9OyKY3qN63J+mE49/iMrefu6ye9m2EHOzH/ZkiVs0/xYcN+eTpMSSiziz1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k40CBZGb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k40CBZGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B5D1F000FF;
	Sat, 12 Sep 2026 13:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219267;
	bh=sQ+H/5IqeaXKC1gHAo2v0x6hyIV7VQAv8RAusGkYt8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k40CBZGbRrJdiMugzvO5Mzt+BVvivhCTf2vSQEbn0WE8wGF2nxCeptWZ34X96IGiR
	 2J4dO9vUUZjXTTo+WUWfz/c75dXDx96XmhDEhuFNSsvj5RoymRz3OULjFz6vhIdGtJ
	 baep4hOhhICtRhnc4LWA1ojy2MXBiUYoPwPVDYSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1316/1376] net: wangxun: use BIT_ULL() to prevent shift overflow on 32-bit archs
Date: Sat, 12 Sep 2026 09:02:22 +0200
Message-ID: <20260912065636.863115120@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 627dcb0151c78..96839972d1f65 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -1134,7 +1134,7 @@ struct wx {
 };
 
 #define WX_INTR_ALL (~0ULL)
-#define WX_INTR_Q(i) BIT((i))
+#define WX_INTR_Q(i) BIT_ULL((i))
 
 /* register operations */
 #define wr32(a, reg, value)	writel((value), ((a)->hw_addr + (reg)))
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 27f8db89a5c7e..c8981c27340c5 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -264,7 +264,7 @@ struct txgbe_fdir_filter {
 #define TXGBE_DEFAULT_RX_WORK           128
 #endif
 
-#define TXGBE_INTR_MISC(A)    BIT((A)->num_q_vectors)
+#define TXGBE_INTR_MISC(A)    BIT_ULL((A)->num_q_vectors)
 #define TXGBE_INTR_QALL(A)    (TXGBE_INTR_MISC(A) - 1)
 
 #define TXGBE_MAX_EITR        GENMASK(11, 3)
-- 
2.53.0



