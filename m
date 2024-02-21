Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1879D80604;
	Wed, 21 Feb 2024 14:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524662; cv=none; b=BXZSjocNXi1Lu0qxx0fcbn0P0APom44/GgPHM28+oyRO+GO733ZuX8/ZfWUQqHz4Jf882ao6TmSj7hZsnyMJxB8Fwi2Dkua/ien9DtA9wvTGoQjL8cHJDPgvjph9CkXMopAOLFKm6PLtDM2jcQ44m/wE0oHk49i6l18FU+WVtGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524662; c=relaxed/simple;
	bh=0w9BCvqPwZHplDRgQC1/B4DX87UIOr/9MVNSfQBE82k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsJ+N9UXm9xV62frrXZuaF793OU9yZPFBk+pUgJjzteRGvvQ84oPcbTLOneAtk8YGPPPP7FtlsqnDmG1BcJUInPYjvkC7xBva6Nl8HwANjZyIEqea4HqyhVTHi2v01cI7jVS8e1jJpDCJ+Ge0C2ne3/V/lpTUIbcTNyLw8vdbM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6Ovp7Of; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6Ovp7Of"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877F0C433C7;
	Wed, 21 Feb 2024 14:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524662;
	bh=0w9BCvqPwZHplDRgQC1/B4DX87UIOr/9MVNSfQBE82k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6Ovp7OfH/TXWjrWq+SoOrwnxSUUKBJnxG2fsbqIRpq2uS0YTWZqMKZzpqx/BHIlU
	 WZp5IbCFhBEZTqMsqYGscTKW4IKbfqZKP5AGTQ3qQ76kM6RYXzrXotuDJPWAaLq5Wm
	 FQwu5yxqFJCzMqkvGVi2/cmIt6nalwBU2KLRl9fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	kernel test robot <lkp@intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 283/379] net: stmmac: xgmac: use #define for string constants
Date: Wed, 21 Feb 2024 14:07:42 +0100
Message-ID: <20240221130003.282579251@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Horman <horms@kernel.org>

commit 1692b9775e745f84b69dc8ad0075b0855a43db4e upstream.

The cited commit introduces and uses the string constants dpp_tx_err and
dpp_rx_err. These are assigned to constant fields of the array
dwxgmac3_error_desc.

It has been reported that on GCC 6 and 7.5.0 this results in warnings
such as:

  .../dwxgmac2_core.c:836:20: error: initialiser element is not constant
   { true, "TDPES0", dpp_tx_err },

I have been able to reproduce this using: GCC 7.5.0, 8.4.0, 9.4.0 and 10.5.0.
But not GCC 13.2.0.

So it seems this effects older compilers but not newer ones.
As Jon points out in his report, the minimum compiler supported by
the kernel is GCC 5.1, so it does seem that this ought to be fixed.

It is not clear to me what combination of 'const', if any, would address
this problem.  So this patch takes of using #defines for the string
constants

Compile tested only.

Fixes: 46eba193d04f ("net: stmmac: xgmac: fix handling of DPP safety error for DMA channels")
Reported-by: Jon Hunter <jonathanh@nvidia.com>
Closes: https://lore.kernel.org/netdev/c25eb595-8d91-40ea-9f52-efa15ebafdbc@nvidia.com/
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202402081135.lAxxBXHk-lkp@intel.com/
Signed-off-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240208-xgmac-const-v1-1-e69a1eeabfc8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c |   69 ++++++++++----------
 1 file changed, 35 insertions(+), 34 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -788,41 +788,42 @@ static const struct dwxgmac3_error_desc
 	{ false, "UNKNOWN", "Unknown Error" }, /* 31 */
 };
 
