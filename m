Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9756B3F23D5;
	Wed, 20 May 2026 17:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297255; cv=none; b=WEgoKSitgFuLa645zEKhTGQwWuLaAmw0xTwGSklUjfeCdGko1xVT7b3tOMpJa2pwONTRN/1s/RDuWnKV/6FyNkxIl7mcs4gHGgxZuQKOIBaWJLnmZMtFphFom//jf51A9fhfxBfLzLr+72wmUWm/Qwv80nLb0rB137+E96clxYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297255; c=relaxed/simple;
	bh=wyvc/ssxtaNeeHsg0mrT1OpINQB6xK0gNjFg+faLeiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StRzWbFu9V9urAQ6VT6w4IePfMjUkWs5pNfLMfe5uVy6cwCkmULsUq3f4MfB1gduZt8tVNJyZeW105t67JoUNJaANjMMIWlwV4MwS8W7Er32pEDtcMtGU/J/qj0mkEnm7DCgXTZv+bbKJPOe2pFdC4PALlvtRnANxNL98Nxweto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLQzrrHL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLQzrrHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087EB1F000E9;
	Wed, 20 May 2026 17:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297254;
	bh=meYMvZsQYilu7mkM0bpgjG6W1QwzUXeBgZuCemwwhNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLQzrrHLS0knnPwqW97hzUGur85hqk+cdx7NrpAKxtTcnBhJmbwFOsZboE6Uf15jp
	 S97v8h9qxHEDYe4q1b47TPhA9VsAM3HVjZj0wZzlPfpzNM2nzEV72M27fNXkr37ZKY
	 qhezwhfHMFPqoJN35pDawfm/lUpFWTbMiouCztOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.0 1109/1146] irqchip/riscv-imsic: Clear interrupt move state during CPU offlining
Date: Wed, 20 May 2026 18:22:39 +0200
Message-ID: <20260520162213.343065074@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yong-Xuan Wang <yongxuan.wang@sifive.com>

commit cefafbd561402b0fe6447449364a30315b9b1570 upstream.

Affinity changes of IMSIC interrupts have to be careful to not lose an
interrupt in the process. Each vector keeps track of an affinity change in
progress with two pointers in struct imsic_vector.

imsic_vector::move_prev points to the previous CPU target data and
imsic_vector::move_next to the designated new CPU target data.

imsic_vector::move_prev on the new CPU can only be cleared after the
previous CPU has cleared imsic_vector::move_next, which ususally happens in
__imsic_remote_sync().

In case of CPU hot-unplug __imsic_remote_sync() is not invoked because the
CPU is already marked offline. That means imsic_vector::move_prev becomes
stale until the CPU is onlined again.

The stale pointer prevents further affinity changes for the affected
interrupts.

Solve this by clearing the imsic_vector::move_prev pointers in the CPU
hotplug offline path.

[ tglx: Replace word salad in change log ]

Fixes: 0f67911e821c ("irqchip/riscv-imsic: Separate next and previous pointers in IMSIC vector")
Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260508-imsic-v2-1-e9f08dd46cf5@sifive.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-riscv-imsic-early.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/irqchip/irq-riscv-imsic-early.c
+++ b/drivers/irqchip/irq-riscv-imsic-early.c
@@ -158,6 +158,8 @@ static int imsic_dying_cpu(unsigned int
 	/* Cleanup IPIs */
 	imsic_ipi_dying_cpu();
 
+	imsic_local_sync_all(false);
+
 	/* Mark per-CPU IMSIC state as offline */
 	imsic_state_offline();
 


