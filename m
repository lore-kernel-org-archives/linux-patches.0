Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C215B28312F;
	Mon,  9 Feb 2026 14:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648907; cv=none; b=CX5ZFpuovZc3/zKaRSEPcFPXeU/r0cEJ56fdpXEoB0hkyaUyzmqA/4QjFQ/3hIj5Gs0Kb97q2u4G6wYUjYzOHXuqWB0aGahyYrzIiHThFm+16ePhzAC8YTVEdSPnaULr74lsxlRUKeY44eHjPbhCz+FG+wav74ALlTGkQsXDTkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648907; c=relaxed/simple;
	bh=SH+SibIqnc74Rfp9InqRF28zG9b3mNOyWJFZ/1cpycw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2Fp/YJGbqUJ2FqpbXHfQrhgYhEWz0MAndp6x2SdkfqSnlcIuQYWjBlgz/FW0XwFEHXtiitSYJkJURpzNTxOglF0qqacDtMXeSSKxvL5KmUjG6yD562mf7k1N08SMaDt31F7qN1GMInt67zrth59toqaQyDLQiDkOAFHp/sVhY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pL/7WrT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pL/7WrT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CB3C116C6;
	Mon,  9 Feb 2026 14:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648907;
	bh=SH+SibIqnc74Rfp9InqRF28zG9b3mNOyWJFZ/1cpycw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pL/7WrT6/cew2rrnZ0z3IX8ET3TNryusq/nQYy4n93TfG+uV0Qtz+A19S88vn7TPX
	 rBtN7GwrNUhr1OqQc3Hgpu+OjQspVluHzCVoac7QUWsPYXtKwZAguhbCMzrQOaTzEt
	 Kg2t6elhz2CIoHR9ZsJmOJVm+mzzPKyIYyvFCjAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 50/75] dpaa2-switch: add bounds check for if_id in IRQ handler
Date: Mon,  9 Feb 2026 15:24:47 +0100
Message-ID: <20260209142303.645881634@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 31a7a0bbeb006bac2d9c81a2874825025214b6d8 ]

The IRQ handler extracts if_id from the upper 16 bits of the hardware
status register and uses it to index into ethsw->ports[] without
validation. Since if_id can be any 16-bit value (0-65535) but the ports
array is only allocated with sw_attr.num_ifs elements, this can lead to
an out-of-bounds read potentially.

Add a bounds check before accessing the array, consistent with the
existing validation in dpaa2_switch_rx().

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reported-by: Junrui Luo <moonafterrain@outlook.com>
Fixes: 24ab724f8a46 ("dpaa2-switch: use the port index in the IRQ handler")
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB7881D420AB43FF1A227B84AFAF91A@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index dcb96c2b2820a..5c7055a4acc6f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1509,6 +1509,10 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 	}
 
 	if_id = (status & 0xFFFF0000) >> 16;
+	if (if_id >= ethsw->sw_attr.num_ifs) {
+		dev_err(dev, "Invalid if_id %d in IRQ status\n", if_id);
+		goto out;
+	}
 	port_priv = ethsw->ports[if_id];
 
 	if (status & DPSW_IRQ_EVENT_LINK_CHANGED) {
-- 
2.51.0



