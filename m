Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7351A2031E;
	Mon,  2 Oct 2023 20:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E1DC433C7;
	Mon,  2 Oct 2023 20:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696280149;
	bh=Q1qKRf7829BP3spx6wzuSzPIa3+B9A2QHQrz94APjcw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=JnVyaQFjOAYF9kKnvD6atZh4Gsv+WGVIgHI4FTN9lsnSPWdjUHS0pyK3Sn/5nVVOu
	 BeCn8DjaEr3Nwxt83lEyGKKSemRXwuVqbQbr3bodcTzbeY7Lpb3wKgb3FCiyA1YDG6
	 UB9qIrunaNT3UfZ00hmbdAKvrE8wLywnO7w/5il6ArEyfgyF5Mdj48ulPrUggOvsEn
	 wFsUj4UG/iqjFu1beA565zqMb44S7Sb9f2OhZm0LlR3lfT6qdbVu+/t8CuntGi62PI
	 WiN/UTpfSiUei92QirWNfwxx2pPi/dKe5TQmE59DWAc82+5GRO6g2C9ipd3OQETusI
	 E/zzVNzn532fQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 02 Oct 2023 13:55:20 -0700
Subject: [PATCH 1/2] ptp: Fix type of mode parameter in
 ptp_ocp_dpll_mode_get()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231002-net-wifpts-dpll_mode_get-v1-1-a356a16413cf@kernel.org>
References: <20231002-net-wifpts-dpll_mode_get-v1-0-a356a16413cf@kernel.org>
In-Reply-To: <20231002-net-wifpts-dpll_mode_get-v1-0-a356a16413cf@kernel.org>
To: davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
 pabeni@redhat.com, vadfed@fb.com
Cc: arkadiusz.kubalewski@intel.com, jiri@resnulli.us, 
 netdev@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>, richardcochran@gmail.com, 
 jonathan.lemon@gmail.com
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1867; i=nathan@kernel.org;
 h=from:subject:message-id; bh=Q1qKRf7829BP3spx6wzuSzPIa3+B9A2QHQrz94APjcw=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDKnSesFbTC0smU8wJRSxCU/huxa8+dq9e0VzC7yr5pxOv
 PGlzUyoo5SFQYyDQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAEwkdSvDP3XtHHWF7IcKJdUr
 ei8p9b1YuO5ZEr/Z1pBLh94saTY6dYXhn6WQDq/E181JqhUr7ib37ZlTrLkj7rTIojmdD6Ma26e
 t4gUA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building with -Wincompatible-function-pointer-types-strict, a
warning designed to catch potential kCFI failures at build time rather
than run time due to incorrect function pointer types, there is a
warning due to a mismatch between the type of the mode parameter in
ptp_ocp_dpll_mode_get() vs. what the function pointer prototype for
->mode_get() in 'struct dpll_device_ops' expects.

  drivers/ptp/ptp_ocp.c:4353:14: error: incompatible function pointer types initializing 'int (*)(const struct dpll_device *, void *, enum dpll_mode *, struct netlink_ext_ack *)' with an expression of type 'int (const struct dpll_device *, void *, u32 *, struct netlink_ext_ack *)' (aka 'int (const struct dpll_device *, void *, unsigned int *, struct netlink_ext_ack *)') [-Werror,-Wincompatible-function-pointer-types-strict]
   4353 |         .mode_get = ptp_ocp_dpll_mode_get,
        |                     ^~~~~~~~~~~~~~~~~~~~~
  1 error generated.

Change the type of the mode parameter in ptp_ocp_dpll_mode_get() to
clear up the warning and avoid kCFI failures at run time.

Fixes: 09eeb3aecc6c ("ptp_ocp: implement DPLL ops")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
To: richardcochran@gmail.com
To: jonathan.lemon@gmail.com
---
 drivers/ptp/ptp_ocp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 88d60a9b5731..07bc4f3de61d 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -4255,7 +4255,7 @@ static int ptp_ocp_dpll_state_get(const struct dpll_pin *pin, void *pin_priv,
 }
 
 static int ptp_ocp_dpll_mode_get(const struct dpll_device *dpll, void *priv,
-				 u32 *mode, struct netlink_ext_ack *extack)
+				 enum dpll_mode *mode, struct netlink_ext_ack *extack)
 {
 	*mode = DPLL_MODE_AUTOMATIC;
 	return 0;

-- 
2.42.0

