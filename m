Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91B1311967;
	Sat, 12 Sep 2026 14:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222812; cv=none; b=LAdh2b3+Cfy9O7RziS7yXqLu4pz+2UgpOx3uwM2/M8e6twPjbc48PtBqSvDJSJ3VcGZZgYxwDrTXLuN9FgxMAVii1PLnHgx7J9LQmbt2FCuS0man+tv1gp+UqSpObk2qm9P/RA/U/Yvy/oBUwp9tFSdcsMen2wW7nG/8qSEW19k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222812; c=relaxed/simple;
	bh=6KeKA2mTsM4NUH8hHbOeympeNjFU0U1hru3TNj5rGLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGtBXtBL/5j1MrzzKUKCAqzv6sxUlGmixt64tP1RKxHkwaFa1HvLZX/yk1VghW4pxQ7XHeho9LEazM2dTd46ronpaFDO8JIhRf6e+3W2NdX71InTg+n4FcVFUUTimGx6uZpx3s326U3QXNkSg7a9J9kf34rY+YOw+ssVZ2XnRtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbyt94tx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbyt94tx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828651F000FF;
	Sat, 12 Sep 2026 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222811;
	bh=2gata/JD7C+mb6dy3yB5gBrFO8yXWQ8sA1JxbuugV3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hbyt94txRYy1Hz1+XPBi2JhSD/atz28leZjkwPDNZ/Rz+rYLdPkaVimHDOCJLcOF1
	 glxMpJsnzJMJlbVdzzMhbOUl09azjjPVSzq1M8qP+lw4Dth1HtY5N0+bfuXdBfTZNB
	 vIDy4uocVeMTpSv6HCTVv92SYzKnln9BHO0RwNf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuvraj Singh Chauhan <ysinghcin@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0661/1424] staging: octeon: fix free_irq dev_id mismatch in cvm_oct_rx_shutdown
Date: Sat, 12 Sep 2026 08:51:33 +0200
Message-ID: <20260912065622.097439780@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuvraj Singh Chauhan <ysinghcin@gmail.com>

[ Upstream commit 41db5b76eeb4cc11a1097384caba7cfc659f7293 ]

In cvm_oct_rx_initialize(), request_irq() is called with
&oct_rx_group[i].napi as the dev_id:

	request_irq(oct_rx_group[i].irq, cvm_oct_do_interrupt, 0, "Ethernet",
							&oct_rx_group[i].napi);

However, cvm_oct_rx_shutdown() passes cvm_oct_device (an array of
struct net_device pointers) as the dev_id to free_irq():

  free_irq(oct_rx_group[i].irq, cvm_oct_device);

Since __free_irq() matches the action to remove by comparing
dev_id pointers, the mismatched cookie means the IRQ handler is
never found, triggering a WARN and leaving the IRQ line permanently
allocated. This prevents proper driver cleanup on module removal.

Fix the mismatch by passing &oct_rx_group[i].napi as the dev_id
to free_irq(), matching what was used during request_irq().

Signed-off-by: Yuvraj Singh Chauhan <ysinghcin@gmail.com>
Link: https://patch.msgid.link/20260212171903.1417804-1-ysinghcin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: c0a9a8586a63 ("staging: octeon: add missing napi_disable in cvm_oct_rx_shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/octeon/ethernet-rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 965330eec80a8..d0b43d50b83ce 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -535,7 +535,7 @@ void cvm_oct_rx_shutdown(void)
 			cvmx_write_csr(CVMX_POW_WQ_INT_THRX(i), 0);
 
 		/* Free the interrupt handler */
-		free_irq(oct_rx_group[i].irq, cvm_oct_device);
+		free_irq(oct_rx_group[i].irq, &oct_rx_group[i].napi);
 
 		netif_napi_del(&oct_rx_group[i].napi);
 	}
-- 
2.53.0



