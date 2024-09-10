Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602BF18B46D;
	Tue, 10 Sep 2024 09:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961297; cv=none; b=KJM5xthn4Yvy/6LCoI3GRVNh9+aXyzkExSVTjM1tPkhmy67A1vI0KdnxwEs03KAQdJ+VqOh6eXUY1wfOrNsOoBfbv3AymbYBQPHx+Bg6w0RfkiToON9wDuHraXsN5wBqcFqSIbn5h7ESRT8YqLDbSOB/uMSBHw7tkpfOTUNPH+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961297; c=relaxed/simple;
	bh=kZrXfRlgGR/yWZKUjBZnrB7043pIiNT13zGjGXDL7IQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQt3iHF81oJTdZUz5aDtIVFD86Jn+J5p+5b7BUeG+WMwq4/y/d/btns/VXvD7cqMnUqMT1UXXQEpzdKWXxDbHgISntU5hO6/ukerTKnZ/hnku0EuKcb/fkiQV79iGJijFXGb5Oi2K70TWA/bLsQrVSXcb2zXXv/wQmPVDSIfaqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nuIp3GRQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nuIp3GRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B5AC4CEC3;
	Tue, 10 Sep 2024 09:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961297;
	bh=kZrXfRlgGR/yWZKUjBZnrB7043pIiNT13zGjGXDL7IQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nuIp3GRQLAVzpJqzwpWE7OcHnIN67taL49kRJ1Pyg0a/VnTDQ2ev9Dcq3nGvVMFk8
	 +pr+8NA5SxCVnvLoFigsE1ICzJ9y4v05+WNSjOTKXtM3Uw0dIbYzufnXBnl1Ay1sMF
	 8vYcCsSnE/6vNkbwx6ugjHELu2te89lfCs07eXPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.10 023/375] irqchip/gic-v2m: Fix refcount leak in gicv2m_of_init()
Date: Tue, 10 Sep 2024 11:27:00 +0200
Message-ID: <20240910092623.051356943@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit c5af2c90ba5629f0424a8d315f75fb8d91713c3c upstream.

gicv2m_of_init() fails to perform an of_node_put() when
of_address_to_resource() fails, leading to a refcount leak.

Address this by moving the error handling path outside of the loop and
making it common to all failure modes.

Fixes: 4266ab1a8ff5 ("irqchip/gic-v2m: Refactor to prepare for ACPI support")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240820092843.1219933-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v2m.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -438,12 +438,12 @@ static int __init gicv2m_of_init(struct
 
 		ret = gicv2m_init_one(&child->fwnode, spi_start, nr_spis,
 				      &res, 0);
-		if (ret) {
-			of_node_put(child);
+		if (ret)
 			break;
-		}
 	}
 
+	if (ret && child)
+		of_node_put(child);
 	if (!ret)
 		ret = gicv2m_allocate_domains(parent);
 	if (ret)