-static const char * const dpp_rx_err = "Read Rx Descriptor Parity checker Error";
-static const char * const dpp_tx_err = "Read Tx Descriptor Parity checker Error";
+#define DPP_RX_ERR "Read Rx Descriptor Parity checker Error"
+#define DPP_TX_ERR "Read Tx Descriptor Parity checker Error"
+
 static const struct dwxgmac3_error_desc dwxgmac3_dma_dpp_errors[32] = {
-	{ true, "TDPES0", dpp_tx_err },
-	{ true, "TDPES1", dpp_tx_err },
-	{ true, "TDPES2", dpp_tx_err },
-	{ true, "TDPES3", dpp_tx_err },
-	{ true, "TDPES4", dpp_tx_err },
-	{ true, "TDPES5", dpp_tx_err },
-	{ true, "TDPES6", dpp_tx_err },
-	{ true, "TDPES7", dpp_tx_err },
-	{ true, "TDPES8", dpp_tx_err },
-	{ true, "TDPES9", dpp_tx_err },
-	{ true, "TDPES10", dpp_tx_err },
-	{ true, "TDPES11", dpp_tx_err },
-	{ true, "TDPES12", dpp_tx_err },
-	{ true, "TDPES13", dpp_tx_err },
-	{ true, "TDPES14", dpp_tx_err },
-	{ true, "TDPES15", dpp_tx_err },
-	{ true, "RDPES0", dpp_rx_err },
-	{ true, "RDPES1", dpp_rx_err },
-	{ true, "RDPES2", dpp_rx_err },
-	{ true, "RDPES3", dpp_rx_err },
-	{ true, "RDPES4", dpp_rx_err },
-	{ true, "RDPES5", dpp_rx_err },
-	{ true, "RDPES6", dpp_rx_err },
-	{ true, "RDPES7", dpp_rx_err },
-	{ true, "RDPES8", dpp_rx_err },
-	{ true, "RDPES9", dpp_rx_err },
-	{ true, "RDPES10", dpp_rx_err },
-	{ true, "RDPES11", dpp_rx_err },
-	{ true, "RDPES12", dpp_rx_err },
-	{ true, "RDPES13", dpp_rx_err },
-	{ true, "RDPES14", dpp_rx_err },
-	{ true, "RDPES15", dpp_rx_err },
+	{ true, "TDPES0", DPP_TX_ERR },
+	{ true, "TDPES1", DPP_TX_ERR },
+	{ true, "TDPES2", DPP_TX_ERR },
+	{ true, "TDPES3", DPP_TX_ERR },
+	{ true, "TDPES4", DPP_TX_ERR },
+	{ true, "TDPES5", DPP_TX_ERR },
+	{ true, "TDPES6", DPP_TX_ERR },
+	{ true, "TDPES7", DPP_TX_ERR },
+	{ true, "TDPES8", DPP_TX_ERR },
+	{ true, "TDPES9", DPP_TX_ERR },
+	{ true, "TDPES10", DPP_TX_ERR },
+	{ true, "TDPES11", DPP_TX_ERR },
+	{ true, "TDPES12", DPP_TX_ERR },
+	{ true, "TDPES13", DPP_TX_ERR },
+	{ true, "TDPES14", DPP_TX_ERR },
+	{ true, "TDPES15", DPP_TX_ERR },
+	{ true, "RDPES0", DPP_RX_ERR },
+	{ true, "RDPES1", DPP_RX_ERR },
+	{ true, "RDPES2", DPP_RX_ERR },
+	{ true, "RDPES3", DPP_RX_ERR },
+	{ true, "RDPES4", DPP_RX_ERR },
+	{ true, "RDPES5", DPP_RX_ERR },
+	{ true, "RDPES6", DPP_RX_ERR },
+	{ true, "RDPES7", DPP_RX_ERR },
+	{ true, "RDPES8", DPP_RX_ERR },
+	{ true, "RDPES9", DPP_RX_ERR },
+	{ true, "RDPES10", DPP_RX_ERR },
+	{ true, "RDPES11", DPP_RX_ERR },
+	{ true, "RDPES12", DPP_RX_ERR },
+	{ true, "RDPES13", DPP_RX_ERR },
+	{ true, "RDPES14", DPP_RX_ERR },
+	{ true, "RDPES15", DPP_RX_ERR },
 };
 
 static void dwxgmac3_handle_dma_err(struct net_device *ndev,


